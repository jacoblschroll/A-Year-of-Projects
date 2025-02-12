`include "Convolver.v"
`include "opcontrol.v"

// This module has been tested and verified with sims

// High level model for convolution operation
module CAU(clk, rst, select, opcode, fromDataBus, toDataBus);
    input clk, rst, select;
    input [1:0] opcode;

    input [71:0] fromDataBus;
    
    wire [17:0] toDataBus;

    wire convRst;
    wire [71:0] scope;
    wire [71:0] kernel;

    OPCTRL controlUnit(clk, rst, select, opcode, fromDataBus, convRst, scope, kernel);
    C convolutionUnit(clk, convRst || rst, scope, kernel, toDataBus);
endmodule