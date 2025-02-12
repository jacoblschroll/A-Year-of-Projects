// This state machine creates the pattern for accessing a 3x3 matrix from an image in memory
// Given N, the address of the first element and M, the width of the image
// A sequence of memory addresses generated and writen to state
// State represent a memory address NOT THE VALUE OF THE DATA AT THE POINTER

// 00: NOOP
// 01: LOAD SCOPE
// 10: LOAD KERNEL
// 11: NOOP (CAN BE USED FOR EXPANSION)

module memoryStateMachine #(parameter addrSize = 14, parameter kernelStart = 4'h0) (clk, rst, OPCODE, n, m, state);
    input clk;
    input rst;

    input [addrSize - 1 : 0] n;
    input [addrSize - 2:0] m;

    input [1:0] OPCODE;

    // Counts cycle of statemachine that have been executed
    reg [3:0] cycle;

    // Memory address of a point within the currently accessed kernel
    reg [addrSize - 1] currentKernel;

    output reg [addrSize - 1 : 0] state;

    // Return to zero if loop ended or is being reset
    always @ (negedge clk) begin
        if (cycle == 4'h8 || rst) begin
            cycle <= 4'h0;
        end else begin
            cycle <= cycle + 1;
        end
    end

    always @ (posedge clk) begin
        if (rst) begin
            state <= addrSize'b0;
            currentKernel <= kernelStart;
        end
        case (OPCODE)
            2'b01: begin 
                case (cycle)
                    4'h0: state <= n;
                    4'h1: state <= state + 1;
                    4'h2: state <= state + 1;
                    4'h3: state <= n + m;
                    4'h4: state <= state + 1;
                    4'h5: state <= state + 1;
                    4'h6: state <= n + {m, 1'b0}; // Shifted left to multiply by 2
                    4'h7: state <= state + 1;
                    4'h8: state <= state + 1;
                endcase
            end
            2'b10: begin
                state <= currentKernel;
                currentKernel <= currentKernel + 1;
            end
        endcase
    end
endmodule