module program_counter(
  output [15:0] pc_addr,
  input clk,
  input [15:0] load_addr,
  input load_en
);

reg [15:0] pc_addr;

initial begin
  pc_addr = 16'b0;
end

always @ (posedge clk)
begin
  pc_addr <= load_en ? load_addr : pc_addr + 1;
end

endmodule
