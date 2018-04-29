module Spi_Slave (
  input clk,
  input rst,
  input spi_clk,
  input write,
  output write_ready,
  input [15:0] write_data,
  output read_ready,
  output [15:0] read_data,
  input mosi,
  output miso,
  input ssn
);
  reg [3:0] index;
  reg writing;
  reg [15:0] saved_data;
  assign write_ready = !writing;
  reg in_progress, done;

  assign miso = saved_data[index];

  always @ (posedge clk, negedge rst) begin
    if(!rst) begin
      writing <= 0;
      saved_data <= 0;
    end else begin
      if(ssn && write && !writing) begin
        writing <= 1;
        saved_data <= write_data;
      end

      if(!ssn) begin
        in_progress <= 1;
      end

      if(ssn && in_progress) begin
        writing <= 0;
      end
    end
  end

  always @ (negedge spi_clk, negedge rst) begin
    if(!rst) begin
      index <= 0;
    end else begin
      index <= index + 1;
    end
  end
  
endmodule