----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 		 Ben Oztalay
-- 
-- Create Date:    11:55:38 10/26/2009 
-- Design Name: 
-- Module Name:    ID - Behavioral 
-- Project Name:   OZ-3
-- Target Devices: 
-- Tool versions: 
-- Description:    The instruction decoder of the OZ-3
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Revision 0.10 - Ports written in
-- Revision 0.15 - Main process outlines written
-- Revision 0.30 - Control and Arithmetic/Logic decoding sections first draft done
-- Revision 0.31 - Memory and I/O decoding sections first draft complete, need to include the register file
--						 and output process to handle forwarding
-- Revision 0.32 - Output/forward logic process done, need to do all of the ORing of data lines, add
--						 the register file, and OR all of its address lines
--	Revision 0.33 - Register file component instantiated, ports mapped; need to OR all the signals and such
-- Revision 0.40 - First draft of module complete, syntax errors corrected; need to simulate
-- Revision 0.50 - Simulation and testing of all instruction complete, need to test forwarding
-- Revision 0.55 - Forwarding logic tested
-- Revision 0.56 - Added forwarding logic for the third address port of the register file
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity ID is
		Port ( --Inputs--
	
			 --Main inputs
			 clock : in STD_LOGIC;
			 reset : in STD_LOGIC;
			 instruction_from_IF : in STD_LOGIC_VECTOR(31 downto 0);
			 --Register file inputs
			 rfile_read_addr3_from_MEMIO : in STD_LOGIC_VECTOR(4 downto 0); --AKA RAM reg addr
			 rfile_write_addr_from_WB : in STD_LOGIC_VECTOR(4 downto 0);
			 rfile_write_data_from_WB : in STD_LOGIC_VECTOR(31 downto 0);
			 rfile_write_e_from_WB    : in STD_LOGIC;
			 --Forwarding logic inptus
			 forward_addr_EX    : in STD_LOGIC_VECTOR(4 downto 0);
			 forward_data_EX    : in STD_LOGIC_VECTOR(31 downto 0);
			 forward_addr_MEMIO : in STD_LOGIC_VECTOR(4 downto 0);
			 forward_data_MEMIO : in STD_LOGIC_VECTOR(31 downto 0);
			 forward_addr_WB    : in STD_LOGIC_VECTOR(4 downto 0);
			 forward_data_WB    : in STD_LOGIC_VECTOR(31 downto 0); 
				
			 --Outputs--
			 
			 --EX Control
			 ALU_A_to_EX : out STD_LOGIC_VECTOR(31 downto 0);
			 ALU_B_to_EX : out STD_LOGIC_VECTOR(31 downto 0);
			 EX_control : out STD_LOGIC_VECTOR(11 downto 0);
			 --MEMIO Control
			 RAM_reg_data_to_MEMIO : out STD_LOGIC_VECTOR(31 downto 0);
			 MEMIO_control : out STD_LOGIC_VECTOR(20 downto 0);
			 --WB Control
			 WB_control : out STD_LOGIC_VECTOR(5 downto 0));	
end ID;

architecture Behavioral of ID is

--//Components\\--

component RegFile is
	Port ( clock : in STD_LOGIC;
			 reset : in STD_LOGIC;
			 write_e : in STD_LOGIC;
			 data_in : in STD_LOGIC_VECTOR(31 downto 0);
			 r_addr1 : in STD_LOGIC_VECTOR(4 downto 0);
			 r_addr2 : in STD_LOGIC_VECTOR(4 downto 0);
			 r_addr3 : in STD_LOGIC_VECTOR(4 downto 0);
			 w_addr1 : in STD_LOGIC_VECTOR(4 downto 0);
			 data_out_1 : out STD_LOGIC_VECTOR(31 downto 0);
			 data_out_2 : out STD_LOGIC_VECTOR(31 downto 0);
			 data_out_3 : out STD_LOGIC_VECTOR(31 downto 0));
end component;

component GenReg is
	 generic (size : integer);
		 Port ( clock : in  STD_LOGIC;
				  enable : in STD_LOGIC;
				  reset : in  STD_LOGIC;
				  data : in  STD_LOGIC_VECTOR ((size - 1) downto 0);
				  output : out  STD_LOGIC_VECTOR ((size - 1) downto 0));
end component;

--\\Components//--

--//Signals\\--

signal rfile_read_addr1_cntl : STD_LOGIC_VECTOR(4 downto 0);        --These will get ORed before going to
signal rfile_read_addr1_arith_logic : STD_LOGIC_VECTOR(4 downto 0); --the register file
signal rfile_read_addr1_MEMIO : STD_LOGIC_VECTOR(4 downto 0);
signal rfile_read_addr1 : STD_LOGIC_VECTOR(4 downto 0);

signal rfile_read_addr2 : STD_LOGIC_VECTOR(4 downto 0); --This goes straight to the register file
																		  --and forwarding logic
signal RAM_reg_data_from_rfile : STD_LOGIC_VECTOR(31 downto 0); --This signal carries the rfile's
																					 --third output to the output logic
signal WB_WE_arith_logic : STD_LOGIC; --These will get ORed before going to WB
signal WB_WE_MEMIO : STD_LOGIC;

signal result_reg_arith_logic : STD_LOGIC_VECTOR(4 downto 0); --These will get ORed before going out
signal result_reg_MEMIO : STD_LOGIC_VECTOR(4 downto 0);	      --to the stages as a single result_reg
signal result_reg : STD_LOGIC_VECTOR(4 downto 0);

signal instruction : STD_LOGIC_VECTOR(31 downto 0);

--All of this has to do with the output to the ALU.
--It'll mostly get handled by tricky ORing, due to the
--fact that the "do nothing" state for the drivers of these signals
--is all zeros, so I can OR them to allow the only used value through
signal rfile_out_1 : STD_LOGIC_VECTOR(31 downto 0);
signal rfile_out_2 : STD_LOGIC_VECTOR(31 downto 0);
signal arith_immediate : STD_LOGIC_VECTOR(31 downto 0);
signal MEMIO_immediate : STD_LOGIC_VECTOR(31 downto 0);
signal displacement : STD_LOGIC_VECTOR(31 downto 0);
signal ALU_B : STD_LOGIC_VECTOR(31 downto 0);

--\\Signals//--

begin

	--This process takes care of control instructions
	control: process (instruction) is
	begin
		--Signals to initialize to zero
		EX_control(6 downto 4) <= b"000";
		rfile_read_addr1_cntl <= b"00000";
		displacement <= x"00000000";
		
		if instruction(31) = '1' then
			EX_control(6 downto 4) <= instruction(28 downto 26);
			rfile_read_addr1_cntl <= instruction(25 downto 21);
			if (instruction(20) = '0') then --Sign extension of the displacement value
				displacement <= b"00000000000" & instruction(20 downto 0);
			else
				displacement <= b"11111111111" & instruction(20 downto 0);
			end if;
		end if;
	end process;
	
	--This process decodes memory and I/O instructions
	MEMIO: process (instruction) is
	begin
		--Signals to initialize as zero
		MEMIO_immediate <= x"00000000";
		MEMIO_control(20 downto 18) <= b"000";
		MEMIO_control(12 downto 0) <= b"0000000000000";
		rfile_read_addr1_MEMIO <= b"00000";
		result_reg_MEMIO <= b"00000";
		WB_WE_MEMIO <= '0';
		
		if instruction(30) = '1' then              --Need to finish this section, don't forget section cntl
			--The immediate value from MEMIO sign extension
			if instruction(15) = '0' then
				MEMIO_immediate <= (x"0000" & instruction(15 downto 0));
			else
				MEMIO_immediate <= (x"FFFF" & instruction(15 downto 0));
			end if;
				
			--If it's a store/load instruction
			if instruction(29) = '1' then
				--Control signal for the RAM section
				MEMIO_control(2) <= '1';
				--Detect load or store
				if instruction(27) = '0' then
					--Load
					result_reg_MEMIO <= instruction(25 downto 21); --result register
					rfile_read_addr1_MEMIO <= instruction(20 downto 16); --the register specified
					MEMIO_control(12 downto 8) <= instruction(25 downto 21); --dest/data register for RAM operations
					MEMIO_control(19 downto 18) <= b"10"; --MUX control
					WB_WE_MEMIO <= '1'; --write enable
				else
					--Store
					rfile_read_addr1_MEMIO <= instruction(20 downto 16); --register specified
					MEMIO_control(12 downto 8) <= instruction(25 downto 21); --dest/data register for RAM operations
					MEMIO_control(7) <= '1'; --change the dRAM write/read signal
				end if;
				--Upper/lower control signal
				MEMIO_control(20) <= instruction(26); 
			end if;
			
			--If it's a port instruction
			if instruction(29 downto 27) = b"001" then
				--Control signal for the port section
				MEMIO_control(1) <= '1';
				--Detect input/output with the ports
				if instruction(26) = '0' then --Input
					result_reg_MEMIO <= instruction(25 downto 21); --result register
					WB_WE_MEMIO <= '1'; --write enable
					MEMIO_control(19 downto 18) <= b"01"; --set select for MUX to iprt data
				else --Output
					rfile_read_addr1_MEMIO <= instruction(20 downto 16); --data register
					MEMIO_control(6) <= '1'; --enable the oprt register clock
				end if;
			end if;
			
			--If it's a pin instruction
			if instruction(29 downto 28) = b"01" then
				--Control signal for the pin section
				MEMIO_control(0) <= '1';
				--Detect if it's an output or inpupt pin instruction
				if instruction(27) = '0' then --Output
					MEMIO_control(5) <= instruction(26); --Opin 1/0 select
					MEMIO_control(4) <= '1'; --Opin register clock enable
				else --Input
					MEMIO_control(3) <= '1'; --pin check enable
				end if;
			end if;
		end if;	
	end process;
	
	--This process decodes arithmetic and logic instructions
	arith_logic: process (instruction) is --I think this is done, but recheck
	begin
		--Signals to initialize as zero
		EX_control(3 downto 0) <= b"0000";
		arith_immediate <= x"00000000";
		result_reg_arith_logic <= b"00000";
		rfile_read_addr1_arith_logic <= b"00000";
		rfile_read_addr2 <= b"00000";
		WB_WE_arith_logic <= '0';
		
		if instruction(30 downto 29) = b"01" then
			result_reg_arith_logic <= instruction(25 downto 21);
			rfile_read_addr1_arith_logic <= instruction(20 downto 16);
			WB_WE_arith_logic <= '1'; --write enable
			
			--Detecting a register verus immediate addressing mode instruction
			if instruction(28 downto 26) = b"111" then
				--This is getting the ALU select value
				EX_control(3 downto 0) <= instruction(3 downto 0);
				--Register file source 2 address
				rfile_read_addr2 <= instruction(15 downto 11);
			else
				--ALU select value if the instruction is in the immediate addressing mode
				EX_control(3 downto 0) <= ('0' & instruction(28 downto 26));
				--Immediate value sign extension
				if instruction(15) = '0' then
					arith_immediate <= (x"0000" & instruction(15 downto 0));
				else
					arith_immediate <= (x"FFFF" & instruction(15 downto 0));
				end if;
			end if;			
		end if;
	end process;
	
	--This process handles the main outputs, along with
	--forwarding logic (ALU A and B already ORed n such)
	output: process (rfile_out_1, ALU_B, forward_data_EX, forward_data_MEMIO, forward_data_WB,
						  forward_addr_EX, forward_addr_MEMIO, forward_addr_WB, rfile_read_addr1,
						  rfile_read_addr2, rfile_read_addr3_from_MEMIO, RAM_reg_data_from_rfile) is
	begin
		--Logic for ALU_A/src1
		if rfile_read_addr1 /= b"00000" then
			--if the source register is EX's result register
			if rfile_read_addr1 = forward_addr_EX then
				ALU_A_to_EX <= forward_data_EX;
			--if the source register is MEMIO's result register
			elsif rfile_read_addr1 = forward_addr_MEMIO then
				ALU_A_to_EX <= forward_data_MEMIO;
			--if the source register is WB's result register
			elsif rfile_read_addr1 = forward_addr_WB then
				ALU_A_to_EX <= forward_data_WB;
			else
				ALU_A_to_EX <= rfile_out_1;
			end if;
		else
			ALU_A_to_EX <= rfile_out_1;
		end if;
		
		--Logic for ALU_B/src2
		--if the source register is EX's result register
		if rfile_read_addr2 /= b"00000" then
			if rfile_read_addr2 = forward_addr_EX then
				ALU_B_to_EX <= forward_data_EX;
			--if the source register is MEMIO's result register
			elsif rfile_read_addr2 = forward_addr_MEMIO then
				ALU_B_to_EX <= forward_data_MEMIO;
			--if the source register is WB's result register
			elsif rfile_read_addr2 = forward_addr_WB then
				ALU_B_to_EX <= forward_data_WB;
			else
				ALU_B_to_EX <= ALU_B;
			end if;
		else
			ALU_B_to_EX <= ALU_B;
		end if;
		
		--Logic for the RAM register
		--if the source register is EX's RAM register
		if rfile_read_addr3_from_MEMIO /= b"00000" then
			if rfile_read_addr3_from_MEMIO = forward_addr_EX then
				RAM_reg_data_to_MEMIO <= forward_data_EX;
			--if the source register is MEMIO's result register
--			elsif rfile_read_addr3_from_MEMIO = forward_addr_MEMIO then
--				RAM_reg_data_to_MEMIO <= forward_data_MEMIO;
			--if the source register is WB's result register
			elsif rfile_read_addr3_from_MEMIO = forward_addr_WB then
				RAM_reg_data_to_MEMIO <= forward_data_WB;
			else
				RAM_reg_data_to_MEMIO <= (others => '0');
			end if;
		else
			RAM_reg_data_to_MEMIO <= RAM_reg_data_from_rfile; --new sig like above
		end if;
	end process;
	
	--Signals getting combined (I know this adds a lot of excess logic, will optimize later)
	rfile_read_addr1 <= (rfile_read_addr1_cntl or rfile_read_addr1_MEMIO or rfile_read_addr1_arith_logic);
	result_reg <= (result_reg_MEMIO or result_reg_arith_logic);
	WB_control(0) <= (WB_WE_MEMIO or WB_WE_arith_logic);
	ALU_B <= (rfile_out_2 or arith_immediate or MEMIO_immediate or displacement);
	
	--Finishing up the control signals
	MEMIO_control(17 downto 13) <= result_reg;
	EX_control(11 downto 7) <= result_reg;
	WB_control(5 downto 1) <= result_reg;
	
	--Register file 
	rfile: RegFile port map (clock, reset, rfile_write_e_from_WB, rfile_write_data_from_WB, rfile_read_addr1, 
									 rfile_read_addr2, rfile_read_addr3_from_MEMIO, rfile_write_addr_from_WB, rfile_out_1, 
									 rfile_out_2, RAM_reg_data_from_rfile);
	--Input register
	inst_reg : GenReg generic map (32) 
							port map (clock, '1', reset, instruction_from_IF, instruction);
end Behavioral;

