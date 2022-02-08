#!/bin/bash

DUT_NAME="rx_dut"

./simulinkGraphMLImporter ./$1.graphml $1_vitis.graphml
if [ $? -ne 0 ]; then
        echo "GraphML Import Failed for Rx DUT"
        exit 1
fi
OUT_DIR=cOut_$1
mkdir ${OUT_DIR}

if [[ $(uname) == "Darwin" ]]; then
        #Cannot set thread affinity on MacOS
        partitionMap="[]" 
else
        #              -2  0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18
       #partitionMap="[12,12,13,14,15,16,17,18,19,20,21,16,23,24,25,26,27,28,29,30]"
        # partitionMap="[12,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31]"

        #Remapping split EQ - For Epyc 7002 & Ryzen 3000 (New BIOS)
        partitionMap="[27,27,12,13,14,15,16,17,18,20,19,21,22,24,25,28,29,26,23]"

        #Remapping split EQ - For Ryzen 3000 (Old BIOS)
        # partitionMap="[27,27,9,10,11,12,13,14,15,20,16,21,22,24,25,28,29,26,23]"
fi

#./multiThreadedGenerator $1_vitis.graphml ./${OUT_DIR} ${DUT_NAME} --emitGraphMLSched --schedHeur DFS --blockSize $2 --fifoLength $6 --ioFifoSize $3 --partitionMap ${partitionMap} --useSCHED_FIFO --fifoType $7 --fifoCachedIndexes $8 --fifoDoubleBuffering $9
./multiThreadedGenerator $1_vitis.graphml ./${OUT_DIR} ${DUT_NAME} --emitGraphMLSched --schedHeur DFS --blockSize $2 --fifoLength $6 --ioFifoSize $3 --partitionMap ${partitionMap}  --printTelem --telemDumpPrefix telemDump_ --useSCHED_FIFO --fifoType $7 --fifoCachedIndexes $8 --fifoDoubleBuffering $9 --telemLevel ${10} --subBlockSize ${11}
#./multiThreadedGenerator $1_vitis.graphml ./${OUT_DIR} ${DUT_NAME} --emitGraphMLSched --schedHeur DFS --blockSize $2 --fifoLength $6 --ioFifoSize $3 --partitionMap ${partitionMap} --telemDumpPrefix telemDump_ --useSCHED_FIFO --fifoType $7 --fifoCachedIndexes $8 --fifoDoubleBuffering $9 --telemLevel ${10}

if [ $? -ne 0 ]; then
        echo "Multithread Gen Failed for Rx DUT"
        exit 1
fi
cd ${OUT_DIR}
make -f Makefile_${DUT_NAME}_io_network_socket.mk CC=$4 CXX=$5
if [ $? -ne 0 ]; then
        echo "Make Failed for Rx DUT network"
        exit 1
fi
