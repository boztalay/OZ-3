--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:56:36 11/29/2009
-- Design Name:   
-- Module Name:   E:/FPGA/Projects/Current Projects/Systems/OZ-3/IFetch_TB.vhd
-- Project Name:  OZ-3
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: IFetch
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
 
ENTITY IFetch_TB IS
END IFetch_TB;
 
ARCHITECTURE behavior OF IFetch_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT IFetch
    PORT(
         clock : IN  std_logic;
         reset : IN  std_logic;
         condition_flag : IN  std_logic;
         PC_new_addr : IN  std_logic_vector(31 downto 0);
         iROM_data : IN  std_logic_vector(15 downto 0);
			dbl_clk : out STD_LOGIC;
         iROM_addr : OUT  std_logic_vector(22 downto 0);
         instruction_out : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clock : std_logic := '0';
   signal reset : std_logic := '0';
   signal condition_flag : std_logic := '0';
   signal PC_new_addr : std_logic_vector(31 downto 0) := (others => '0');
   signal iROM_data : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal iROM_addr : std_logic_vector(22 downto 0);
   signal instruction_out : std_logic_vector(31 downto 0);
	signal dbl_clk : STD_LOGIC;

   -- Clock period definitions
   constant clock_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: IFetch PORT MAP (
          clock => clock,
			 dbl_clk => dbl_clk,
          reset => reset,
          condition_flag => condition_flag,
          PC_new_addr => PC_new_addr,
          iROM_data => iROM_data,
          iROM_addr => iROM_addr,
          instruction_out => instruction_out
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
		wait for 1000 ns;
			reset <= '0';
			iROM_data <= x"000F";
			PC_new_addr <= x"000000FF";
		wait for 100 ns;
			condition_flag <= '1';
		wait for 50 ns;
			condition_flag <= '0';
		wait;
   end process;

END;
