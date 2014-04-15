--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:14:52 11/09/2009
-- Design Name:   
-- Module Name:   E:/FPGA/Projects/Current Projects/Systems/OZ-3/EX_TB.vhd
-- Project Name:  OZ-3
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: EX
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
 
ENTITY EX_TB IS
END EX_TB;
 
ARCHITECTURE behavior OF EX_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT EX
    PORT(
         clock : IN  std_logic;
         reset : IN  std_logic;
         ALUA_from_ID : IN  std_logic_vector(31 downto 0);
         ALUB_from_ID : IN  std_logic_vector(31 downto 0);
         cntl_from_ID : IN  std_logic_vector(11 downto 0);
         p_flag_from_MEM : IN  std_logic;
         ALUR_to_MEM : OUT  std_logic_vector(31 downto 0);
         dest_reg_addr_to_ID : OUT  std_logic_vector(4 downto 0);
         cond_bit_to_IF : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clock : std_logic := '0';
   signal reset : std_logic := '0';
   signal ALUA_from_ID : std_logic_vector(31 downto 0) := (others => '0');
   signal ALUB_from_ID : std_logic_vector(31 downto 0) := (others => '0');
   signal cntl_from_ID : std_logic_vector(11 downto 0) := (others => '0');
   signal p_flag_from_MEM : std_logic := '0';

 	--Outputs
   signal ALUR_to_MEM : std_logic_vector(31 downto 0);
   signal dest_reg_addr_to_ID : std_logic_vector(4 downto 0);
   signal cond_bit_to_IF : std_logic;

   -- Clock period definitions
   constant clock_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: EX PORT MAP (
          clock => clock,
          reset => reset,
          ALUA_from_ID => ALUA_from_ID,
          ALUB_from_ID => ALUB_from_ID,
          cntl_from_ID => cntl_from_ID,
          p_flag_from_MEM => p_flag_from_MEM,
          ALUR_to_MEM => ALUR_to_MEM,
          dest_reg_addr_to_ID => dest_reg_addr_to_ID,
          cond_bit_to_IF => cond_bit_to_IF
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
		wait for 40 ns;
			reset <= '0';
			ALUA_from_ID <= x"00000001";
			ALUB_from_ID <= x"00000001";
			cntl_from_ID <= b"00001_000_0000";
			p_flag_from_MEM <= '0';
		wait for 20 ns;
			reset <= '0';
			ALUA_from_ID <= x"00000002";
			ALUB_from_ID <= x"00000001";
			cntl_from_ID <= b"00001_011_0000";
			p_flag_from_MEM <= '0';
      wait;
   end process;

END;
