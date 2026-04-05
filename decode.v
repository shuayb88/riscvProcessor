module decode(
	input wire [31:0] instr, 
	
	output

):
	wire [6:0] opcode = instr[6:0];
	wire [2:0] funct3 = instr[14:12];
	wire [6:0] funvt7 = instr[31:25];
	
	always @() begin
		case(opcode)
			7'b0110011: begin // R-type
				
				
			end
			7'b0010011: begin // I-type
				
				
			end
			7'b0100011: begin // S-type
				
				
			end
			7'b1100011: begin // B-type
				
				
			end
			7'b1101111: begin // JAL
				
				
			end
			7'b1100111: begin // JALR
				
				
			end
			7'b0110111: begin // LUI
				
				
			end
			7'b0010111: begin // AUIPC
				
				
			end
		endcase
	end


endmodule