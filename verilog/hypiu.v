`include "alu_code.vh"

module hypiu;

wire [15:0] bus_a;
wire [15:0] bus_b;
wire [15:0] bus_d;
wire [15:0] bus_w;
wire [2:0] addr_a;
wire [2:0] addr_b;
wire [2:0] addr_d;
wire [2:0] addr_w;
wire en_a;
wire en_b;
wire en_d;
wire en_w;
wire [`ALU_BIT_NUM-1:0] alu_oper;
wire [15:0] pc_addr;
wire z_flag;
wire pc_load_en;

reg clk;

register_file register_file_inst (
  .bus_a(bus_a),
  .bus_b(bus_b),
  .bus_d(bus_d),
  .clk(clk),
  .reset(1'b0),
  .bus_w(bus_w),
  .addr_a(addr_a),
  .addr_b(addr_b),
  .addr_d(addr_d),
  .addr_w(addr_w),
  .en_a(en_a),
  .en_b(en_b),
  .en_d(en_d),
  .en_w(en_w)
);

alu alu_inst (
  .result(bus_w),
  .zero(z_flag),
  .clk(clk),
  .a(bus_a),
  .b(bus_b),
  .oper(alu_oper)
);

program_counter program_counter_inst (
  .pc_addr(pc_addr),
  .clk(clk),
  .load_addr(bus_w),
  .load_en(pc_load_en)
);

program_control program_control_inst (
  .addr_a(addr_a),
  .addr_b(addr_b),
  .addr_d(addr_d),
  .addr_w(addr_w),
  .en_a(en_a),
  .en_b(en_b),
  .en_d(en_d),
  .en_w(en_w),
  .pc_load_en(pc_load_en),
  .alu_oper(alu_oper),
  .bus_b(bus_b),
  .bus_d(bus_d),
  .pc(pc_addr),
  .z_flag(z_flag)
);

initial
begin
  $display("Running HyPiU.");
  clk = 0;
  $dumpfile("hypiu.vcd");
  $dumpvars;
end

always
  #5 clk = !clk;

initial
  #500 $finish;

endmodule
