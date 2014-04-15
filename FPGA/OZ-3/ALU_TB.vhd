--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:19:09 10/27/2009
-- Design Name:   
-- Module Name:   C:/Users/Ben/Desktop/Folders/FPGA/Projects/Current Projects/Systems/OZ-3/ALU_TB.vhd
-- Project Name:  OZ-3
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ALU
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
 
ENTITY ALU_TB IS
END ALU_TB;
 
ARCHITECTURE behavior OF ALU_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ALU
    PORT(
         A : IN  std_logic_vector(31 downto 0);
         B : IN  std_logic_vector(31 downto 0);
         sel : IN  std_logic_vector(3 downto 0);
         output : OUT  std_logic_vector(31 downto 0);
         cond_bits : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(31 downto 0) := (others => '0');
   signal B : std_logic_vector(31 downto 0) := (others => '0');
   signal sel : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal output : std_logic_vector(31 downto 0);
   signal cond_bits : std_logic_vector(3 downto 0);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ALU PORT MAP (
          A => A,
          B => B,
          sel => sel,
          output => output,
          cond_bits => cond_bits
        );

   -- Stimulus process
   stim_proc: process
   begin
		wait for 20 ns;
			A <= x"80000001";
			B <= x"80000001";
			sel <= "0000";
		wait for 10 ns;
			A <= x"00000001";
		wait for 10 ns;
			A <= x"80000002";
			sel <= "0001";
		wait for 10 ns;
			A <= x"80000001";
			sel <= "0110";
		wait for 10 ns;
			sel <= "0111";
		wait for 10 ns;
			sel <= "1000";
		wait for 10 ns;
			sel <= "1001";
      wait;
   end process;

END;
