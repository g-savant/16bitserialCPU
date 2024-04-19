`default_nettype none


//enabling forwarding
module reg_file(
  input logic rst, clk,
  input logic[2:0] rs1, rs2, rd,
  input logic[15:0] rd_data,
  output logic[15:0] rs1_data, rs2_data
);

logic[15:0][7:0] reg_file;

always_comb begin
  rs1_data = reg_file[rs1];
  rs2_data = reg_file[rs1];

  //forwarding
  if(rd == rs1) rs1_data = rd_data;
  if(rd == rs2) rs2_data = rd_data;
end
assign 

always_ff @(posedge clk) begin
  reg_file[rd] <= rd_data;
end



endmodule