--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:19:49 05/08/2010
-- Design Name:   
-- Module Name:   C:/Users/georgecuris/Desktop/Folders/FPGA/Projects/Current Projects/Systems/OZ-3_System/OZ3_TB.vhd
-- Project Name:  OZ-3_System
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: OZ3
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
 
ENTITY OZ3_TB IS
END OZ3_TB;
 
ARCHITECTURE behavior OF OZ3_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT OZ3
    PORT(
         main_clock : IN  std_logic;
         dbl_clock : IN  std_logic;
         inv_clock : IN  std_logic;
         reset : IN  std_logic;
         input_pins : IN  std_logic_vector(15 downto 0);
         input_port : IN  std_logic_vector(31 downto 0);
         instruction_in : IN  std_logic_vector(15 downto 0);
         dRAM_data_in : IN  std_logic_vector(15 downto 0);
         output_pins : OUT  std_logic_vector(15 downto 0);
         output_port : OUT  std_logic_vector(31 downto 0);
         instruction_addr_out : OUT  std_logic_vector(22 downto 0);
         dRAM_data_out : OUT  std_logic_vector(15 downto 0);
         dRAM_addr_out : OUT  std_logic_vector(22 downto 0);
         dRAM_WR_out : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal main_clock : std_logic := '0';
   signal dbl_clock : std_logic := '0';
   signal inv_clock : std_logic := '0';
   signal reset : std_logic := '0';
   signal input_pins : std_logic_vector(15 downto 0) := (others => '0');
   signal input_port : std_logic_vector(31 downto 0) := (others => '0');
   signal instruction_in : std_logic_vector(15 downto 0) := (others => '0');
   signal dRAM_data_in : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal output_pins : std_logic_vector(15 downto 0);
   signal output_port : std_logic_vector(31 downto 0);
   signal instruction_addr_out : std_logic_vector(22 downto 0);
   signal dRAM_data_out : std_logic_vector(15 downto 0);
   signal dRAM_addr_out : std_logic_vector(22 downto 0);
   signal dRAM_WR_out : std_logic;

   -- Clock period definitions
   constant main_clock_period : time := 20 ns;
   constant dbl_clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: OZ3 PORT MAP (
          main_clock => main_clock,
          dbl_clock => dbl_clock,
          inv_clock => inv_clock,
          reset => reset,
          input_pins => input_pins,
          input_port => input_port,
          instruction_in => instruction_in,
          dRAM_data_in => dRAM_data_in,
          output_pins => output_pins,
          output_port => output_port,
          instruction_addr_out => instruction_addr_out,
          dRAM_data_out => dRAM_data_out,
          dRAM_addr_out => dRAM_addr_out,
          dRAM_WR_out => dRAM_WR_out
        );

   -- Clock process definitions
   main_clock_process :process
   begin
		main_clock <= '1';
		inv_clock <= '0';
		wait for main_clock_period/2;
		main_clock <= '0';
		inv_clock <= '1';
		wait for main_clock_period/2;
   end process;
 
   dbl_clock_process :process
   begin
		dbl_clock <= '1';
		wait for dbl_clock_period/2;
		dbl_clock <= '0';
		wait for dbl_clock_period/2;
   end process;
	
	dRAM_data_test :process
	begin
		wait for 2.5 ns;
		loop
			dRAM_data_in <= x"0000";
			wait for 5 ns;
			dRAM_data_in <= x"FFFF";
			wait for 5 ns;
		end loop;
	end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      wait for 200 ns;
			instruction_in <= "0110000000100000";
		wait for 10 ns;
			instruction_in <= "0000000000000011";
		wait for 10 ns;
			instruction_in <= x"0000";
      wait;
   end process;

END;
