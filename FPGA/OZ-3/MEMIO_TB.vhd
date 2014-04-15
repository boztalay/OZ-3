--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:12:40 12/10/2009
-- Design Name:   
-- Module Name:   E:/FPGA/Projects/Current Projects/Systems/OZ-3/MEMIO_TB.vhd
-- Project Name:  OZ-3
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MEMIO
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
 
ENTITY MEMIO_TB IS
END MEMIO_TB;
 
ARCHITECTURE behavior OF MEMIO_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MEMIO
    PORT(
         clock : IN  std_logic;
         reset : IN  std_logic;
         cntl_from_ID : IN  std_logic_vector(20 downto 0);
         ALU_result_from_EX : IN  std_logic_vector(31 downto 0);
         RAM_dest_data_reg : IN  std_logic_vector(31 downto 0);
         ipin_reg_data : IN  std_logic_vector(15 downto 0);
         iprt_data : IN  std_logic_vector(31 downto 0);
         dRAM_data_in : IN  std_logic_vector(15 downto 0);
         dRAM_data_out : OUT  std_logic_vector(15 downto 0);
         dRAM_WR : out STD_LOGIC;
         dRAM_addr : OUT  std_logic_vector(22 downto 0);
         result_reg_adr_to_ID : OUT  std_logic_vector(4 downto 0);
         pflag_to_cond : OUT  std_logic;
         opin_clk_e : OUT  std_logic;
         opin_select : OUT  std_logic_vector(3 downto 0);
         opin_1_0 : OUT  std_logic;
         oprt_data : OUT  std_logic_vector(31 downto 0);
         oprt_reg_clk_e : OUT  std_logic;
         data_reg_addr : OUT  std_logic_vector(4 downto 0);
         data_to_WB : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clock : std_logic := '0';
   signal reset : std_logic := '0';
   signal cntl_from_ID : std_logic_vector(20 downto 0) := (others => '0');
   signal ALU_result_from_EX : std_logic_vector(31 downto 0) := (others => '0');
   signal RAM_dest_data_reg : std_logic_vector(31 downto 0) := (others => '0');
   signal ipin_reg_data : std_logic_vector(15 downto 0) := (others => '0');
   signal iprt_data : std_logic_vector(31 downto 0) := (others => '0');
   signal dRAM_data_in : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal dRAM_data_out : std_logic_vector(15 downto 0);
   signal dRAM_WR : std_logic;
   signal dRAM_addr : std_logic_vector(22 downto 0);
   signal result_reg_adr_to_ID : std_logic_vector(4 downto 0);
   signal pflag_to_cond : std_logic;
   signal opin_clk_e : std_logic;
   signal opin_select : std_logic_vector(3 downto 0);
   signal opin_1_0 : std_logic;
   signal oprt_data : std_logic_vector(31 downto 0);
   signal oprt_reg_clk_e : std_logic;
   signal data_reg_addr : std_logic_vector(4 downto 0);
   signal data_to_WB : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clock_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MEMIO PORT MAP (
          clock => clock,
          reset => reset,
          cntl_from_ID => cntl_from_ID,
          ALU_result_from_EX => ALU_result_from_EX,
          RAM_dest_data_reg => RAM_dest_data_reg,
          ipin_reg_data => ipin_reg_data,
          iprt_data => iprt_data,
          dRAM_data_in => dRAM_data_in,
          dRAM_data_out => dRAM_data_out,
          dRAM_WR => dRAM_WR,
          dRAM_addr => dRAM_addr,
          result_reg_adr_to_ID => result_reg_adr_to_ID,
          pflag_to_cond => pflag_to_cond,
          opin_clk_e => opin_clk_e,
          opin_select => opin_select,
          opin_1_0 => opin_1_0,
          oprt_data => oprt_data,
          oprt_reg_clk_e => oprt_reg_clk_e,
          data_reg_addr => data_reg_addr,
          data_to_WB => data_to_WB
        );

   -- Clock process definitions
   clock_process :process
   begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
   end process; 

   -- Stimulus process
   stim_proc: process
   begin		
			reset <= '1';
		wait for 100 ns;
			reset <= '0';
			cntl_from_ID <= b"100000001000110000100";
		wait for 20 ns;
			RAM_dest_data_reg <= x"F000000F";
			ALU_result_from_EX <= x"000000F5";
			cntl_from_ID <= b"000000000000000000000";
      wait;
   end process;

END;
