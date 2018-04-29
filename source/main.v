module Main #(
  parameter SENSORS = 1,
  parameter BITWIDTH = 32
) (
  input clk,
  input rst,
  input spi_clk, /* synthesis syn_keep = 1 syn_direct_enable = 1 */
  input spi_in,
  output spi_out,
  input spi_sn,
  input sensor_signals
);

  wire [2*SENSORS*BITWIDTH-1:0] data; //Be sure to only add 24 bits as to avoid extra delays in clock speed...
  wire sensor_done;
  wire ack;

  wire [15:0] spi_data_out;
  wire [15:0] spi_data_in;
  wire spi_chip_select;
  wire spi_read;
  wire spi_write;
  wire spi_tx_ready;
  wire spi_rx_ready;
  wire spi_rx_error;
  wire spi_tx_error;
  wire spi_cpol;
  wire spi_cpha;
  wire spi_lsb_first;
  wire spi_tx_ack;
  wire spi_tx_no_ack;

  assign spi_chip_select = 0;
  assign spi_cpol = 0;
  assign spi_cpha = 0;
  assign spi_lsb_first = 0;


  SensorController
    #(.BITWIDTH(BITWIDTH), .SENSORS(SENSORS))
  s1(
    .clk(clk),
    .rst(rst),
    .data(data),
    .sensor_signals(sensor_signals),
    .sensor_done(sensor_done),
    .ack(ack)
  );

  MessagingController
    #(.BITWIDTH(BITWIDTH), .SENSORS(SENSORS))
  m1(
    .clk(clk),
    .rst(rst),
    .data(data),
    .ack(ack),
    .data_ready(sensor_done),
    .write(spi_write),
    .read(spi_read),
    .spi_in(spi_data_in),
    .spi_out(spi_data_out),
    .spi_tx_ready(spi_tx_ready),
    .spi_rx_ready(spi_rx_ready)
  );

  Spi_Slave spi1(
    .clk(clk),
    .rst(rst),
    .spi_clk(spi_clk),
    .write(spi_write),
    .write_ready(spi_tx_ready),
    .write_data(spi_data_out),
    .read_ready(spi_rx_ready),
    .read_data(spi_data_in),
    .mosi(spi_in),
    .miso(spi_out),
    .ssn(spi_sn)
  );

endmodule