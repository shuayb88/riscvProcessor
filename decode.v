module decode(
	input  wire [31:0] instr, 
	output reg         reg_write,    // write result to register file
   output reg         mem_read,     // read from data memory
   output reg         mem_write,    // write to data memory
   output reg         alu_src,      // 0=register, 1=immediate
   output reg         mem_to_reg,   // 0=ALU result, 1=memory data
   output reg         branch,       // is a branch instruction
   output reg         jump,         // is a jump instruction (JAL/JALR)
   output reg         jump_reg,     // JALR specifically (uses register base)
   output reg         lui,          // LUI instruction (bypass ALU)
   output reg         auipc,        // AUIPC instruction
   output reg  [3:0]  alu_op       // ALU operation select
);
	wire [6:0] opcode = instr[6:0];
	wire [2:0] funct3 = instr[14:12];
	wire [6:0] funct7 = instr[31:25];
	wire [11:0] Itypeimm = instr[31:20];
	
	always @(*) begin
		reg_write = 0; 
		mem_read = 0; 
		mem_write = 0;
		alu_src = 0; 
		mem_to_reg = 0; 
		branch = 0;
		jump = 0; 
		jump_reg = 0; 
		lui = 0; 
		auipc = 0;
		alu_op = 4'b0000;
		case(opcode)
			7'b0110011: begin // R-type
				reg_write = 1;
				case({funct7[5], funct3})
					4'b0000: alu_op = 4'b0000;	// add
					4'b1000: alu_op = 4'b0001;	// sub
					4'b0111: alu_op = 4'b0010;	// and
					4'b0110: alu_op = 4'b0011;	// or
					4'b0100: alu_op = 4'b0100;	// xor
					4'b0001: alu_op = 4'b0101;	//	sll
					4'b0101: alu_op = 4'b0110;	// srl
					4'b1101: alu_op = 4'b0111;	// sra
					4'b0010: alu_op = 4'b1000;	// slt
					4'b0011: alu_op = 4'b1001;	// sltu
					default: alu_op = 4'b0000;
				endcase
			end
			7'b0010011: begin // I-Type ALU
				reg_write = 1;
				alu_src = 1;
				case(funct3)
					3'b000: alu_op = 4'b0000; // addi
               3'b100: alu_op = 4'b0100; // xori
					3'b110: alu_op = 4'b0011; // ori
					3'b111: alu_op = 4'b0010; // andi
					3'b001: alu_op = 4'b0101; // slli
					3'b101: alu_op = Itypeimm[10] ? 4'b0111 : 4'b0110; // srai : srli
               3'b010: alu_op = 4'b1000; // slti
					3'b011: alu_op = 4'b1001; // sltiu
					default: alu_op = 4'b0000;
				endcase		
			end
			7'b0000011: begin // Load
				reg_write = 1;
				mem_read = 1;
				alu_src = 1;
				mem_to_reg = 1;
				
				alu_op = 4'b0000;
			end
			7'b0100011: begin // S-type
				mem_write = 1;
				alu_src = 1;
				
				alu_op = 4'b0000;
			end
			7'b1100011: begin // B-type
				branch = 1;
				case(funct3)
					3'b000,  						// beq
					3'b001: alu_op = 4'b0001;	// bne
					3'b100,  						// blt
					3'b101: alu_op = 4'b1000;	// bge
					3'b110,  						// bltu
					3'b111: alu_op = 4'b1001;	// bgeu
					default: alu_op = 4'b0000;
				endcase
			end
			7'b1101111: begin // JAL
				reg_write = 1;
				jump = 1;
			end
			7'b1100111: begin // JALR
				reg_write = 1'b1;
            jump = 1'b1;
            jump_reg = 1'b1;   
            alu_src = 1'b1;
            alu_op = 4'b0000; 
			end
			7'b0110111: begin // LUI
				reg_write = 1;
				lui = 1;
				alu_src = 1;
				alu_op = 4'b1111;
			end
			7'b0010111: begin // AUIPC
				reg_write = 1;
				auipc = 1;
				alu_src = 1;
				alu_op = 4'b0000;
			end
		endcase
	end


endmodule