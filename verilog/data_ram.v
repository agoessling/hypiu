module data_ram(
  inout [15:0] data,
  input [15:0] addr,
  input write_en_n,
  input read_en_n,
  input ebit
);

reg [7:0] ram[0:65535];
wire [15:0] read_data;

initial begin
  $readmemh("data_ram.list", ram);
end

assign read_data = ebit ? {8'b0,ram[addr]} : {ram[addr+1],ram[addr]};
assign data = read_en_n ? 16'bZ : read_data;

always @ (posedge write_en_n)
begin
  ram[addr] <= data[7:0];
  if(ebit == 1'b0)
    ram[addr+1] <= data[15:8];
end

endmodule
