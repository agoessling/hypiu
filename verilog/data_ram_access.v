module data_ram_access(
  output [15:0] read_data,
  input clk
  input [15:0] write_data,
  input [15:0] addr,
  input rw_n,
  input ebit,
);

wire data;
wire write_en_n;
wire read_en_n;

data_ram dr (
  .data(data),
  .addr(addr),
  .write_en_n(write_en_n),
  .read_en_n(read_en_n),
  .ebit(ebit)
);

assign write_en_n = rw_n | clk;
assign read_en_n = !rw_n;
assign data = rw_n ? 16'bZ : write_data;

endmodule
