module register_file(
  inout [15:0] bus_a,
  inout [15:0] bus_b,
  inout [15:0] bus_d,

  input clk,
  input reset,

  input [15:0] bus_w,

  input [2:0] addr_a,
  input [2:0] addr_b,
  input [2:0] addr_d,
  input [2:0] addr_w,

  input en_a,
  input en_b,
  input en_d,
  input en_w
);

reg [15:0] registers[7:0];

integer i;
initial begin
  for(i=0; i<8; i=i+1) begin
    registers[i] = 16'b0;
  end
end

// Assign Bidirectional Output Busses.
assign bus_a = en_a ? registers[addr_a] : 16'bZ;
assign bus_b = en_b ? registers[addr_b] : 16'bZ;
assign bus_d = en_d ? registers[addr_d] : 16'bZ;

// Latch Register Data for Write.
always @ (posedge clk) begin
  if(en_w == 1'b1)
    registers[addr_w] <= bus_w;
end

endmodule
