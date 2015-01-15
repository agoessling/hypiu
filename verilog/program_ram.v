module program_ram(
  inout [23:0] data,
  input [15:0] addr,
  input write_en_n,
  input read_en_n
);

reg [23:0] ram[0:65535];

initial begin
  $readmemh("program_ram.list", ram);
end

assign data = read_en_n ? 24'bZ : ram[addr];

always @ (posedge write_en_n)
begin
  ram[addr] <= data;
end

endmodule
