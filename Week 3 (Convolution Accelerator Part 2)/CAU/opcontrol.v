`include "Convolver.v"

// 00: NOOP (Allow Convolution)
// 01: LOAD SCOPE
// 10: LOAD KERNEL
// 11: CLEAR ALL

// Data In: A connection to the 9 bit data bus running to all CAUs
// Scope: A subset of the image in the same shape as the kernel to be convolved

module OPCTRL(clk, rst, select, opcode, bus, convRst, scope, kernel,);
    input clk, rst, select;
    input [1:0] opcode;
    input [71:0] bus;

    reg convRst;
    reg [71:0] scope;
    reg [71:0] kernel;

    always @ (negedge clk) begin
        if (convRst) begin
            convRst <= 1'b0;
        end
        if (select) begin
            case (opcode)
                2'b00:;
                2'b01: begin
                    scope <= bus;
                    convRst <= 1;
                end
                2'b10: begin
                    kernel <= bus;
                    convRst <= 1;
                end
                2'b11: begin
                    scope <= 72'b0;
                    kernel <= 72'b0;
                    convRst <= 1;
                end
            endcase
        end
    end
endmodule