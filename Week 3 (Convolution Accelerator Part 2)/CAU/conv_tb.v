`include "opcontrol.v"

`timescale 1ns/1ps

module testbench;
    reg clk;
    reg rst;
    reg select;
    reg [1:0] opcode;
    reg [71:0] bus;

    // Instantiate the DUT (Device Under Test)
    OPCTRL dut (
        .clk(clk),
        .rst(rst),
        .select(select),
        .opcode(opcode),
        .bus(bus)
    );

    // Clock generation
    always #5 clk = ~clk; // 10 ns period (100 MHz)

    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        select = 1;
        bus = 72'b0;

        // Open VCD dump
        $dumpfile("waveform.vcd");
        $dumpvars(0, testbench);

        opcode = 2'b01;
        bus = 72'h010203040506070809;
        #10 rst = 0;

        opcode = 2'b10;
        #10

        opcode = 2'b00;
    
        #110

        // End simulation
        #50 $finish;
    end
endmodule