module register_file_tb;

wire [15:0] bus_a;
wire [15:0] bus_b;
wire [15:0] bus_d;

reg clk;
reg reset;

reg [15:0] bus_w;

reg[2:0] addr_a;
reg[2:0] addr_b;
reg[2:0] addr_d;
reg[2:0] addr_w;

reg en_a;
reg en_b;
reg en_d;
reg en_w;

register_file rf(
  .bus_a(bus_a),
  .bus_b(bus_b),
  .bus_d(bus_d),
  .clk(clk),
  .reset(reset),
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

initial begin
  clk = 0;
  reset = 0;
  bus_w = 0;
  addr_a = 0;
  addr_b = 0;
  addr_d = 0;
  addr_w = 0;
  en_a = 0;
  en_b = 0;
  en_d = 0;
  en_w = 0;

  $dumpfile("register_file.vcd");
  $dumpvars;

  #200 $finish;
end

always begin
  #1 en_w = 1;
  #1 addr_w = 1;
  #1 bus_w = 625;
  #1 clk = 1;
  #1 clk = 0;
  #1 addr_w = 0;
  #1 en_a = 1;
  #1 addr_a = 1;
  #1 bus_w = 626;
  #1 clk = 1;
  #1 clk = 0;
  #1 addr_w = 2;
  #1 bus_w = 12;
  #1 clk = 1;
  #1 clk = 0;
  #1 addr_b = 0;
  #1 en_b = 1;
  #1 addr_d = 2;
  #1 en_d = 1;
  #5 ;
end

endmodule
