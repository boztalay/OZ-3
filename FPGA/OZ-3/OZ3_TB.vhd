--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:49:58 01/01/2010
-- Design Name:   
-- Module Name:   C:/Users/georgecuris/Desktop/Back Up/FPGA/Projects/Current Projects/Systems/OZ-3/OZ3_TB.vhd
-- Project Name:  OZ-3
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
         clock : IN  std_logic;
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
         dRAM_WR_out : OUT  std_logic;
         mem_ctrl_clk_out : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clock : std_logic := '0';
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
   signal mem_ctrl_clk_out : std_logic;

   -- Clock period definitions
   constant clock_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: OZ3 PORT MAP (
          clock => clock,
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
          dRAM_WR_out => dRAM_WR_out,
          mem_ctrl_clk_out => mem_ctrl_clk_out
        );

   -- Clock process definitions
   clock_process :process
   begin
		clock <= '1';
		wait for clock_period/2;
		clock <= '0';
		wait for clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      	reset <= '1';
		wait for 200 ns;
			reset <= '0';
			dRAM_data_in <= x"FFFF";
		--Send instruction addi r1, r0, 7FFF
			instruction_in <= b"0010000000100000";
		wait for 10 ns;
			instruction_in <= b"0111111111111111";
		--End of instruction addi r1, r0, 7FFF
		
		--Send instruction ldu r1, r0, addr
		wait for 10 ns;
			instruction_in <= b"0110010000100000";
		wait for 10 ns;
			instruction_in <= b"0000000111110000";
		--End of instruction ldu r1, r0, addr
		
		--Send instruction addi r2, r0, 8001
		wait for 10 ns;
			instruction_in <= b"0010000001000000";
		wait for 10 ns;
			instruction_in <= b"1000000000000001";
		--End of instruction addi r2, r0, 8001
		
		--Send instruction add r0, r2, r1 (dummy add)
		wait for 10 ns;
			instruction_in <= b"0011110000000010";
		wait for 10 ns;
			instruction_in <= b"0000100000000000";
		--End of instruction add r0, r2, r1
		
		--Send instruction brnc r0, 31
		wait for 10 ns;
			instruction_in <= b"1000010000000000";
		wait for 10 ns;
			instruction_in <= b"0000000000011111";
		--End of instruction brnc r0, 31
		
		wait for 10 ns;
			instruction_in <= b"0000000000000000";
		wait;
   end process;

END;
