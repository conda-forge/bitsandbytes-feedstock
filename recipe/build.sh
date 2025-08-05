#!/bin/bash

set -exuo pipefail

# bitsandbytes' cmake config will produce only one .so per backend build
# but we always need the generic "cpu" backend even for CUDA-enabled builds or import will fail
# if in an environment with CUDA but without a GPU

# Build the generic "cpu" backend
# this will create libbitsandbytes_cpu.so in the the bitsandbytes folder
mkdir -p build/cpu
pushd build/cpu
cmake ${CMAKE_ARGS} -DCOMPUTE_BACKEND=cpu -GNinja ../..
ninja
popd

# CUDA enabled build. This will create libbitsandbytes_cuda.so
# Even in a CUDA build we will still bundle the _cpu.so as a fallback if no GPUs are available
if [[ "${cuda_compiler_version:-None}" != "None" ]]; then
  mkdir -p build/cuda
  pushd build/cuda
  cmake ${CMAKE_ARGS} -DCOMPUTE_BACKEND=cuda -DCOMPUTE_CAPABILITY="50;60;70;75;80;86;90;100;120" -GNinja ../..
  ninja
  popd
fi

# This will automatically pull in all .so files we've built
# on a CPU only build this will only be one .so, on CUDA both the CPU and CUDA variants
pip install --no-deps --no-build-isolation -vvv .
