module MessagingController #(
  parameter SENSORS = 1,
  parameter BITWIDTH = 32
) (
  input clk,
  input rst,
  input [(2*SENSORS)*(BITWIDTH) - 1:0] data,
  input data_ready,
  output ack,
  output write,
  output read,
  input [15:0] spi_in,
  output [15:0] spi_out,
  input spi_tx_ready,
  input spi_rx_ready
);

  reg writing;
  reg read_reg;
  reg [2:0] index;
  assign write = writing;
  assign read = read_reg;

  

  wire [15:0] mapped_data[(BITWIDTH * SENSORS * 2 / 16 - 1):0];

  generate
    genvar i;
    for(i = 0; i < BITWIDTH * SENSORS * 2 / 16; i++) begin
      assign mapped_data[i] = data[(i+1) * 16 - 1:i * 16];
    end
  endgenerate

  reg [15:0] data_out;
  assign spi_out = data_out;

  reg ack_reg;
  assign ack = ack_reg;

  always @ (posedge clk, negedge rst) begin
    if(rst == 1'b0) begin
      writing <= 0;
      index <= 0;
      ack_reg <= 0;
      data_out <= 0;
      read_reg <= 0;
    end else begin
      if(spi_tx_ready && data_ready) begin
        if(index < (BITWIDTH * SENSORS * 2 / 16)) begin
          data_out <= 16'b1010101010101010; //mapped_data[index];
          index <= index + 1;
          writing <= 1;
        end else begin
          ack_reg <= 1;
          index <= 0;
          writing <= 0;
        end
      end else begin
        if(index >= (BITWIDTH * SENSORS * 2 / 16)) begin
          index <= 0;
          ack_reg <= 1;
        end else begin
          ack_reg <= 0;
        end
        writing <= 0;
        ack_reg <= 0;
      end
    end
  end

endmodule
