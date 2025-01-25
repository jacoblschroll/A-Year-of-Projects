module CTRL(clk, instruction, LUOP);
    input clk;
    input [3:0] instruction;
    
    output reg [2:0] LUOP;

    always @ (posedge clk)
        case (instruction)
            4'h0:;  // NOOP
            4'h1: LUOP <= 3'b001;
            4'h2: LUOP <= 3'b010;
            4'h3: LUOP <= 3'b011;
            4'h4: LUOP <= 3'b100;
            4'h5: LUOP <= 3'b101;
            4'h6: LUOP <= 3'b110;
            4'h7: LUOP <= 3'b111;
            4'h8: LUOP <= 3'b001;
            4'h9: LUOP <= 3'b010;
            default:;
        endcase
endmodule