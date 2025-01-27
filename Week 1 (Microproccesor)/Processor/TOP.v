`include "Control Unit/ICU.v"
`include "Program Hardware/COUNTER.v"
`include "Program Hardware/ROM.v"

module top(clk, rst, data, write, result);
    input clk, rst, data;

    wire [1:0] addr;
    wire [7:0] instruction;

    output write, result;

    counter #(.N(2)) programCounter (clk, rst, addr);
    ROM #(.N(2)) program (addr, instruction);
    ICU controlUnit(clk, rst, instruction[7:4], data, write, result);
endmodule