--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   00:15:25 11/08/2009
-- Design Name:   
-- Module Name:   E:/FPGA/Projects/Current Projects/Systems/OZ-3/ConditionBlock_TB.vhd
-- Project Name:  OZ-3
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ConditionBlock
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
 
ENTITY ConditionBlock_TB IS
END ConditionBlock_TB;
 
ARCHITECTURE behavior OF ConditionBlock_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ConditionBlock
    PORT(
         clock : IN  std_logic;
         reset : IN  std_logic;
         sel : IN  std_logic_vector(2 downto 0);
         flags : IN  std_logic_vector(4 downto 0);
         cond_out : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clock : std_logic := '0';
   signal reset : std_logic := '0';
   signal sel : std_logic_vector(2 downto 0) := (others => '0');
   signal flags : std_logic_vector(4 downto 0) := (others => '0');

 	--Outputs
   signal cond_out : std_logic;

   -- Clock period definitions
   constant clock_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ConditionBlock PORT MAP (
          clock => clock,
          reset => reset,
          sel => sel,
          flags => flags,
          cond_out => cond_out
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
      wait for 20 ns;
			reset <= '0';
		wait for 10 ns;
			sel <= b"000";
			flags <= b"10101";
		wait for 10 ns;
			sel <= b"001";
		wait for 10 ns;
			sel <= b"010";
		wait for 10 ns;
			sel <= b"011";
		wait for 10 ns;
			sel <= b"100";
		wait for 10 ns;
			sel <= b"101";
		wait for 10 ns;
			sel <= b"110";
		wait for 10 ns;
			sel <= b"011";
			flags <= b"00000";
      wait;
   end process;

END;
