#!/bin/bash -x

# Reference to step-by-step data preparation. Please adapt as needed.
#
# On an EC2 with alinux2 AMI that's been initdlami-ed, run:
# /usr/bin/time ./01-prep-pile-data.sh 2>&1 | tee 00.txt
#
# Variations:
# BEGIN=1 END=14 /usr/bin/time ./01-prep-pile-data.sh 2>&1 | tee 00.txt
# BEGIN=15 /usr/bin/time ./01-prep-pile-data.sh 2>&1 | tee 01.txt
#
# Timings recorded were from a c5.24xlarge @ us-east-1, and s3 bucket also in us-east-1.


################################################################################
# Global variables. Change these as needed.
################################################################################
: "${BEGIN:=0}"
: "${END:=29}"
: "${S3:=s3://frameworks-shared-bucket}"
: "${IMAGE:=159553542841.dkr.ecr.us-east-1.amazonaws.com/bignlp-training:22.09-py3-bcp-nsys-2022.5.1-v2}"
: "${DATA_DIR:=$HOME/data}"


################################################################################
# 000. Preamble
################################################################################
mkdir -p $DATA_DIR/the_pile_gpt3/
cd $DATA_DIR/the_pile_gpt3/
sudo yum install -y zstd
aws s3 sync --quiet $S3/data/bpe/ $DATA_DIR/bpe/


################################################################################
# 010. Download .jsonl.zst (15GB/file)
#-------------------------------------------------------------------------------
# Took 7m-8m to download each file.
################################################################################
echo "Downloading .jsonl.zst"
for i in $(seq --format '%02g' $BEGIN $END); do
    /usr/bin/time curl -O -C - https://the-eye.eu/public/AI/pile/train/$i.jsonl.zst
done

# NOTE: sha256sum of 15 files took 13.5 minutes. Only 1-core utilized.
/usr/bin/time sha256sum *.jsonl.zst

# NOTE: Uploading 15 files took 3 min.
/usr/bin/time s5cmd sync '*.jsonl.zst' $S3/data/the_pile_gpt3/


################################################################################
# 020. Extract .jsonl.zst to .jsonl.
#-------------------------------------------------------------------------------
# unzstd produces a 43GB .jsonl in 2min (only 1-core utilized).
################################################################################
echo "Extracting to .jsonl, each of which is 43GB. Took about 1.5m/file on c5.24xlarge."
for i in $(seq --format '%02g' $BEGIN $END); do
    /usr/bin/time unzstd $i.jsonl.zst
    rm $i.jsonl.zst
done


################################################################################
# 030. Convert .jsonl to mmap files *.{bin,idx}.
#-------------------------------------------------------------------------------
# Processing took ~30m/file. All 48 cores utilized.
################################################################################
echo 'Converting .jsonl to .{bin,idx} files...'
/usr/bin/time aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${IMAGE%/*}
docker pull ${IMAGE}

/usr/bin/time unzstd $i.jsonl.zst
docker run -it -v $DATA_DIR:/mount/data --rm $IMAGE /bin/bash -c "
cd /opt/bignlp/bignlp-scripts ;
apt update && apt install -y time ;
OMPI_COMM_WORLD_SIZE=1 /usr/bin/time python3 -u /opt/bignlp/bignlp-scripts/bignlp/collections/dataprep_scripts/pile_dataprep/preprocess.py \
  data_config=download_gpt3_pile \
  cluster_type=bcp \
  bignlp_path=/opt/bignlp/bignlp-scripts \
  data_dir=/mount/data/the_pile_gpt3 \
  the_pile_url=https://the-eye.eu/public/AI/pile/train/ \
  file_numbers=$BEGIN-$END \
  tokenizer_type=GPT2BPETokenizer \
  vocab_save_dir=/mount/data/bpe \
  merges_save_dir=/mount/data/bpe \
  rm_downloaded=False \
  rm_extracted=True
"
sudo chown ec2-user:ec2-user *.bin *.idx

#######
# 1-14:
#######
# 986796.64user 4606.14system 7:15:38elapsed 3792%CPU (0avgtext+0avgdata 16525912maxresident)k
# 1247412038inputs+685638248outputs (11061major+356803698minor)pagefaults 0swaps
# 55.70user 67.72system 7:15:47elapsed 0%CPU (0avgtext+0avgdata 59300maxresident)k
# 118699inputs+8outputs (514major+40877minor)pagefaults 0swaps

# /usr/bin/time s5cmd cp 'my-gpt3*text_document.*' s3://frameworks-shared-bucket/data/the_pile_gpt3/
# 2332.60user 757.39system 9:27.66elapsed 544%CPU (0avgtext+0avgdata 1712220maxresident)k
# 585456928inputs+0outputs (23major+85901902minor)pagefaults 0swaps

# /usr/bin/time sha256sum *.bin *.idx 2>&1 | tee sha256sums-bin-idx.txt
# 1128.74user 102.84system 32:07.47elapsed 63%CPU (0avgtext+0avgdata 3040maxresident)k
# 444316800inputs+0outputs (2major+160minor)pagefaults 0swaps

########
# 15-29:
########
# 1069769.16user 5051.98system 7:52:58elapsed 3787%CPU (0avgtext+0avgdata 27057956maxresident)k
# 1317449923inputs+735839304outputs (11400major+398049623minor)pagefaults 0swaps
# 62.88user 68.73system 7:53:07elapsed 0%CPU (0avgtext+0avgdata 59032maxresident)k
# 129641inputs+8outputs (585major+41613minor)pagefaults 0swaps

# /usr/bin/time s5cmd cp 'my-gpt3*text_document.*' s3://frameworks-shared-bucket/data/the_pile_gpt3/
# 2529.50user 820.36system 8:42.31elapsed 641%CPU (0avgtext+0avgdata 3316056maxresident)k
# 538441744inputs+0outputs (118major+88235028minor)pagefaults 0swaps

# /usr/bin/time sha256sum *.bin *.idx 2>&1 | tee sha256sums-bin-idx.txt
# 1100.25user 105.96system 31:08.04elapsed 64%CPU (0avgtext+0avgdata 2928maxresident)k
# 522703096inputs+0outputs (2major+158minor)pagefaults 0swaps
