`include "TOP.v"
`timescale 1ns/1ps

module TOP_tb;
  // Inputs
  reg clk;
  reg rst;
  reg data;

  // Outputs
  output write;
  output result;

  // Instantiate the top module
  top uut (
    .clk(clk),
    .rst(rst),
    .data(data),
    .write(write),
    .result(result)
  );

  // Clock generation
  initial begin
      clk = 0;
      forever #1 clk = ~clk; // 2ns clock period
  end

  // Testbench logic
  initial begin
    $dumpfile("TOP_SIM.vcd");
    $dumpvars(0, TOP_tb);

    rst = 1;
    data = 1;
    #2

    rst = 0;
    #7.5

    data = 0;
    #10

    $finish;
  end
endmodule