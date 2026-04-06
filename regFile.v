module regFile(

	input wire [4:0] read_addr1, 
	input wire [4:0] read_addr2, 
	input wire [4:0] write_addr,
	
	input [31:0] write_data,
	
	output wire [31:0] read_data1,
	output wire [31:0] read_data2,
	
	input clk, 
	input regWrite, 
	input reset				//reset is to initialize all registers to zero at the start of a simulation

);

reg [31:0] registers [31:0];				//32 32-bit registers
	
integer i;										//index for for-loop in sequential block
	

	
	
//read from registers, send to ALU, without waiting for clock

assign read_data1 = (read_addr1 != 0) ? registers[read_addr1] : 0;
assign read_data2 = (read_addr2 != 0) ? registers[read_addr2] : 0;



always @(posedge clk) begin

	if(reset==1) begin
		for(i=0; i<32; i=i+1) begin
			registers[i] <= 32'b0;
		end
	end

	if(regWrite==1 && write_addr != 5'b0) registers[write_addr] <= write_data;		//only write data on clock edge, if regWrite signal is enabled, and if the target reg is not x0

	
end



endmodule