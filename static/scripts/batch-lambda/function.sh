function handler () {
	  program=$1
	  s3Bucket=$2
	  s3Key=$3
	  # some variables to be used for this project
	  projectJD=fsi-demo
	  prefix=EquityOption_
    suffix=.csv
    # Number of records to be processed for a single process.
    # Default to 10 and it can be overwritten with environment variable of JD.
	  echo The current threshold for a single job to process is: ${threshold:=10}

    if [[ -z ${AWS_BATCH_JOB_ARRAY_INDEX+x} ]]; then # for both lambda and main batch process
	    aws s3 cp s3://$s3Bucket/$s3Key /tmp/input
	  else # the directory name is provided for the batch job array
	    fileName=${prefix}$(printf "%06d" $AWS_BATCH_JOB_ARRAY_INDEX)$suffix
	    s3Key=$s3Key/$fileName # update the S3 key depending on array index
	    aws s3 cp s3://$s3Bucket/$s3Key /tmp/input 1>&2
    fi

    NoOfRows=$(( $(wc -l /tmp/input | awk '{print $1}') -1 ))
    echo "There are $NoOfRows equities." 1>&2

    if [[ $NoOfRows -gt $((10000*$threshold)) ]]; then
       echo "The row count is beyond limit. Please increase the threshold" 1>&2
       exit 1
    fi

    if [[ $NoOfRows -gt $threshold ]]; then

      mkdir -p /tmp/splitFiles

      if [[ -z ${AWS_BATCH_JOB_ID+x} ]]; then # Lambda jobs are triggered again

        S3SplitDir=$(dirname $s3Key)-split

        # Split the input file to process in parallel
    	  tail -n +2 /tmp/input | split -d -l $threshold -  $prefix  -a 6 \
    	  --additional-suffix=$suffix \
    	  --filter='sh -c "{ head -n1 /tmp/input; cat; } > /tmp/splitFiles/$FILE"'

    	  # Submit splitted input to run in parallel for lambda
    	  [[ $? == 0 ]] && aws s3 cp --rec /tmp/splitFiles s3://$s3Bucket/$S3SplitDir/
  
      else # Run with Batch job array for large scale.
      
        # Use a different prefix to avoid triggering an individual Batch job
        S3SplitDir=split-$(dirname $s3Key)
        
        # Split the input file to process in parallel
    	  tail -n +2 /tmp/input | split -d -l $threshold -  $prefix  -a 6 \
        --additional-suffix=${suffix} \
    	  --filter='sh -c "{ head -n1 /tmp/input; cat; } > /tmp/splitFiles/$FILE"'
    	  
    	  # Copy the input files to S3 for Batch job array to process
    	  [[ $? == 0 ]] && aws s3 cp --rec /tmp/splitFiles s3://$s3Bucket/$S3SplitDir/
    	  
    	  NoOfFiles=$(ls /tmp/splitFiles/ | wc -l)

    	  # Submit the job with a Batch job array
    	  aws batch submit-job --job-name $AWS_BATCH_JOB_ID-jobArray \
    	  --job-queue $AWS_BATCH_JQ_NAME --job-definition $projectJD \
    	  --parameters S3bucket=$s3Bucket,S3key=$S3SplitDir \
    	  --array-properties size=$NoOfFiles
      fi # end of main Batch process

	# A busy waiting loop until all the split files are processed (deleted on S3)
    	remaining=-1
    	while [[ $remaining != 0  ]]
    	do
    	   remaining=$(aws s3 ls s3://$s3Bucket/$S3SplitDir/ | wc -l| awk '{print $1}')
    	   echo "There are $remaining remaining tasks" 1>&2
    	   sleep 5
    	done

    	# Concatenate the result and publish to S3
    	aws s3 cp --rec s3://$s3Bucket-result/$S3SplitDir/ /tmp/splitResult/
    	cd /tmp/splitResult
    	
    	echo find  . -type f -exec awk 'NR==1 || FNR!=1' {} + >> /tmp/result.csv 1>&2
    	find  . -type f -exec awk 'NR==1 || FNR!=1' {} + >> /tmp/result.csv
    	
    	# Clean up temporary result
    	echo aws s3 rm --rec s3://$s3Bucket-result/$S3SplitDir/ 1>&2
      aws s3 rm --rec s3://$s3Bucket-result/$S3SplitDir/

    else # Do simulations when the equity number is less than the threshold
      echo "Start to run simulations" 1>&2
      # MC simulations
		  $program /tmp/input
		  echo "finished simulations" 1>&2
    fi

    # post result to S3
    aws s3 cp /tmp/result.csv s3://$s3Bucket-result/$s3Key-result

    # delete the input file on S3
    echo aws s3 rm s3://$s3Bucket/$s3Key 1>&2
    aws s3 rm s3://$s3Bucket/$s3Key
	}
