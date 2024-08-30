#!/bin/bash

set -exuo pipefail

if [[ "${cuda_compuiler_version:-None}" != "None" ]]; then
  export CMAKE_ARGS="${CMAKE_ARGS} -DCOMPUTE_BACKEND=cuda"
else
  export CMAKE_ARGS="${CMAKE_ARGS} -DCOMPUTE_BACKEND=cpu"
fi

mkdir -p build
pushd build
cmake ${CMAKE_ARGS} -GNinja ..
ninja
popd

pip install --no-deps --no-build-isolation -vvv .
