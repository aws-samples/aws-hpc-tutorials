---
title : "c. Run single node data preprocessing with Slurm"
date: 2020-09-04T15:58:58Z
weight : 20
tags : ["preprocessing", "data", "ML", "srun", "slurm"]
---

In this section, you will run a data preprocessing step using the `fairseq` command line tool and `srun`. Fairseq provides the `fairseq-preprocess` that creates a vocabulary and binarizes the training dataset. For more information on the **Fairseq** command line tools refer to [the documentation](https://fairseq.readthedocs.io/en/latest/command_line_tools.html).

#### Creating a Preprocessing Script

Create a `fairseq-preprocess` script in the _/lustre_ shared folder with the following commands:

```bash
cd /lustre
export TEXT=/lustre/wikitext-103
cat > preprocess.sh << EOF
#!/bin/bash

fairseq-preprocess \
    --only-source \
    --trainpref $TEXT/wiki.train.tokens \
    --validpref $TEXT/wiki.valid.tokens \
    --testpref $TEXT/wiki.test.tokens \
    --destdir /lustre/data/wikitext-103 \
    --workers 48
EOF

chmod +x preprocess.sh
```

The main arguments are the **destination directory** and the **workers count**. Take note of the **destination directory** as you'll use it as the path to the training data in the coming sections. The **workers** argument parallelize the data preprocessing over CPUs. The compute fleet runs _p3dn.24xlarge_ instances with 48 vCPUS.   

This single line script is available to all compute nodes at the _/lustre_ directory and can be executed through an `srun` command.

#### Executing the Preprocessing Script

Before running the preprocessing, check if **SLURM** is available and the queue is empty by running `sinfo -ls` and `squeue -ls`. At this stage you should have _ZERO_ compute nodes and an empty queue.

To preprocess the data on a new compute node run the following command:

```bash
cd /lustre
srun --exclusive -n 1 preprocess.sh
```

The `srun` command requests allocation for one task, `-n 1`, and runs the job in a node with no other jobs running, `--exclusive`. For more information and options to control jobs in **SLURM**, check the [`srun` documentation](https://slurm.schedmd.com/srun.html). You will see the output of the preprocessing script in your terminal.

With 48 workers, the preprocessing completes in approximately 2 minutes, after initialization of the compute instance. As the cluster starts with _ZERO_ compute nodes, it will take around 7 minutes to start one. If AWS ParallelCluster is unable to provision new Spot instances, then a request for new instances is periodically repeated.

Once the job completes, you see a screen output similar to the following:

![Preprocessing data output](/images/ml/srun_preprocess.png)

The preprocess data is available to all compute node in the _/lustre_ directory. Run the following command to examine the data: `ls -alh /lustre/data/wikitext-103`

Next, run multi-node, multi-GPU training using the preprocessed data.
