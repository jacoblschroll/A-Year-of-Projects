module CTRL(rst, clk, instruction, data, LUOP, IEN, OEN, STO);
    input rst;
    input clk;
    input [3:0] instruction;
    input data;
    
    output reg [2:0] LUOP;
    output reg IEN;
    output reg OEN;
    output reg STO;

    always @ (posedge clk) begin
        if (rst) begin
            LUOP <= 3'b000;
            IEN <= 0;
            OEN <= 0;
            STO <= 0;
        end else begin
            case (instruction)
                4'h0:;  // NOOP
                4'h1: begin
                    LUOP <= 3'b001;
                    IEN <= data;
                end
                4'h2: begin
                    LUOP <= 3'b010;
                    IEN <= data;
                end
                4'h3: begin
                    LUOP <= 3'b011;
                    IEN <= data;
                end
                4'h4: begin
                    LUOP <= 3'b100;
                    IEN <= data;
                end
                4'h5: begin
                    LUOP <= 3'b101;
                    IEN <= data;
                end
                4'h6: begin
                    LUOP <= 3'b110;
                    IEN <= data;
                end
                4'h7: begin
                    LUOP <= 3'b111;
                    IEN <= data;
                end
                4'h8: begin
                    LUOP <= 3'b001;
                    STO <= 1;
                    end
                4'h9: begin
                    LUOP <= 3'b010;
                    STO <= 1;
                    end
                4'hA: IEN <= data;
                4'hB: OEN <= data;
                default:;
            endcase
        end
    end
endmodule