`include "Control Unit/ICU.v"
`include "Program Hardware/COUNTER.v"
`include "Program Hardware/ROM.v"
`include "Data Selection/OutputSelector.v"
`include "Data Selection/InputSelector.v"

module top #(parameter N = 2) (clk, rst, data, write, result, moveIn);
    input clk, rst, data;
    input [7:0] moveIn;

    wire [N-1:0] addr;
    wire [7:0] instruction;

    wire [7:0] scratch;
    wire [7:0] out;

    output write, result;

    COUNTER #(.N(2)) programCounter (clk, rst, addr);
    ROM #(.N(2)) program (addr, instruction);
    ICU controlUnit(clk, rst, instruction[7:4], data, write, result);

    OutSelector SysScatch (rst, data, write, instruction[3], clk, instruction[2:0], scratch);
    OutSelector SysOut (rst, data, write, ~instruction[3] & write, clk, instruction[2:0], out);

    InSelector SysIn (~clk & ~write & ~instruction[3], 1'b0, data, moveIn, instruction[2:0]);
endmodule