`include "alu_code.vh"

module alu(
  output [15:0] result,
  output zero,
  input clk,
  input [15:0] a,
  input [15:0] b,
  input [`ALU_BIT_NUM-1:0] oper
);

reg zero;
reg result;

initial begin
  zero <= 0;
end

always @ (a or b or oper)
begin
  case (oper)
    `ALU_ZERO:  result = 16'b0;
    `ALU_A:  result = a;
    `ALU_B:  result = b;
    `ALU_ADD:  result = a + b;
    `ALU_SUB:  result = a - b;
    default: result = 16'bX;
  endcase
end

always @ (posedge clk)
begin
  zero <= (result == 16'b0);
end

endmodule
