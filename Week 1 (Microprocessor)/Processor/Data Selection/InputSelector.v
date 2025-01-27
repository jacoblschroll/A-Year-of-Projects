module InSelector(enable, inhibit, zed, ins, addr);
    input enable;
    input inhibit;
    input [2:0] addr;
    input [7:0] ins;

    output reg zed;

    always @ (*) begin
        if (~enable) begin
            zed <= 1'bz;
        end else if (inhibit) begin
            zed <= 1'b0;
        end else begin
            zed <= ins[addr];
        end
    end
endmodule