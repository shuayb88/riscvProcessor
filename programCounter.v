module programCounter(
	input wire clk, 
	input wire reset, 
	input wire [31:0] pc_next, 
	output reg [31:0] pc
);
	always @(posedge clk) begin
		if(reset) begin
			pc <= 0;
		end
		else begin
			pc <= pc_next;
		end
	end
endmodule