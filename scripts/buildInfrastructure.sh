#!/bin/bash

# Builds infrastructure for test harness
# Only builds directories if build directory does not exist (with the exception of benchmarking/common which it always tries to build)

oldDir=$(pwd)

#Get build dir
scriptSrc=$(dirname "${BASH_SOURCE[0]}")
cd $scriptSrc
scriptSrc=$(pwd)
if [[ $(basename $scriptSrc) == scripts ]]; then
    cd ../build
    buildDir=$(pwd)
elif [[ $(basename $scriptSrc) == build ]]; then
    buildDir=$scriptSrc
else
    echo "Error: Unable to determine location of build directory"
    cd $oldDir
    exit 1
fi

source $buildDir/setCompilersToUse.sh

if [[ ! -e $buildDir/../submodules/vitis/build ]]; then
    echo "#### Building vitis ####"
    cd $buildDir/../submodules/vitis
    mkdir build
    cd build
    cmake -D CMAKE_C_COMPILER=$CC -D CMAKE_CXX_COMPILER=$CXX ..
    make
fi

cd $oldDir