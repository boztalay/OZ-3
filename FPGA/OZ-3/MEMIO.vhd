----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 		 Ben Oztalay
-- 
-- Create Date:    11:55:51 10/26/2009 
-- Design Name: 
-- Module Name:    MEMIO - Behavioral 
-- Project Name:   OZ-3
-- Target Devices: 
-- Tool versions: 
-- Description:    The memory and I/O stage of the OZ-3 pipeline 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Revision 0.10 - Ports written in
-- Revision 0.20 - Four main processes written, need code to handle dRAM data in
-- Revision 0.50 - First two sections simulated successfully, need to make a dRAM bus handler
-- Revision 0.55 - Did some optimization, re-did dRAM interface: it now has dedicated input and output
--						 ports. The rest will be handled by the memory controller. Need to re-do all simulations
-- Revision 0.70 - Simulations complete, renamed some signals
-- Revision 0.80 - Added a new falling-edge register between the dRAM_data_in input and the rest of the stage to aid
--						 in a timing issue with the memory bus controller
-- Additional Comments: This stage is easily the most complex stage of the processor,
--								so I will code it much more behaviorally than the other pieces.
--								Control signal catalog:
--									0.	Pin cntl e   	
--									1. Port cntl e          
--									2. RAM cntl e           
--									3.	pchk e				   
--									4.	opin clk e				
--									5.	opin 1/0					
--									6.	oprt clk e				
--									7.	dRAM W/R					
--								8-12. dest/data reg adr						
--							  13-17. result reg adr
--							  18-19. output MUX sel
--								  20. dRAM lower/upper write/read
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MEMIO is
	Port ( clock : in STD_LOGIC;
			 reset : in STD_LOGIC;
			 cntl_from_ID : in STD_LOGIC_VECTOR(20 downto 0);
			 ALU_result_from_EX_in : in STD_LOGIC_VECTOR(31 downto 0);
			 RAM_reg_data_from_ID : in STD_LOGIC_VECTOR(31 downto 0);
			 ipin_reg_data : in STD_LOGIC_VECTOR(15 downto 0);
			 iprt_data : in STD_LOGIC_VECTOR(31 downto 0);
			 dRAM_data_in: in STD_LOGIC_VECTOR(15 downto 0);
			 dRAM_data_out : out STD_LOGIC_VECTOR(15 downto 0);
			 dRAM_WR : out STD_LOGIC;
			 dRAM_addr : out STD_LOGIC_VECTOR(22 downto 0);
			 forward_addr_to_ID : out STD_LOGIC_VECTOR(4 downto 0);
			 pflag_to_EX : out STD_LOGIC;
			 opin_clk_e : out STD_LOGIC;
			 opin_select : out STD_LOGIC_VECTOR(3 downto 0);
			 opin_1_0 : out STD_LOGIC;
			 oprt_data : out STD_LOGIC_VECTOR(31 downto 0);
			 oprt_reg_clk_e : out STD_LOGIC;
			 RAM_reg_addr_to_ID : out STD_LOGIC_VECTOR(4 downto 0);
			 data_to_WB : out STD_LOGIC_VECTOR(31 downto 0));
end MEMIO;

architecture Behavioral of MEMIO is

--//Components\\--

component GenReg is
	 generic (size: integer);
		 Port ( clock : in  STD_LOGIC;
				  enable : in STD_LOGIC;
				  reset : in  STD_LOGIC;
				  data : in  STD_LOGIC_VECTOR ((size - 1) downto 0);
				  output : out  STD_LOGIC_VECTOR ((size - 1) downto 0));
end component;

component GenRegFalling is
	 generic (size: integer);
		 Port ( clock : in  STD_LOGIC;
				  enable : in STD_LOGIC;
				  reset : in  STD_LOGIC;
				  data : in  STD_LOGIC_VECTOR ((size - 1) downto 0);
				  output : out  STD_LOGIC_VECTOR ((size - 1) downto 0));
end component;

--\\Components//--

--//Signals\\--

signal cntl_buffer_1_2 : STD_LOGIC_VECTOR(20 downto 0); --control line buffer signals
signal cntl_buffer_2_out : STD_LOGIC_VECTOR(20 downto 0);

signal dRAM_data_reg_out : STD_LOGIC_VECTOR(15 downto 0);
signal mixed_dRAM_data : STD_LOGIC_VECTOR(31 downto 0);

signal ALU_result_from_EX : STD_LOGIC_VECTOR(31 downto 0);

--\\Signals//--

begin

	pins: process (ALU_result_from_EX, cntl_buffer_2_out, ipin_reg_data) is --This process controls the I/O pins
	begin
		pflag_to_EX <= '0';
		opin_select <= b"0000";
		opin_clk_e <= '0';
		opin_1_0 <= '0';
		
		if cntl_buffer_2_out(0) = '1' then --If this section is active
			pflag_to_EX <= (ipin_reg_data(conv_integer(unsigned(ALU_result_from_EX(3 downto 0)))) and cntl_buffer_2_out(3)); --Figure out the pflag
			opin_clk_e <= cntl_buffer_2_out(4); --clock the output pins if it's an opin instruction
			opin_select <= ALU_result_from_EX(3 downto 0); --other opin control
			opin_1_0 <= cntl_buffer_2_out(5);
		end if;
	end process;
	
	ports: process (ALU_result_from_EX, cntl_buffer_2_out, clock) is --This process controls the data ports
	begin
		oprt_data <= x"00000000";
		oprt_reg_clk_e <= '0';
		
		if cntl_buffer_2_out(1) = '1' then --If it's active, send data out. The input port is always taking input, no matter what
			oprt_data <= ALU_result_from_EX;
			oprt_reg_clk_e <= (clock and cntl_buffer_2_out(6));
		end if;
	end process;
	
	RAM: process (ALU_result_from_EX, cntl_buffer_2_out, RAM_reg_data_from_ID) is --This one controls everything having to do with the RAM
	begin																								
		dRAM_data_out <= x"0000";
		dRAM_WR <= '0'; --set up to default to read operation
		dRAM_addr <= b"00000000000000000000000";
		
		if cntl_buffer_2_out(2) = '1' then --If this process is active
			if cntl_buffer_2_out(7) = '1' then --If the instruction is a write operation
				if cntl_buffer_2_out(20) = '0' then --Test to see if it's writing the upper or lower half
					dRAM_data_out <= RAM_reg_data_from_ID(15 downto 0);
				else
					dRAM_data_out <= RAM_reg_data_from_ID(31 downto 16);
				end if; 
				dRAM_WR <= '1'; --set to write
			end if;
			dRAM_addr <= ALU_result_from_EX(22 downto 0);
		end if;
	end process;
	
	MUX: process (ALU_result_from_EX, mixed_dRAM_data, iprt_data, cntl_buffer_2_out) is --This models the MUX at the end of the stage
	begin																											--that decides what data from where goes to WB
		case cntl_buffer_2_out(19 downto 18) is
			when b"00" =>
				data_to_WB <= ALU_result_from_EX;
			when b"01" =>
				data_to_WB <= iprt_data;
			when b"10" =>
				data_to_WB <= mixed_dRAM_data;
			when others =>
				data_to_WB <= x"00000000";
		end case;
	end process;
	
	mix_dRAM_data: process (dRAM_data_reg_out, cntl_buffer_2_out, RAM_reg_data_from_ID) is						--This process takes the dRAM_data_in signal and mixes it
	begin																							   --with the data from the register that's being read into
		if cntl_buffer_2_out(20) = '0' then													--so that it can put the new data in the upper or lower half
			mixed_dRAM_data <= (RAM_reg_data_from_ID(31 downto 16) & dRAM_data_reg_out);
		else
			mixed_dRAM_data <= (dRAM_data_reg_out & RAM_reg_data_from_ID(15 downto 0));
		end if;
	end process;
	
	buf_1: GenReg generic map (21)                                             --These registers make up the two-stage buffer for the control
					  port map (clock, '1', reset, cntl_from_ID, cntl_buffer_1_2); --signals thatget sent out by the instruction decoder
	buf_2: GenReg generic map (21)
					  port map (clock, '1', reset, cntl_buffer_1_2, cntl_buffer_2_out);
	
	input_reg: GenReg generic map (32)
						   port map (clock, '1', reset, ALU_result_from_EX_in, ALU_result_from_EX); --This register is the buffer between the EX and MEMIO stages
	
	dRAM_data_reg : GenRegFalling generic map (16)
								         port map (clock, '1', reset, dRAM_data_in, dRAM_data_reg_out);
	
	RAM_reg_addr_to_ID <= cntl_buffer_2_out(12 downto 8);
	forward_addr_to_ID <= cntl_buffer_2_out(17 downto 13);

end Behavioral;

