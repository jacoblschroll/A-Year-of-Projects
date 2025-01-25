module counter(clk, rst, count);
    input clk;
    input rst;

    output reg [1:0] count;

    always @ (posedge clk) begin
        if (rst) begin
            count <= 0;
        end else begin
            count += 1;
        end
    end
endmodule