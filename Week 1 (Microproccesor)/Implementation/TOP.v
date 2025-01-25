`include "Processor\ICU.v"
`include "Program Hardware\COUNTER.v"
`include "Program Hardware\ROM.v"

module top(clk, rst, data, write, result);
    input clk, rst, data;

    wire [1:0] addr;
    wire [7:0] instruction;

    output write, result;

    counter programCounter (clk, rst, addr);
    ROM program (addr, instruction);
    ICU controlUnit(clk, rst, instruction[3:0], data, write, result);
endmodule