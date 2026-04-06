module dataMem(

	input [31:0] mem_addr,
	input [31:0] write_data,		//data to be stored in RAM
	input mem_read, mem_write,		//control signals (ask: is this a store or load?)
	input clk,
<<<<<<< Updated upstream
	input wire [2:0] funct3,				//determine how much memory to access
=======
	input [2:0] funct3,				//determine how much memory to access
>>>>>>> Stashed changes
	output reg [31:0] read_data			//data to be read from RAM and loaded into register

);

reg [7:0] ram [0:1023];				//1024 slots, each slot = 8 bits = 1 byte

assign mem_write = ~mem_read;		//ensure read and write signals are never high simultaneously

always @(*) begin						//All load (read) instructions

<<<<<<< Updated upstream
	case(funct3)
		3'b000: begin					//lb, load byte signed
			read_data = {{24{ram[7]}, ram[mem_addr]}; //read byte at mem_addr, sign extend remaining 24 bits by repeating 8th bit 24 times
		end
=======
	if(mem_read) begin
		case(funct3)
			3'b000: begin					//lb, load byte signed
				read_data = {{24{ram[mem_addr][7]}}, ram[mem_addr]}; //read byte at mem_addr, sign extend remaining 24 bits by repeating 8th bit 24 times
			end
>>>>>>> Stashed changes
		
			3'b001: begin					//lh: load half-word signed
				read_data = {{16{ram[mem_addr+1][7]}}, ram[mem_addr+1], ram[mem_addr]}; //read byte at mem_addr and byte at mem_addr+1, sign extend remaining 16 bits by repeating 8th bit of highest byte, 16 times
			end
		
			3'b010: begin					//lw: load word signed
				read_data = {ram[mem_addr+3], ram[mem_addr+2], ram[mem_addr+1], ram[mem_addr]}; //read all 4 bytes
			end
		
<<<<<<< Updated upstream
		3'b100: begin					//lbu: load byte unsigned
			read_data = {24'b0, ram[mem_addr]};	//load 1 byte, pad rest with zeros
		end
=======
			3'b100: begin					//lbu: load byte unsigned
				read_data = {24'b0, ram[mem_addr]};	//load 1 byte, pad rest with zeros
			end
>>>>>>> Stashed changes
		
			3'b101: begin					//lhu: load half-word unsigned
				read_data = {16'b0, ram[mem_addr+1], ram[mem_addr]};	//load 2 bytes, pad rest with zeros
			end
		
			default: read_data = 32'b0;
	endcase

	
	end

end


always @(posedge clk) begin	//All store (write) instructions

	if(mem_write) begin
	
		case(funct3)
		
			3'b000: begin			//sb: store byte
				ram[mem_addr] <= write_data[7:0];
			end
			
			3'b001: begin			//sh: store half-word (2 bytes)
				ram[mem_addr]   <= write_data[7:0];   // Lowest byte
				ram[mem_addr+1] <= write_data[15:8];
			end
			
			3'b010: begin			//sw: store word (4 bytes)
				ram[mem_addr]   <= write_data[7:0];   // Lowest byte
				ram[mem_addr+1] <= write_data[15:8];
				ram[mem_addr+2] <= write_data[23:16];
				ram[mem_addr+3] <= write_data[31:24];
			end
		
		endcase
	
	
	end
	
	

end

endmodule