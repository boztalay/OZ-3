----------------------------------------------------------------------------------
-- Company: 
-- Engineer:       Ben Oztalay
-- 
-- Create Date:    11:55:24 10/26/2009 
-- Design Name: 
-- Module Name:    IF - Behavioral 
-- Project Name:   OZ-3
-- Target Devices: 
-- Tool versions: 
-- Description:    The instruction fetch stage of the OZ-3
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Revision 0.30 - File written and checked for syntax
-- 					 Need to check, strange results during simulation
-- Revision 0.90 - Successfully simulated, changed instruction registers to falling edge triggered
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

entity IFetch is
	Port ( clock : in STD_LOGIC;
		    reset : in STD_LOGIC;
			 condition_flag_from_EX : in STD_LOGIC;
			 PC_new_addr_from_EX : in STD_LOGIC_VECTOR(31 downto 0);
			 iROM_data : in STD_LOGIC_VECTOR(15 downto 0);
			 iROM_addr : out STD_LOGIC_VECTOR(22 downto 0);
			 dbl_clk : out STD_LOGIC;
			 instruction_to_ID : out STD_LOGIC_VECTOR(31 downto 0));
end IFetch;

architecture Behavioral of IFetch is

--//Component Declarations\\--

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

--\\Component Declarations//--

--//Signal Declarations\\--

signal double_clk : STD_LOGIC;
signal buf_double_clk : STD_LOGIC;

signal PC_addr_to_load : STD_LOGIC_VECTOR(22 downto 0);
signal incremented_addr : STD_LOGIC_VECTOR(22 downto 0);
signal PC_out : STD_LOGIC_VECTOR(22 downto 0);

signal inst_reg2_e : STD_LOGIC;

signal instruction_1 : STD_LOGIC_VECTOR(15 downto 0);
signal instruction_2 : STD_LOGIC_VECTOR(15 downto 0);

signal alt_addr_reg_sig : STD_LOGIC_VECTOR(32 downto 0);
signal alt_addr_reg_out : STD_LOGIC_VECTOR(32 downto 0);
signal alt_addr_reg_e : STD_LOGIC;
signal alt_addr_reg_r : STD_LOGIC;

--\\Signal Declarations//--

begin

	--//Clock Management\\--
	
	DCM_CPU_clk : DCM --Doubles the main CPU clock
   -- The following generics are only necessary if you wish to change the default behavior.
   generic map (
      CLKDV_DIVIDE => 2.0, --  Divide by: 1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5,6.0,6.5
                           --     7.0,7.5,8.0,9.0,10.0,11.0,12.0,13.0,14.0,15.0 or 16.0
      CLKFX_DIVIDE => 2,   --  Can be any interger from 1 to 32
		CLKFX_MULTIPLY => 2, --  Can be any integer from 1 to 32
      CLKIN_DIVIDE_BY_2 => FALSE, --  TRUE/FALSE to enable CLKIN divide by two feature
      CLKIN_PERIOD => 3200.0,          --  Specify period of input clock
      CLKOUT_PHASE_SHIFT => "NONE", --  Specify phase shift of NONE, FIXED or VARIABLE
      CLK_FEEDBACK => "NONE",         --  Specify clock feedback of NONE, 1X or 2X
      DESKEW_ADJUST => "SYSTEM_SYNCHRONOUS", --  SOURCE_SYNCHRONOUS, SYSTEM_SYNCHRONOUS or
                                             --     an integer from 0 to 15
      DFS_FREQUENCY_MODE => "LOW",     --  HIGH or LOW frequency mode for frequency synthesis
      DLL_FREQUENCY_MODE => "LOW",     --  HIGH or LOW frequency mode for DLL
      DUTY_CYCLE_CORRECTION => TRUE, --  Duty cycle correction, TRUE or FALSE
      FACTORY_JF => X"C080",          --  FACTORY JF Values
      PHASE_SHIFT => 0,        --  Amount of fixed phase shift from -255 to 255
      STARTUP_WAIT => FALSE) --  Delay configuration DONE until DCM LOCK, TRUE/FALSE
   port map (
      CLKFX => double_clk,   -- DCM CLK synthesis out (M/D)
      CLKIN => clock          -- Clock input (from IBUFG, BUFG or DCM)
	);
	
	BUFG_double_clk : BUFG
		port map (
		O => buf_double_clk,
		I => double_clk
	);
	
	--\\Clock Management//--
	
	PC_new_addr_cntl: process (alt_addr_reg_out, incremented_addr) is
	begin
		if (alt_addr_reg_out(32) = '1') then
			PC_addr_to_load <= alt_addr_reg_out(22 downto 0);
		else
			PC_addr_to_load <= incremented_addr;
		end if;
	end process;
	
	PC: GenReg generic map (23)
				  port map (buf_double_clk, '1', reset, PC_addr_to_load, PC_out);
	--I threw this register in to delay the new address by one half-cycle, so the instructions don't
	--get garbled
	AltAddrReg : GenRegFalling generic map (33)
					        port map (buf_double_clk, alt_addr_reg_e, alt_addr_reg_r, alt_addr_reg_sig, alt_addr_reg_out);
	Inst_reg_1 : GenRegFalling generic map (16)
							  port map (buf_double_clk, inst_reg2_e, reset, iROM_data, instruction_1);
	Inst_reg_2 : GenRegFalling generic map (16)
							  port map (buf_double_clk, clock, reset, iROM_data, instruction_2);

	alt_addr_reg_r <= (reset or clock);
	alt_addr_reg_e <= (not clock);
	alt_addr_reg_sig <= (condition_flag_from_EX & PC_new_addr_from_EX);
	iROM_addr <= PC_out;
	instruction_to_ID <= (instruction_2 & instruction_1);
	dbl_clk <= buf_double_clk;
	incremented_addr <= (PC_out + b"00000000000000000000001");
	inst_reg2_e <= (not clock);	
	
end Behavioral;

