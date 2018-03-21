parameter SENSORS = 1;
parameter BITWIDTH = 32;

module SensorController (
  input clk,
  input rst,
  output [(SENSORS - 1):0] data[(BITWIDTH - 1):0],
  input sensors,
  output sensor_done,
  input ack
);

  reg [(SENSORS - 1):0] data_buffer[(BITWIDTH - 1):0];
  assign data = data_buffer;
  assign sensor_done = 1;
  always @ (posedge clk, negedge rst) begin
    if(!rst) begin
      for(i = 0; i < SENSORS * 2; i = i + 1) begin
        data <= {SENSORS{1'b0}};
      end
    end else begin
      if(ack == 1) begin
        data_buffer[0] <= data_buffer[0] + 1;
        data_buffer[1] <= ~data_buffer[0];
      end
    end
  end
endmodule
