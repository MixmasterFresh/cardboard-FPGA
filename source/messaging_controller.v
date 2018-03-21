parameter SENSORS = 1;
parameter BITWIDTH = 32;

module MessagingController (
  input clk,
  input rst,
  input [(SENSORS * 2 - 1):0] data[(BITWIDTH - 1):0],
  input data_ready,
  output ack,
  output write,
  output read,
  input spi_in[15:0],
  output spi_out[15:0],
  input spi_tx_ready,
  input spi_rx_ready
);

  reg writing;
  reg index;
  reg data_buffer[(BITWIDTH-1):0];
  assign write = writing;

  reg data_out[15:0];
  assign spi_out = data_out;

  always @ (posedge clk, negedge rst)
    if(!rst) begin
      writing <= 0;
      index <= 0;
    end else begin
      if(!writing && spi_tx_ready && data_ready) begin
        if(index < (BITWIDTH * SENSORS * 2 / 16)) begin
          writing <= 1;
          data_buffer <= data[index / (BITWIDTH / 16)][index % (BITWIDTH / 16)];
          index <= index + 1;
        end else begin
          ack <= 1;
          index <= 0;
        end
      end else begin
        writing <= 0;
        ack <= 1;
      end
    end
  end

endmodule
