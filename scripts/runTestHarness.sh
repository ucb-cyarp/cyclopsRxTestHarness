#!/bin/bash

RxSrc=rev1BB_rx_dut
DUT_NAME="rx_dut"

runDirName="testHarnessRun"

curDir=`pwd`
RxDir=${curDir}/cOut_${RxSrc}

if [[ -d ${runDirName} ]]; then
	echo "rm -r ${runDirName}"
	rm -r ${runDirName}
fi
mkdir ${runDirName}
cd ${runDirName}
#Start vitis generated code
mkdir rx_dut
cd rx_dut
module load papi; ${RxDir}/benchmark_${DUT_NAME}_io_network_socket

cd ${curDir}
