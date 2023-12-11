---
title : "b. Run GPT3 on AWS ParallelCluster"
date: 2020-09-04T15:58:58Z
weight : 30
tags : ["training", "data parallel", "ML", "sbatch", "slurm", "multi node", "multi gpu", "GPT3"]
---

# NeMo

The base container `bignlp-training` is still in beta (as of this writing), so you need to register
an NVidia account to pull this Docker image. You'll extend the `bignlp-training` image with
AWS-specific stuffs, such as EFA, etc. (TODO: the EFA install in the
[Dockerfile](nemo4aws/Dockerfile) can still be improved to make it work with the latest release).

Relevant scripts can be found on folder [nemo4aws](nemo4aws).

The general philosophy is straightforward: under normal circumstances, `bignlp-training` contains a
script. When ran, the container (i) generates a submit script (which calls either `srun` or `bcp`),
then (ii) immediately runs that submit script. It seems that NVidia NGC/GCP inject/mount `bcp` or
`srun` into the running container, because those commands are not built into the image.

On PC, what we've done is to make `bignlp-training` performs only step (i), then we invoke an `srun`
command (at AMI/instance level) to run an enroot container using the command generated by step (i)
-- see [nemo-megatron-v2.sbatch](nemo4aws/nemo-megatron-v2.sbatch). Note that we also experimented
bypassing step (i), by directly starting the actual Nemo script using `torchrun`
([run.sh](nemo4aws/run.sh) and [nemo-megatron.sbatch](nemo4aws/nemo-megatron.sbatch)) -- this seems
to work, but probably we need to restore some optimized NVidia settings or env-vars that the
`bignlp-training` script generates. It should be noted that for some reason, `bignlp-training` only
allows you to generate `torchrun`-based submit script for single node, but in our experiment we
observe that we can actually `torchrun`-ed Nemo for multiple nodes.

You can submit jobs to PC using `sbatch nemo-megatron-v2.sbatch` (the `srun` version, which is as
close as it can to the original `bignlp-training`, or `sbatch nemo-megatron.sbatch` (the `torchrun`
version). Each `.sbatch` script has default hyperparameters, which you can override by setting
environment variables. See
[submit-gpt3-175b16-nccl_stock.sh](nemo4aws/submit-gpt3-175b16-nccl_stock.sh) for an example of
setting hyperparameters for the `torchrun`-based `nemo-megatron.sbatch`.

## 1. Quickstart

All these steps are to be done on the head node.

### 1.1. Prepare the Pile dataset

A copy of dataset in the Nemo-Megatron format (i.e., `.{bin,idx}` files) are stored on
`s3://frameworks-shared-bucket/data/the_pile_gpt3/`. Download these to the FSx Lustre as follows:

```bash
s5cmd sync 's3://frameworks-shared-bucket/data/bpe/*' /fsx/data/bpe/

# Below timing is on head node m5.8xlarge. Intra-region copy us-east-1.

/usr/bin/time s5cmd sync 's3://frameworks-shared-bucket/data/the_pile_gpt3/*.idx' /fsx/data/the_pile_gpt3/
# 4.00user 13.34system 0:04.78elapsed 362%CPU (0avgtext+0avgdata 37108maxresident)k
# 2855376inputs+7954112outputs (0major+7599minor)pagefaults 0swaps

/usr/bin/time s5cmd sync 's3://frameworks-shared-bucket/data/the_pile_gpt3/*.bin' /fsx/data/the_pile_gpt3/
# 605.89user 3384.71system 19:09.46elapsed 347%CPU (0avgtext+0avgdata 69656maxresident)k
# 25209576inputs+1462271680outputs (0major+60785minor)pagefaults 0swaps
#
# See also the observed throughput captured in references/s3-to-fsx.png
```

Should you choose to download and pre-process the Pile dataset from scratch, please refer to
`01-prep-pile-data.sh`. The download size is 426 GB (i.e., compressed `.jsonl.zst` files), and
extacted to 850 GB of `.jsonl` files. After processed into `.{bin,idx}` files, the final size is 702
GB. It took ~10.5h on 2x `c5.24xlarge` to download, extract, and process the dataset. Majority of
the time (~8h) were incurred by processing step. See `01-prep-pile-data.sh` for the runtime
statistics (as comments).

### 1.2. Training

Build enroot container on the PC headnode:

```bash
cd docker/

docker login nvcr.io
# ... Enter your username and API key to NGC.

docker pull nvcr.io/ea-bignlp/bignlp-training:22.09-py3

# Build Docker image
docker build . \
    -t 111122223333.dkr.ecr.us-east-1.amazonaws.com/bignlp-training:22.09-py3-bcp-nsys-2022.5.1-v2-efa

# Convert Docker image to enroot image. Timing on head node m5.8xlarge.
/usr/bin/time enroot import \
    -o /apps/bignlp-training_22.09-py3-bcp-nsys-2022.5.1-v2-efa.sqsh \
    dockerd://111122223333.dkr.ecr.us-east-1.amazonaws.com/bignlp-training:22.09-py3-bcp-nsys-2022.5.1-v2-efa
# 13.39user 53.30system 2:51.89elapsed 38%CPU (0avgtext+0avgdata 688284maxresident)k
# 0inputs+67630496outputs (0major+200814minor)pagefaults 0swaps
```

Next, ensure that the `p4de` partition is up:

```console
$ pcluster describe-compute-fleet --cluster-name benchmarking-megatron --region us-east-1
{
  "status": "RUNNING",
  "lastStatusUpdatedTime": "2023-01-16T08:23:13.093Z"
}
```

Otherwise, on your local environment with parallel cluster installed (i.e., **not** the head node),
start the partition using the `pcluster update-compute-fleet`, and once-in-a-while check that its
status is `RUNNING` using the `pcluster describe-compute-fleet` command.

```console
$ pcluster update-compute-fleet --cluster-name benchmarking-megatron --status START_REQUESTED --region us-east-1
{
  "status": "START_REQUESTED",
  "lastStatusUpdatedTime": "2023-01-16T08:22:25.337Z"
}
```

Once the enroot image and `p4de` partition are ready, submit a job either directly using `sbatch`:

```bash
sbatch --nodes=2 nemo-megatron.sbatch
```

or simply run one of the git-versioned submit script such as `submit-gpt3-04b8-nccl_stock.sh`. You
can add new submit scripts, then git-version them to promote readability and reproducability.

Lastly, be a good citizen by stopping the partition so other users in the AWS account can use the
`p4de` instances by running the following command on your parallel-cluster client machine:

```console
$ pcluster update-compute-fleet --cluster-name benchmarking-megatron --status STOP_REQUESTED --region us-east-1
{
  "status": "STOP_REQUESTED",
  "lastStatusUpdatedTime": "2023-01-16T08:55:01.745Z"
}
```

## 2. Storage Layout

The PC (Parallel Cluster) provides these shared volumes:

```yaml
SharedStorage:
  - MountDir: /fsx
    Name: fsx
    StorageType: FsxLustre
    FsxLustreSettings:
      StorageCapacity: 4800
      DeploymentType: "SCRATCH_2"
  - Name: SharedEBS
    StorageType: Ebs
    MountDir: /apps
    EbsSettings:
      VolumeType: gp3
      Size: 200
      Throughput: 300
      Iops: 6000
```

## 3. Appendix

### 3.1. Frequently Used Commands

Assume `pwd` is `GITROOT`.

```bash

sinfo -o "%20N  %10c  %10m  %25f  %10G"

squeue --format="%.18i %.9P %.30j %.8u %.8t %.10M %.9l %.6D %R"

scancel <JOB_ID>

egrep 'export (MODEL_NAME|MODEL_SIZE|NODE|MAX_STEP|IMAGE)' submit*sh


find /fsx/results/ -name joblog.log | xargs grep -m1 JOB_ID | sort
```

### 3.2. Docker Images

- `159553542841.dkr.ecr.us-east-1.amazonaws.com/bignlp-training:22.09-py3-bcp-nsys-2022.5.1-v2-efa`
  uses built-in nccl which is `NCCL_VERSION=2.12.12`. The `Dockerfile` can be checked-out from
  git-tag `dockerfile-22.09-py3-bcp-nsys-2022.5.1-v2-efa`.


# OPT