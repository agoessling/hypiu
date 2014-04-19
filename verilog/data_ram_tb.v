module data_ram_tb;

reg we_n;
reg re_n;
reg ebit;
inout [15:0] data;
reg [15:0] addr;
reg [15:0] data_reg;

data_ram dr (
  .data(data),
  .addr(addr),
  .write_en_n(we_n),
  .read_en_n(re_n),
  .ebit(ebit)
);

initial
begin
  $display("###########################");
  we_n = 1;
  re_n = 1;
  ebit = 0;
  addr = 0;
  data_reg = 16'b0;

  $dumpfile("data_ram.vcd");
  $dumpvars;
end

assign data = re_n ? data_reg : 16'bZ;

always
begin
  #5 re_n = 0;
  #1 addr = 16'd25;
  #5 re_n = 1;
  #1 ebit = 1;
  #5 re_n = 0;
  #1 addr = 16'd639;
  #5 re_n = 1;
  #1 ebit = 0;
  #1 we_n = 0;
  #1 data_reg = 16'd65123;
  #5 we_n = 1;
  #1 re_n = 0;
  #5 re_n = 1;
  #1 we_n = 0;
  #1 data_reg = 16'd0;
  #1 ebit = 1;
  #5 we_n = 1;
  #1 ebit = 0;
  #1 re_n = 0;
  #5 re_n = 1;
end

initial
  #100 $finish;

endmodule
