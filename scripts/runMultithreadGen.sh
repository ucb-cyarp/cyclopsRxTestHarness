#!/bin/bash
RxSrc=rev1BB_rx_dut
BlockSize=120
SubBlockSize=0
IO_FIFO_SIZE=120
FIFO_LEN=31
FIFO_TYPE=lockeless_x86
#FIFO_TYPE=lockeless_inplace_x86
#FIFO_IND_CACHE_TYPE=none
FIFO_IND_CACHE_TYPE=producer_consumer_cache
FIFO_DOUBLE_BUFFERING=none

#PAPI should be only active in one program at a time
#TELEM_LVL_DUT=papi_rate_only
TELEM_LVL_DUT=breakdown
#TELEM_LVL_DUT=io_rate_only

#Set the compiler to use here
source ./setCompilersToUse.sh

compilerInfoName="compilerInfo.txt"
netClientFileName="dut_network_client"

curDir=`pwd`

#Save Compiler Info
echo "Compilers Specified:" > $compilerInfoName
echo "CC=$CC" >> $compilerInfoName
echo "CXX=$CXX" >> $compilerInfoName
echo >> $compilerInfoName
echo "Compiler Locations:" >> $compilerInfoName
echo "CC: $(which $CC)" >> $compilerInfoName
echo "CXX: $(which $CXX)" >> $compilerInfoName
echo >> $compilerInfoName
echo "Compiler Config:" >> $compilerInfoName
echo "CC:" >> $compilerInfoName
$CC -v > $compilerInfoName 2>&1
echo "CXX:" >> $compilerInfoName
$CXX -v > $compilerInfoName 2>&1

echo "Telem LVL DUT: ${TELEM_LVL_DUT}"

#Generate

./runRxMultithreadGen.sh ${RxSrc} ${BlockSize} ${IO_FIFO_SIZE} ${CC} ${CXX} ${FIFO_LEN} ${FIFO_TYPE} ${FIFO_IND_CACHE_TYPE} ${FIFO_DOUBLE_BUFFERING} ${TELEM_LVL_DUT} ${SubBlockSize}
if [ $? -ne 0 ]; then
        echo "Gen Failed for Rx DUT"
        exit 1
fi

cd ${curDir}

#Copy Network Client Headers
mkdir $netClientFileName

cp cOut_${RxSrc}/*_io_network_socket_client.* $netClientFileName/.
cp cOut_${RxSrc}/vitisTypes.h $netClientFileName/.
cp cOut_${RxSrc}/*_io_network_socket.h $netClientFileName/.
cp cOut_${RxSrc}/*_fifoTypes.h $netClientFileName/.

cd ${curDir}
