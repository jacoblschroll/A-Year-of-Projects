`include "Control Unit/LU.v"
`include "Control Unit/CTRL.v"

module ICU(clk, rst, I, data, write, result);
  input clk, rst;
  input [3:0] I;
  input data;
  output write, result;

  reg [3:0] instReg;
  wire RR, IEN, OEN, STO, dataBus;
  wire [2:0] LUOP;

  CTRL controller (rst, clk, instReg, dataBus, LUOP, IEN, OEN, STO);
  LU operator (rst, clk, dataBus, RR & IEN, LUOP, RR);

  always @ (negedge clk) begin
    instReg <= rst ? 4'h0 : I;
  end

  assign dataBus = data || (STO & RR);
  assign result = RR;
  assign write = OEN & STO;
endmodule