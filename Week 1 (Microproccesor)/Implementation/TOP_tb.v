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
    #2.5

    rst = 0;

    data = 1;
    #8

    $finish;
  end
endmodule