#!/bin/bash

set -exuo pipefail

make GPP=$CXX cpuonly

if [[ "${cuda_compiler_version}" = 10.* ]]; then
  make NVCC="${CUDA_HOME}/bin/nvcc -ccbin=${CC}" GPP=$CXX CUDA_VERSION=${cuda_compiler_version/./} cuda10x_nomatmul
elif [[ "${cuda_compiler_version}" = "11.0" ]]; then
  make NVCC="${CUDA_HOME}/bin/nvcc -ccbin=${CC}" GPP=$CXX CUDA_VERSION=${cuda_compiler_version/./} cuda110
elif [[ "${cuda_compiler_version}" = 11.* ]]; then
  make NVCC="${CUDA_HOME}/bin/nvcc -ccbin=${CC}" GPP=$CXX CUDA_VERSION=${cuda_compiler_version/./} cuda11x
elif [[ "${cuda_compiler_version}" = 12.* ]]; then
  export CXXFLAGS="-I$PREFIX/targets/x86_64-linux/include $CXXFLAGS"
  INCLUDE="-I$PREFIX/targets/x86_64-linux/include -I$BUILD_PREFIX/targets/x86_64-linux/include -I${SRC_DIR}/csrc -I${PREFIX}/include -I${SRC_DIR}/include"
  make NVCC="${BUILD_PREFIX}/bin/nvcc -ccbin=${CC}" GPP=$CXX CUDA_VERSION=${cuda_compiler_version/./} CONDA_PREFIX=$PREFIX CUDA_HOME=$PREFIX/targets/x86_64-linux INCLUDE="${INCLUDE}" cuda12x
fi

python setup.py install
