#!/bin/bash

export NUM_GPUS=1
export NCCL_DEBUG=info
export MPI_HOME=/usr/local/mpi

MPI_HOME=/usr/local/mpi/bin/mpirun --allow-run-as-root -np $NUM_GPUS \
    /workspace/nccl-tests/build/all_reduce_perf \
    -g 1 -b 8 -e 4GB -f 2 -n 100

for collective in all_reduce all_gather broadcast reduce_scatter all_to_all ; do
    echo "TESTING COLLECTIVE: $collective"
    MPI_HOME=/usr/local/mpi/bin/mpirun --allow-run-as-root -np $NUM_GPUS \
        python param/train/comms/pt/comms.py \
        --b 8 --e 1G --n 100 --f 2 --z 1 --collective $collective \
        --backend nccl --device cuda --log INFO
done