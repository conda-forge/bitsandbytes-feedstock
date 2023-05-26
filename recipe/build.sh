#!/bin/bash

set -exuo pipefail

make GPP=$CXX cpuonly

if [[ "${cuda_compiler_version}" = 10.* ]]; then
  make NVCC="${CUDA_HOME}/bin/nvcc -ccbin=${CC}" GPP=$CXX CUDA_VERSION=${cuda_compiler_version/./} cuda110
elif [[ "${cuda_compiler_version}" = 11.* ]]; then
  make NVCC="${CUDA_HOME}/bin/nvcc -ccbin=${CC}" GPP=$CXX CUDA_VERSION=${cuda_compiler_version/./} cuda11x
elif [[ "${cuda_compiler_version}" = 12.* ]]; then
  make NVCC="${CUDA_HOME}/bin/nvcc -ccbin=${CC}" GPP=$CXX CUDA_VERSION=${cuda_compiler_version/./} cuda12x
fi

python setup.py install
