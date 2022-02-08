#!/bin/bash

# Cleans the infrastructure built by runGen.sh

generatedDirNames=( "cOut_rev1BB_rx_dut" )
RxSrcs=( "rev1BB_rx_dut" )
runDirName="testHarnessRun"
netClientFileName="dut_network_client"
compilerInfoName="compilerInfo.txt"
buildLogName="buildLog.log"

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

cleanVitis=false
while getopts ::a option; do
    case $option in
        a) cleanVitis=true;;
        ?) echo "Unknown option: $option"; exit 1;;
    esac
done

#Remove Generated Dirs
for genDirName in ${generatedDirNames[@]}
do
    if [[ -e $buildDir/$genDirName ]]; then
        echo "Removed $genDirName"
        rm -r $buildDir/$genDirName
    fi
done

for srcFile in ${RxSrcs[@]}
do
    if [[ -e $buildDir/${srcFile}_vitis.graphml ]]; then
        echo "Removed ${srcFile}_vitis.graphml"
        rm -r $buildDir/${srcFile}_vitis.graphml
    fi
done

#Remove runDir
if [[ -e $buildDir/$runDirName ]]; then
    echo "Removed $runDirName"
    rm -r $buildDir/$runDirName
fi

#Remove Network Client Files
if [[ -e $buildDir/$runDirName ]]; then
    echo "Removed $runDirName"
    rm -r $buildDir/$runDirName
fi

#Remove old build log and compiler info
if [[ -e $buildDir/$compilerInfoName ]]; then
    echo "Removed $compilerInfoName"
    rm -r $buildDir/$compilerInfoName
fi

#Remove old network client files
if [[ -e $buildDir/$netClientFileName ]]; then
    echo "Removed $netClientFileName"
    rm -r $buildDir/$netClientFileName
fi

if [[ $cleanVitis == true ]]; then
    if [[ -e $buildDir/../submodules/vitis/build ]]; then
        echo "Removed vitis/build"
        rm -rf $buildDir/../submodules/vitis/build
    fi
else
    echo "**** NOTE: To clean vitis, run script with -a flag ****"
fi

cd $oldDir