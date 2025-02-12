// Supports 3x3 kernels for 8-bit integers
module C(clk, rst, scope, kernel, result);
    input clk, rst;
    input [71:0] scope;
    input [71:0] kernel;
    
    // Pointers to where in the register to access from
    // The last 3 bits are not changed, so they are concatonated when accessing registers
    // This should help make the hardware footprint of an ASIC smaller
    reg [3:0] pointHi;

    output reg [17:0] result;
    
    always @ (negedge clk) begin
        // Reset at end of cycle
        if (rst) begin
            pointHi <= 4'b0;
        end else if () begin
            pointHi <= pointHi + 1;
        end
    end

    always @ (posedge clk) begin
        if (rst) begin
            result <= 34'b0;
        end else begin
            // Operation for a single pixel of the kernel, convolution on scope is finished after 9 operations
            result <= result + (kernel[{pointHi, 3'b111} -: 8] * scope[{pointHi, 3'b111} -: 8]);
        end
    end
endmodule