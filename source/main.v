module Main(
  input clk,
  input spi_clk,
  input spi_in,
  output spi_out,
  input spi_sn,
  input sensors
);
  parameter SENSORS = 1;
  parameter BITWIDTH = 32;


  wire [(2*SENSORS-1):0] data[(BITWIDTH-1):0]; //Be sure to only add 24 bits as to avoid extra delays in clock speed...
  wire sensor_done;
  wire ack;

  wire spi_data_out[15:0];
  wire spi_data_in[15:0];
  wire spi_read;
  wire spi_write;
  wire spi_tx_ready;
  wire spi_rx_ready;
  wire spi_tx_ready;
  wire spi_rx_error;
  wire spi_tx_error;
  wire spi_cpol;
  wire spi_cpha;
  wire spi_lsb_first;
  wire spi_tx_ck;
  wire spi_tx_no_ack;

  wire rst;
  assign rst = 1;
  assign spi_cpol = 0;
  assign spi_cpha = 1;
  assign i_lsb_first = 0;


  SensorController
    #(.BITWIDTH(BITWIDTH), .SENSORS(SENSORS))
  s1(
    .clk(clk),
    .rst(rst),
    .data(data),
    .sensors(sensors),
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

  SPI_Slave_top spi1(
    .i_sys_clk(clk),
    .i_sys_rst(rst),
    .i_csn(spi_sn),
    .i_data(spi_data_out),
    .i_wr(spi_write),
    .i_rd(spi_read),
    .o_data(spi_data_in),
    .o_tx_ready(spi_tx_ready),
    .o_rx_ready(spi_rx_ready),
    .o_tx_error(spi_tx_error),
    .o_rx_error(spi_rx_error),
    .i_cpol(spi_cpol),
    .i_cpha(spi_cpha),
    .i_lsb_first(spi_lsb_first),
    .o_miso(spi_out),
    .i_mosi(spi_in),
    .i_ssn(spi_sn),
    .i_sclk(spi_clk),
    .o_tx_ack(spi_tx_ack),
    .o_tx_no_ack(spi_tx_no_ack)
  );



endmodule

