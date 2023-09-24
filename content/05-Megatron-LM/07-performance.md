---
title: "e. Performance Statistics"
weight: 16
draft: true
tags: ["tutorial", "cloud9", "ParallelCluster"]
---

<!-- | **Instance Type** | Num Instances | **Tensor Parallelism** | **Pipeline Parallelism** | Layers | Hidden Size | Attention Heads | Sequence Length | Max embeddings | Micro batch size | Global batch size | Time per-iteration (ms) |     |         |
|-------------------|---------------|------------------------|--------------------------|--------|-------------|-----------------|-----------------|----------------|------------------|-------------------|-------------------------|-----|---------|
| p4de.24xlarge     | 2             |                        |                          |        |             |                 |                 |                |                  |                   |                         |     |         |
| p5.48xlarge       | 2             | p5.48xlarge            | 2                        | 8      | 24          | 36              | 4096            | 32             | 2048             | 2048              | 1                       | 288 | 20763.4 | -->

| **Instance Type** | Num Instances | **Tensor Parallelism** | **Pipeline Parallelism** | Layers | Hidden Size | Attention Heads | Sequence Length | Max embeddings | Micro batch size | Global batch size | Time per-iteration (ms) |
|-------------------|---------------|------------------------|--------------------------|--------|-------------|-----------------|-----------------|----------------|------------------|-------------------|-------------------------|
| p5.48xlarge       | 2             | 8                      | 24                       | 36     | 4096        | 32              | 2048            | 2048           | 1                | 288               | 20763.4                 |


<!-- ```sbatch
1:  iteration      106/  508626 | consumed samples:        30528 | elapsed time per iteration (ms): 20763.4 | learning rate: 8.493E-06 | global batch size:   288 | lm loss: 7.450956E+00 | loss scale: 131072.0 | grad norm: 3.476 | number of skipped iterations:   0 | number of nan iterations:   0 |
1:  iteration      107/  508626 | consumed samples:        30816 | elapsed time per iteration (ms): 20721.2 | learning rate: 8.588E-06 | global batch size:   288 | lm loss: 7.500446E+00 | loss scale: 131072.0 | grad norm: 3.344 | number of skipped iterations:   0 | number of nan iterations:   0 |
1:  iteration      108/  508626 | consumed samples:        31104 | elapsed time per iteration (ms): 20631.8 | learning rate: 8.682E-06 | global batch size:   288 | lm loss: 7.482114E+00 | loss scale: 131072.0 | grad norm: 4.288 | number of skipped iterations:   0 | number of nan iterations:   0 |
``` -->
