`include "memMachine.v"

`timescale 1ns/1ps

module testbench;
    reg clk;
    reg rst;
    reg [7:0] n;
    reg [6:0] m;
    wire [7:0] state;

    memoryStateMachine #(.addrSize(8)) uut (
        .clk(clk),
        .rst(rst),
        .n(n),
        .m(m),
        .state(state)
    );

    // Clock generation
    always #5 clk = ~clk; // 10 ns period (100 MHz)

    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        n = 8'hAA;
        m = 6'b010000;

        // Open VCD dump
        $dumpfile("waveform.vcd");
        $dumpvars(0, testbench);
  
        #10;

        rst = 0;

        // End simulation
        #100 $finish;
    end
endmodule