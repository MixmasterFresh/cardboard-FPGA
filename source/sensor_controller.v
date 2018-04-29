module SensorController #(
  parameter SENSORS = 1,
  parameter BITWIDTH = 32
) (
  input clk,
  input rst,
  output [(2*SENSORS)*(BITWIDTH) - 1:0] data,
  input sensor_signals,
  output sensor_done,
  input ack
);
  genvar i;

  reg [(BITWIDTH - 1):0] data_buffer[(SENSORS * 2 - 1):0];
  for(i = 0; i < SENSORS * 2; i++) begin
    assign data[(i+1) * BITWIDTH - 1:i * BITWIDTH] = data_buffer[i];
  end

  assign sensor_done = 1;

  always @ (posedge clk, negedge rst) begin
    if(rst == 1'b0) begin
      data_buffer[0] <= 0;
      data_buffer[1] <= 0;
    end else begin
      if(ack == 1) begin
        data_buffer[0] <= data_buffer[0] + 1;
        data_buffer[1] <=  {data_buffer[1][30:0],sensor_signals};
      end
    end
  end
endmodule
