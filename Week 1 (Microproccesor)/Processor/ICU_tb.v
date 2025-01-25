`include "ICU.v"

`timescale 1ns/1ps

module ICU_tb;

  // Inputs
  reg clk;
  reg rst;
  reg [3:0] I;
  reg data;

  // Outputs
  output write;
  output result;

  // Instantiate the ICU module
  ICU uut (
    .clk(clk),
    .rst(rst),
    .I(I),
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
    $dumpfile("ICU_SIM.vcd");
    $dumpvars(0, ICU_tb);

    rst = 1;
    #1

    rst = 0;

    data = 1;

    I = 4'h1;
    #4

    data = 0;
    I = 4'h4;
    #3

    data = 1;

    I = 4'h3;
    #3

    data = 0;
    I = 4'h4;
    #3

    data = 1;
    I = 4'h8;
    #3

    $finish;
  end

endmodule