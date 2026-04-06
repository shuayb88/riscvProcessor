module instrMem (
    input wire clk,
	 input wire reset,
    input wire [31:0] pc,
    output reg [31:0] instr
);

	(* ramstyle = "M9K", rom_style = "M9K" *)
	reg [31:0] mem [0:1023];

	//integer i;
	//initial begin
	//	 for (i = 0; i < 1024; i = i + 1)
	//		  mem[i] = 32'h00000013;  // fill with NOPs
	//	 $readmemh("program.hex", mem);
	//end

	always @(posedge clk) begin
		case (pc[11:2])
			10'd0: instr <= 32'h00000013;
			10'd1: instr <= 32'h00000013;
			10'd2: instr <= 32'h00000013;
			10'd3: instr <= 32'h00000013;
			default: instr <= 32'h00000013;
		endcase
	 end

endmodule