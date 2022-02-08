# cyclopsRxTestHarness

## Setup
### On Server:
1. Copy design file or link design to test (DUT) under `build/rev1BB_rx_dut.graphml`
2. Select compilers (if applicable)
3. Change directory to `build\` and run `./build.sh`

### On Client:
1. Copy `build/dut_network_client` from server to client
2. Open `matlab/rxTestHarnessSimulinkSide.slx` and copy the sfunction block along with the serialization and deserialization blocks.
3. Change blocking of serialization and deserialization based on I/O block size defined in `scripts/rxMultithreadedGen.sh`
4. Open the sfunction block
    1. Change IP address of server
    2. Change library include path to the location of `dut_network_client`
    3. If I/O changed, make the corresponding changes to the sfunction
    4. Select `Build` in the sfunction menu bar

## Use
1. On the server, change into `build\` and run `runTestHarness.sh`
2. On the client, run the simulink diagram

The test harness will exit when simulink finishes its run.