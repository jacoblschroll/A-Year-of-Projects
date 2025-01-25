`include "LU.v"
`include "CTRL.v"

module ICU(clk, rst, I, data, write, result);
  // Basic inputs for seqential logic
  input clk;
  input rst;
  
  // Instruction in
  input [3:0] I;
  input data;
  
  // Store Instruction
  reg [3:0] instReg;
  
  // Result register
  wire RR;

  // Register controlled by input / output enable
  reg IEN;
  reg OEN;
  
  wire dataBus;

  // Logic Unit Operation
  wire [2:0] LUOP;
  
  // Should result be writen to output
  output write;
Processor\ICU.v
  // Result of operation (directly connected to RR)
  output result;
  
  // See LU.v
  CTRL controller (clk, instReg, LUOP);
  LU operator (clk, dataBus, RR, LUOP, RR);
  
  // Instructions will be loaded at the negative edge and executed at the positive edge
  always @ (negedge clk) begin
    instReg <= I;

    if (rst) begin
      instReg <= 4'h0;
      IEN <= 1;
      OEN <= 1;
    end
  end

  // This line is hard to explain, see Pg. 8 to understand why this function is used
  assign dataBus = data || (instReg == 4'h8 & IEN) || (instReg == 4'h9 & OEN);
  assign result = RR;

  // Enable write if Store or Store Compliment are used
  assign write = OEN & (instReg == 4'h8 || instReg == 4'h9);
endmodule