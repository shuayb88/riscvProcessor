module ALU(
	
	input [3:0] ALU_SEL,	// To choose operation
	input [31:0] In_A, 
	input [31:0] In_B,
	output reg [31:0] ALU_Out,
	output wire zero 		//flag for conditional statements

);

always @(*) begin

	ALU_Out = 32'b0;									//default value

	case(ALU_SEL)
		4'b0000: ALU_Out = In_A + In_B;			//addition
		4'b0001: ALU_Out = In_A - In_B;			//subtraction
		4'b0010: ALU_Out = In_A & In_B;			//and
		4'b0011: ALU_Out = In_A | In_B;			//or
		4'b0100: ALU_Out = In_A ^ In_B;			//xor
		4'b0101: ALU_Out = In_A << In_B[4:0];			//sll
		4'b0110: ALU_Out = In_A >> In_B[4:0];			//srl
		4'b0111:	ALU_Out = $signed(In_A) >>> In_B[4:0]; 		//shift right arithmetic (pad left with 1's)
		4'b1000: ALU_Out = ($signed(In_A) < $signed(In_B)) ? 32'b1 : 32'b0; // SLT
		4'b1001: ALU_Out = (In_A < In_B) ? 32'b1 : 32'b0;                   // SLTU
		
		default: ALU_Out = 32'b0;

	endcase
	
	

end

assign zero = (ALU_Out == 32'b0);			//zero flag is high if output of current op is zero


endmodule