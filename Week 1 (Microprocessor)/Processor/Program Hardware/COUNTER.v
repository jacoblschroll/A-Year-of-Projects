module COUNTER #(parameter N = 2) (clk, rst, count);
    input clk;
    input rst;

    output reg [N-1:0] count;

    always @ (posedge clk) begin
        if (rst) begin
            count <= 0;
        end else begin
            count <= count + 1;
        end
    end
endmodule