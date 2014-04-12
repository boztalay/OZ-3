--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:44:30 05/10/2010
-- Design Name:   
-- Module Name:   C:/Users/georgecuris/Desktop/Folders/FPGA/Projects/Current Projects/Systems/OZ-3_System/clk_mgt_TB.vhd
-- Project Name:  OZ-3_System
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Clock_Mgt
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
 
ENTITY clk_mgt_TB IS
END clk_mgt_TB;
 
ARCHITECTURE behavior OF clk_mgt_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Clock_Mgt
    PORT(
         board_clock : IN  std_logic;
         clock1_out : OUT  std_logic;
         clock2_out : OUT  std_logic;
         clock3_out : OUT  std_logic;
         clock4_out : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal board_clock : std_logic := '0';

 	--Outputs
   signal clock1_out : std_logic;
   signal clock2_out : std_logic;
   signal clock3_out : std_logic;
   signal clock4_out : std_logic;

   -- Clock period definitions
   constant board_clock_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Clock_Mgt PORT MAP (
          board_clock => board_clock,
          clock1_out => clock1_out,
          clock2_out => clock2_out,
          clock3_out => clock3_out,
          clock4_out => clock4_out
        );

   -- Clock process definitions
   board_clock_process :process
   begin
		board_clock <= '0';
		wait for board_clock_period/2;
		board_clock <= '1';
		wait for board_clock_period/2;
   end process;

END;
