#!/bin/bash

set -exuo pipefail

if [[ "${cuda_compuiler_version:-None}" != "None" ]]; then
    export CMAKE_ARGS="${CMAKE_ARGS} -DBUILD_CUDA=ON"
else
    export CMAKE_ARGS="${CMAKE_ARGS} -DBUILD_CUDA=OFF"
fi

mkdir -p build
pushd build
cmake ${CMAKE_ARGS} -GNinja ..
ninja
popd

pip install --no-deps --no-build-isolation -vvv .
