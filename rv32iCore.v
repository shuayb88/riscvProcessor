module rv32iCore(
	input wire MAX10_CLK1_50, 
	input wire KEY0, 
	
	output wire [9:0] LEDR,
	output wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
	);
	
	reg [23:0] prescaler = 0;
	reg slow_clk = 0;
	wire [31:0] x10;
	
	always @(posedge MAX10_CLK1_50) begin
		if (prescaler == 24'd8_333_333) begin
			prescaler <= 0;
			slow_clk <= ~slow_clk;
		end else begin
			prescaler <= prescaler + 1;
		end
	end

	wire clk = slow_clk;
	wire reset = ~KEY0;
	
	wire [31:0] pc, pc_next, pc_plus4, pc_branch, pc_jump;
	
	wire [31:0] instr; 
	
	wire reg_write, mem_read, mem_write, alu_src, mem_to_reg, branch, jump, jump_reg, lui, auipc;
	wire [3:0] alu_op;

	wire [4:0] rs1_addr, rs2_addr, rd_addr;
   wire [31:0] rs1_data, rs2_data, rd_data;
	
	wire [31:0] imm;
	
	wire [31:0] alu_a, alu_b, alu_result;
   wire zero;
	
	wire [31:0] mem_rdata;
	
	wire branch_taken;
	
	wire [2:0] funct3 = instr[14:12];
	
	assign rs1_addr = instr[19:15];
   assign rs2_addr = instr[24:20];
   assign rd_addr = instr[11:7];
	
	reg [31:0] imm_reg;
   assign imm = imm_reg;
	
	assign LEDR = pc[11:2];
	
	// Immediate generator
	always @(*) begin
		case (instr[6:0])
			// I-type: loads, ALU immediate, JALR
			7'b0010011,
			7'b0000011,
			7'b1100111: imm_reg = {{20{instr[31]}}, instr[31:20]};

			// S-type: stores
			7'b0100011: imm_reg = {{20{instr[31]}}, instr[31:25], instr[11:7]};

			// B-type: branches
			7'b1100011: imm_reg = {{19{instr[31]}}, instr[31], instr[7],
										instr[30:25], instr[11:8], 1'b0};

			// J-type: JAL
			7'b1101111: imm_reg = {{11{instr[31]}}, instr[31], instr[19:12],
										instr[20], instr[30:21], 1'b0};

			// U-type: LUI, AUIPC
			7'b0110111,
			7'b0010111: imm_reg = {instr[31:12], 12'b0};

			default:    imm_reg = 32'b0;
		endcase
	end
	
	assign pc_plus4 = pc + 32'd4;
   assign pc_branch = pc + imm;                        			// branch target (PC-relative)
   assign pc_jump = jump_reg ? (rs1_data + imm) : pc_branch;  	// JALR: rs1 + imm, JAL: PC + imm
	
	assign branch_taken = branch & (
        (funct3 == 3'b000) ?  zero          : // BEQ
        (funct3 == 3'b001) ? ~zero          : // BNE
        (funct3 == 3'b100) ?  alu_result[0] : // BLT  (SLT result)
        (funct3 == 3'b101) ? ~alu_result[0] : // BGE
        (funct3 == 3'b110) ?  alu_result[0] : // BLTU (SLTU result)
        (funct3 == 3'b111) ? ~alu_result[0] : // BGEU
                              1'b0
    );
	 
	 assign pc_next = jump ? pc_jump : 
							branch_taken ? pc_branch : pc_plus4;
	 
	 assign alu_a = auipc ? pc : rs1_data;
	 assign alu_b = alu_src ? imm : rs2_data;
	 
	 assign rd_data = mem_to_reg ? mem_rdata : 
							jump ? pc_plus4 : alu_result;
							
	// Module instantiations
	 programCounter u_pc (
        .clk     (clk),
        .reset   (reset),
        .pc_next (pc_next),
        .pc      (pc)
    );

    instrMem u_imem (
        .clk   (clk),
        .reset (reset),
        .pc    (pc),
        .instr (instr)
    );

    decode u_decode (
        .instr      (instr),
        .reg_write  (reg_write),
        .mem_read   (mem_read),
        .mem_write  (mem_write),
        .alu_src    (alu_src),
        .mem_to_reg (mem_to_reg),
        .branch     (branch),
        .jump       (jump),
        .jump_reg   (jump_reg),
        .lui        (lui),
        .auipc      (auipc),
        .alu_op     (alu_op)
    );

    regFile u_rf (
        .clk        (clk),
        .reset      (reset),
        .read_addr1 (rs1_addr),
        .read_addr2 (rs2_addr),
        .write_addr (rd_addr),
        .write_data (rd_data),
        .regWrite   (reg_write),
        .read_data1 (rs1_data),
        .read_data2 (rs2_data),
		  .x10 (x10)
    );

    ALU u_alu (
        .ALU_SEL (alu_op),
        .In_A    (alu_a),
        .In_B    (alu_b),
        .ALU_Out (alu_result),
        .zero    (zero)
    );

    dataMem u_dmem (
        .clk        (clk),
        .mem_addr   (alu_result),
        .write_data (rs2_data),
        .mem_read   (mem_read),
        .mem_write  (mem_write),
        .funct3     (funct3),
        .read_data  (mem_rdata)
    );
	 
	
	sevenSeg u_sevenSeg5(
	 
		.a (HEX5[0]),
		.b (HEX5[1]),
		.c (HEX5[2]),
		.d (HEX5[3]),
		.e (HEX5[4]),
		.f (HEX5[5]),
		.g (HEX5[6]),
		.x0 (x10[20]),
		.x1 (x10[21]),
		.x2 (x10[22]),
		.x3 (x10[23])
	 
	 
	 );
	 
sevenSeg u_sevenSeg4(
	 
		.a (HEX4[0]),
		.b (HEX4[1]),
		.c (HEX4[2]),
		.d (HEX4[3]),
		.e (HEX4[4]),
		.f (HEX4[5]),
		.g (HEX4[6]),
		.x0 (x10[16]),
		.x1 (x10[17]),
		.x2 (x10[18]),
		.x3 (x10[19])
	 
	 
	 );
sevenSeg u_sevenSeg3(
	 
		.a (HEX3[0]),
		.b (HEX3[1]),
		.c (HEX3[2]),
		.d (HEX3[3]),
		.e (HEX3[4]),
		.f (HEX3[5]),
		.g (HEX3[6]),
		.x0 (x10[12]),
		.x1 (x10[13]),
		.x2 (x10[14]),
		.x3 (x10[15])
	 
	 
	 );	 
	 
sevenSeg u_sevenSeg2(
	 
		.a (HEX2[0]),
		.b (HEX2[1]),
		.c (HEX2[2]),
		.d (HEX2[3]),
		.e (HEX2[4]),
		.f (HEX2[5]),
		.g (HEX2[6]),
		.x0 (x10[8]),
		.x1 (x10[9]),
		.x2 (x10[10]),
		.x3 (x10[11])
	 
	 
	 );	

	sevenSeg u_sevenSeg1(
	 
		.a (HEX1[0]),
		.b (HEX1[1]),
		.c (HEX1[2]),
		.d (HEX1[3]),
		.e (HEX1[4]),
		.f (HEX1[5]),
		.g (HEX1[6]),
		.x0 (x10[4]),
		.x1 (x10[5]),
		.x2 (x10[6]),
		.x3 (x10[7])
	 
	 
	 );
	 
	 sevenSeg u_sevenSeg0(
	 
		.a (HEX0[0]),
		.b (HEX0[1]),
		.c (HEX0[2]),
		.d (HEX0[3]),
		.e (HEX0[4]),
		.f (HEX0[5]),
		.g (HEX0[6]),
		.x0 (x10[0]),
		.x1 (x10[1]),
		.x2 (x10[2]),
		.x3 (x10[3])
	 
	 
	 );
	 
endmodule