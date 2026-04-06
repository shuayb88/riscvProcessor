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
		
			10'd0:  instr <= 32'h00500093; // addi x1, x0, 5
			10'd1:  instr <= 32'h00A00113; // addi x2, x0, 10
			10'd2:  instr <= 32'h00208533; // add x10, x1, x2 15
			10'd3:  instr <= 32'h402081b3; // sub x3, x1, x2 
			10'd4:  instr <= 32'h00018513; // addi x10, x3, 0
			
			10'd5:  instr <= 32'h01100213; // addi x4, x0, 17
			10'd6:  instr <= 32'h00402023; // sw  x4, 0(x0)
			10'd7:  instr <= 32'h00002503; // lw  x10, 0(x0)
			
			10'd8:  instr <= 32'h00208463; // beq x1, x2, 8
			10'd9:  instr <= 32'h00108463; // beq x1, x1, 8
			10'd10:  instr <= 32'h00100513; // addi x10, x0, 2
			10'd11:  instr <= 32'h00200513; // addi x10, x0, 1
			
			
			10'd12: instr <= 32'h00116533; // or x10 x2 x1   10 or 5
			10'd13: instr <= 32'h00114533; // xor x10 x2 x1  10 xor 5
			10'd14: instr <= 32'h00117533; // and x10 x2 x1  10 and 5
			10'd15: instr <= 32'h00121513; // slli x10 x4 1  17 << 1
			
			10'd16: instr <= 32'h00125513; // srli x10 x4 1 17 >> 1
			10'd17: instr <= 32'h00115533; // srl x10 x2 x1 17 >> 5
			10'd18: instr <= 32'h00111533; // sll x10 x2 x1 17 << 5
			/*
			10'd19: instr <= 32'h00000013;
			10'd20: instr <= 32'h00000013;
			10'd21: instr <= 32'h00000013;
			10'd22: instr <= 32'h00000013;
			10'd23: instr <= 32'h00000013;
			10'd24: instr <= 32'h00000013;
			10'd25: instr <= 32'h00000013;
			10'd26: instr <= 32'h00000013;
			10'd27: instr <= 32'h00000013;
			10'd28: instr <= 32'h00000013;
			10'd29: instr <= 32'h00000013;
			10'd30: instr <= 32'h00000013;
			10'd31: instr <= 32'h00000013;
			10'd32: instr <= 32'h00000013;
			10'd33: instr <= 32'h00000013;
			10'd34: instr <= 32'h00000013;
			10'd35: instr <= 32'h00000013;
			10'd36: instr <= 32'h00000013;
			10'd37: instr <= 32'h00000013;
			10'd38: instr <= 32'h00000013;
			10'd39: instr <= 32'h00000013;
			*/
			default: instr <= 32'h00000013;
		endcase
	 end

endmodule