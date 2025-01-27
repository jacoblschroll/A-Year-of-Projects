module LU(rst, clk, A, B, LUOP, Y);
  input rst;
  input clk;
  input A;
  input B;
  input [2:0] LUOP;
  
  output reg Y;

  // LU Control Unit
  always @ (posedge clk) begin
    if (rst) begin
      Y <= 0;
    end
    case (LUOP)
      3'b000: Y <= 0;
      3'b001: Y <= A;
      3'b010: Y <= ~A;
      3'b011: Y <= A & B;
      3'b100: Y <= ~A & B;
      3'b101: Y <= A || B;
      3'b110: Y <= ~A || B;
      3'b111: Y <= A == B;
    endcase
  end
endmodule