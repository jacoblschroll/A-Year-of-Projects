`include "LU.v"

`timescale 1ns/1ps

module LU_tb;
    reg A; 
    reg B;
    reg [2:0] LUOP;
    output Y;

    LU uut(
        .A(A),
        .B(B),
        .LUOP(LUOP),
        .Y(Y)
    );

    initial begin
        A = 0;
        forever #2 A = ~A; // 2ns clock period
    end

    initial begin
        B = 0;
        forever #1 B = ~B; // 2ns clock period
    end

    initial begin
        $dumpfile("LU_SIM.vcd");
        $dumpvars(0, LU_tb);

        LUOP = 3'b000;
        #4

        LUOP = 3'b001;
        #4

        LUOP = 3'b010;
        #4

        LUOP = 3'b011;
        #4

        LUOP = 3'b100;
        #4

        LUOP = 3'b101;
        #4

        LUOP = 3'b110;
        #4

        LUOP = 3'b111;
        #4

        $finish;
    end

endmodule