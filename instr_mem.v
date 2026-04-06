module instr_mem(
	input wire clk, 
	input wire reset, 
	input wire [31:0] pc, 
	output wire [31:0] instr, 
	);

	localparam MEM_DEPTH = 1024;
   localparam ADDR_BITS = 10; 
	
	wire [ADDR_BITS-1:0] word_addr = pc[ADDR_BITS+1:2];

	wire [31:0] bram_out;

   instr_rom u_rom (
		.clockclk),
		.address(word_addr),
		.q(bram_out)
	);
	
	assign instr = bram_out;
	 
endmodule
