----------------------------------------------------------------------------------
-- Company: 
-- Engineer:       Ben Oztalay
-- 
-- Create Date:    11:57:09 10/26/2009 
-- Design Name: 
-- Module Name:    EX - Behavioral 
-- Project Name:   OZ-3
-- Target Devices: Xilinx XC3S500E-4FG320
-- Tool versions: 
-- Description:    The EX (execution) stage of the OZ-3 pipeline 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Revision 0.30 - File written and syntax checked
-- Revision 0.90 - Successfully simulated
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EX is
	Port ( clock : in STD_LOGIC;
		    reset : in STD_LOGIC;
			 ALUA_from_ID  : in STD_LOGIC_VECTOR(31 downto 0);
			 ALUB_from_ID  : in STD_LOGIC_VECTOR(31 downto 0);
			 cntl_from_ID : in STD_LOGIC_VECTOR(11 downto 0);
			 p_flag_from_MEM : in STD_LOGIC;
			 ALUR_to_MEM : out STD_LOGIC_VECTOR(31 downto 0);
			 dest_reg_addr_to_ID : out STD_LOGIC_VECTOR(4 downto 0);
			 cond_bit_to_IF : out STD_LOGIC);
end EX;

architecture Behavioral of EX is

--//Component Declarations\\--

component ALU is
    Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0);
           sel : in  STD_LOGIC_VECTOR (3 downto 0);
           result : out  STD_LOGIC_VECTOR (31 downto 0);
           cond_bits : out  STD_LOGIC_VECTOR (3 downto 0));
end component;

component ConditionBlock is
	Port ( clock : in STD_LOGIC;
			 reset : in STD_LOGIC;
			 sel   : in STD_LOGIC_VECTOR(2 downto 0);
			 flags : in STD_LOGIC_VECTOR(4 downto 0);
			 cond_out : out STD_LOGIC);
end component;

component GenReg is
	 generic (size: integer);
		 Port ( clock : in  STD_LOGIC;
				  enable : in STD_LOGIC;
				  reset : in  STD_LOGIC;
				  data : in  STD_LOGIC_VECTOR ((size - 1) downto 0);
				  output : out  STD_LOGIC_VECTOR ((size - 1) downto 0));
end component;

--//Signal Declarations\\--

signal ALUA_reg_out : STD_LOGIC_VECTOR(31 downto 0);
signal ALUB_reg_out : STD_LOGIC_VECTOR(31 downto 0);
signal ALU_flags    : STD_LOGIC_VECTOR(3 downto 0);
signal cntl_reg_out : STD_LOGIC_VECTOR(11 downto 0);
signal flags_to_CB  : STD_LOGIC_VECTOR(4 downto 0);
--\\Signal Declarations//--

begin

	ALU_inst: ALU port map (ALUA_reg_out, ALUB_reg_out, cntl_reg_out(3 downto 0), ALUR_to_MEM, ALU_flags);
	cond_block: ConditionBlock port map (clock, reset, cntl_reg_out(6 downto 4),
													 flags_to_CB, cond_bit_to_IF);
	ALUA_reg: GenReg generic map (size => 32)
	                 port map (clock, '1', reset, ALUA_from_ID, ALUA_reg_out);
	ALUB_reg: GenReg generic map (size => 32)
	                 port map (clock, '1', reset, ALUB_from_ID, ALUB_reg_out);
	Cntl_reg: GenReg generic map (size => 12)
						  port map (clock, '1', reset, cntl_from_ID, cntl_reg_out);
						  
	flags_to_CB <= (p_flag_from_MEM & ALU_flags);
	dest_reg_addr_to_ID <= cntl_reg_out(11 downto 7);
end Behavioral;

