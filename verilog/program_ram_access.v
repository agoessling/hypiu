module program_ram_access(
  inout bus_b,
  inout bus_d,
  input pc
);

wire [23:0] data;

program_ram pr (
  .data(data),
  .addr(pc),
  .write_en_n(1'b0),
  .read_en_n(1'b1)
);


