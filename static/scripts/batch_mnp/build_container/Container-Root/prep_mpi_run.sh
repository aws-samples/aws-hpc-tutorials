#!/bin/bash

#cd $JOB_DIR
#PATH="$PATH:/opt/openmpi/bin/"
BASENAME="${0##*/}"
log () {
  echo "${BASENAME} - ${1}"
}
HOST_FILE_PATH="/tmp/hostfile"
AWS_EXIT_CODE_FILE="/tmp/ecs-exit-code"

# aws s3 cp $S3_INPUT $SCRATCH_DIR
# tar -xvf $SCRATCH_DIR/*.tar.gz -C $SCRATCH_DIR
#sleep 2

usage () {
  if [ "${#@}" -ne 0 ]; then
    log "* ${*}"
    log
  fi
  cat <<ENDUSAGE
Usage:
export AWS_BATCH_JOB_NODE_INDEX=0
export AWS_BATCH_JOB_NUM_NODES=10
export AWS_BATCH_JOB_MAIN_NODE_INDEX=0
export AWS_BATCH_JOB_ID=string
./prep_mpi_run.sh
ENDUSAGE

  error_exit
}

# Standard function to print an error and exit with a failing return code
error_exit () {
  log "${BASENAME} - ${1}" >&2
  log "${2:-1}" > $AWS_EXIT_CODE_FILE
#  kill  $(cat /tmp/supervisord.pid)
}

# Set child by default switch to main if on main node container
NODE_TYPE="child"
if [ "${AWS_BATCH_JOB_MAIN_NODE_INDEX}" == "${AWS_BATCH_JOB_NODE_INDEX}" ]; then
  log "Running synchronize as the main node"
  NODE_TYPE="main"
fi

# wait for all nodes to report
wait_for_nodes () {
  log "Running as master node"

  touch $HOST_FILE_PATH
  ip=$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)

  if [ -x "$(command -v nvidia-smi)" ] ; then
      NUM_GPUS=$(ls -l /dev/nvidia[0-9] | wc -l)
      availablecores=$NUM_GPUS
#      availablecores=48
  else
      availablecores=$(nproc)
  fi

  log "master details -> $ip:$availablecores"
  echo "$ip slots=$availablecores" >> $HOST_FILE_PATH

  lines=$(sort $HOST_FILE_PATH|uniq|wc -l)
  while [ "$AWS_BATCH_JOB_NUM_NODES" -gt "$lines" ]
  do
    log "$lines out of $AWS_BATCH_JOB_NUM_NODES nodes joined, check again in 1 second"
    sleep 1
    lines=$(sort $HOST_FILE_PATH|uniq|wc -l)
  done
  # Make the temporary file executable and run it with any given arguments
  log "All nodes successfully joined"

  # remove duplicates if there are any.
  awk '!a[$0]++' $HOST_FILE_PATH > ${HOST_FILE_PATH}-deduped
  cat $HOST_FILE_PATH-deduped
  log "executing main MPIRUN workflow"

  # cd /workspace
  # deepspeed --master_addr $HOSTNAME --hostfile $HOST_FILE_PATH-deduped transformers/examples/pytorch/translation/run_translation.py --deepspeed transformers/tests/deepspeed/ds_config_zero2.json --model_name_or_path t5-base --per_device_train_batch_size 4 --cache_dir $HF_DATASETS_CACHE --output_dir /efs --overwrite_output_dir --fp16 --do_train --max_train_samples 500 --num_train_epochs 10 --dataset_name wmt16 --dataset_config "ro-en" --source_lang en --target_lang ro
  # sleep 1200
  while true; do date; sleep 60; done

  log "done! goodbye, writing exit code to $AWS_EXIT_CODE_FILE and shutting down my supervisord"
  echo "0" > $AWS_EXIT_CODE_FILE
  kill  $(cat /tmp/supervisord.pid)
  exit 0
}


# Fetch and run a script
report_to_master () {
  # get own ip and num cpus
  #
  ip=$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)

  if [ -x "$(command -v nvidia-smi)" ] ; then
      NUM_GPUS=$(ls -l /dev/nvidia[0-9] | wc -l)
      availablecores=$NUM_GPUS
#      availablecores=48
  else
      availablecores=$(nproc)
  fi

  log "I am a child node -> $ip:$availablecores, reporting to the master node -> ${AWS_BATCH_JOB_MAIN_NODE_PRIVATE_IPV4_ADDRESS}"
  until echo "$ip slots=$availablecores" | ssh ${AWS_BATCH_JOB_MAIN_NODE_PRIVATE_IPV4_ADDRESS} "cat >> $HOST_FILE_PATH"
  do
    echo "Sleeping 5 seconds and trying again"
    sleep 5
  done
  log "done! goodbye"
  exit 0
  }


# Main - dispatch user request to appropriate function
log $NODE_TYPE
case $NODE_TYPE in
  main)
    wait_for_nodes "${@}"
    ;;

  child)
    report_to_master "${@}"
    ;;

  *)
    log $NODE_TYPE
    usage "Could not determine node type. Expected (main/child)"
    ;;
esac