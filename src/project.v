/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

//`define default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.
  assign uo_out  = ui_in + uio_in;  // Example: ou_out is the sum of ui_in and uio_in
  assign uio_out = 0;
  assign uio_oe  = 0;

wire memory_read, memory_write;
wire [2:0] option;
wire [31:0] address, write_data, read_data;


wire memory_response, clk_o;

assign memory_response = memory_read | memory_write;

assign clk_o = clk & ena;

Core #(
    .BOOT_ADDRESS(0)
) Core(
    .clk(clk_o),
    .reset(~rst_n),
    .option(option),
    .memory_response(memory_response),
    .memory_read(memory_read),
    .memory_write(memory_write),
    .write_data(write_data),
    .read_data(read_data),
    .address(address)
);

Memory #(
    //.MEMORY_FILE(1024),
    .MEMORY_SIZE(1024)
) Memory(
    .clk(clk_o),
    .reset(~rst_n),
    .option(option),
    .memory_read(memory_read),
    .memory_write(memory_write),
    .write_data(write_data),
    .read_data(read_data),
    .address(address)
);

endmodule
