--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:21:49 06/12/2010
-- Design Name:   
-- Module Name:   C:/Users/georgecuris/Desktop/Folders/FPGA/Projects/Current Projects/Systems/OZ-3_System/Output_Extender_TB.vhd
-- Project Name:  OZ-3_System
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Output_Port_MUX
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
 
ENTITY Output_Extender_TB IS
END Output_Extender_TB;
 
ARCHITECTURE behavior OF Output_Extender_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Output_Port_MUX
    PORT(
         data : IN  std_logic_vector(31 downto 0);
         sel : IN  std_logic_vector(1 downto 0);
         output0 : OUT  std_logic_vector(31 downto 0);
         output1 : OUT  std_logic_vector(31 downto 0);
         output2 : OUT  std_logic_vector(31 downto 0);
         output3 : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal data : std_logic_vector(31 downto 0) := (others => '0');
   signal sel : std_logic_vector(1 downto 0) := (others => '0');

 	--Outputs
   signal output0 : std_logic_vector(31 downto 0);
   signal output1 : std_logic_vector(31 downto 0);
   signal output2 : std_logic_vector(31 downto 0);
   signal output3 : std_logic_vector(31 downto 0);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Output_Port_MUX PORT MAP (
          data => data,
          sel => sel,
          output0 => output0,
          output1 => output1,
          output2 => output2,
          output3 => output3
        ); 

   -- Stimulus process
   stim_proc: process
   begin		
      sel(0) <= '1';
		wait for 640 ns;
		sel(1) <= '0';
		wait for 1280 ns;
		data <= x"00000006";
		wait for 640 ns;
		sel(0) <= '0';

      wait;
   end process;

END;
