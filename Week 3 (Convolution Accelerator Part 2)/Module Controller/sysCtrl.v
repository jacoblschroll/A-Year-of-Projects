`include "~\Module Controller\fullAccess.v"
`include "~\Module Controller\memMachine.v"
`include "dataBusCTRL.v"
`include "~\CAU\CAU.v"

// This is the HIGHEST LEVEL MODULE which controls the entire system
module sysCtrl(clk, rst, selector, opcode, dummyData);
    input clk, rst;

    input [2:0] selector;
    input [1:0] opcode;
    input [7:0] dummyData;

    wire address;
    wire memData;

    wire toConv;
    wire fromConv;

    memoryStateMachine memState(
        .clk(clk), 
        .rst(rst),
        .n(),
        .m(),
        .state(address)
        );
    
    dataController data(
        .clk(clk),
        .rst(rst),
        .memIn(memData),
        .toBus(toConv),
        .fromBus(fromConv)
    );

    // For simplicity, I'm testing with just on convolution unit
    CAU convolutionUnit(
        .clk(),
        .rst(),
        .select(selector[0]),
        .opcode(opcode),
        .fromDataBus(toConv),
        .toDataBus(fromConv)
    );
endmodule