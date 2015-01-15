`include "opcode.vh"

`include "alu_code.vh"

module program_control(
  output [2:0] addr_a,
  output [2:0] addr_b,
  output [2:0] addr_d,
  output [2:0] addr_w,
  output en_a,
  output en_b,
  output en_d,
  output en_w,
  output pc_load_en,
  output [`ALU_BIT_NUM-1:0] alu_oper,
  inout [15:0] bus_b,
  inout [15:0] bus_d,
  input [15:0] pc,
  input z_flag
);

reg addr_a;
reg addr_b;
reg addr_d;
reg addr_w;
reg en_a;
reg en_b;
reg en_d;
reg en_w;
reg pc_load_en;
reg alu_oper;

reg [15:0] bus_b_reg;
reg [15:0] bus_d_reg;

wire [23:0] data;
wire [5:0] opcode;
wire [2:0] result;
wire [2:0] operand_1;
wire [2:0] operand_2;
wire [11:0] immediate;

program_ram pr (
  .data(data),
  .addr(pc),
  .write_en_n(1'b1),
  .read_en_n(1'b0)
);

assign opcode = data[23:18];
assign result = data[17:15];
assign operand_1 = data[14:12];
assign operand_2 = data[11:9];
assign immediate = data[11:0];

assign bus_b = bus_b_reg;
assign bus_d = bus_d_reg;

always @ (opcode or result or operand_1 or operand_2 or immediate or z_flag)
begin
  // Default if not explicity overruled below.
  addr_a = 3'b0;
  addr_b = 3'b0;
  addr_d = 3'b0;
  addr_w = 3'b0;
  en_a = 1'b0;
  en_b = 1'b0;
  en_d = 1'b0;
  en_w = 1'b0;
  pc_load_en = 1'b0;
  bus_b_reg = 16'bZ;
  bus_d_reg = 16'bZ;

  case (opcode)
    `OPCODE_LDI: begin
      bus_b_reg = {4'b0, immediate};
      addr_w = result;
      en_w = 1'b1;
      alu_oper = `ALU_B;
    end
    `OPCODE_ADDI: begin
      addr_a = operand_1;
      en_a = 1'b1;
      bus_b_reg = {4'b0, immediate};
      addr_w = result;
      en_w = 1'b1;
      alu_oper = `ALU_ADD;
    end
    `OPCODE_SUBI: begin
      addr_a = operand_1;
      en_a = 1'b1;
      bus_b_reg = {4'b0, immediate};
      addr_w = result;
      en_w = 1'b1;
      alu_oper = `ALU_SUB;
    end
    `OPCODE_BRZ: begin
      bus_b_reg = {4'b0, immediate};
      alu_oper = `ALU_B;
      pc_load_en = z_flag;
    end
    `OPCODE_ADD: begin
      addr_a = operand_1;
      en_a = 1'b1;
      addr_b = operand_2;
      en_b = 1'b1;
      addr_w = result;
      en_w = 1'b1;
      alu_oper = `ALU_ADD;
    end
    `OPCODE_MOV: begin
      addr_a = operand_1;
      en_a = 1'b1;
      addr_w = result;
      en_w = 1'b1;
      alu_oper = `ALU_A;
    end
    `OPCODE_JMP: begin
      bus_b_reg = {4'b0, immediate};
      alu_oper = `ALU_B;
      pc_load_en = 1'b1;
    end
  endcase
end

endmodule
