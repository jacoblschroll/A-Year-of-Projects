module OutSelector(rst, data, write, CE, writeDisable, addr, outLatch);
    input rst;
    input data;
    input write;
    input CE;
    input writeDisable;
    input [2:0] addr;

    output reg [7:0] outLatch;

    always @ (*) begin
        if (rst) begin
            outLatch <= 8'h00;
        end else if (write & CE & ~writeDisable) begin
            outLatch[addr] <= data;
        end
    end
endmodule