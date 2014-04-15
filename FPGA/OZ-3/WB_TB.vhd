--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:50:22 11/11/2009
-- Design Name:   
-- Module Name:   E:/FPGA/Projects/Current Projects/Systems/OZ-3/WB_TB.vhd
-- Project Name:  OZ-3
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: WB
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
 
ENTITY WB_TB IS
END WB_TB;
 
ARCHITECTURE behavior OF WB_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT WB
    PORT(
         clock : IN  std_logic;
         reset : IN  std_logic;
         data_from_MEM : IN  std_logic_vector(31 downto 0);
         cntl_from_ID : IN  std_logic_vector(5 downto 0);
         to_rfile_data : OUT  std_logic_vector(31 downto 0);
         to_rfile_addr : OUT  std_logic_vector(4 downto 0);
         to_rfile_we : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clock : std_logic := '0';
   signal reset : std_logic := '0';
   signal data_from_MEM : std_logic_vector(31 downto 0) := (others => '0');
   signal cntl_from_ID : std_logic_vector(5 downto 0) := (others => '0');

 	--Outputs
   signal to_rfile_data : std_logic_vector(31 downto 0);
   signal to_rfile_addr : std_logic_vector(4 downto 0);
   signal to_rfile_we : std_logic;

   -- Clock period definitions
   constant clock_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: WB PORT MAP (
          clock => clock,
          reset => reset,
          data_from_MEM => data_from_MEM,
          cntl_from_ID => cntl_from_ID,
          to_rfile_data => to_rfile_data,
          to_rfile_addr => to_rfile_addr,
          to_rfile_we => to_rfile_we
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
			cntl_from_ID <= "000011";
		wait for 20 ns;
			cntl_from_ID <= "000101";
		wait for 20 ns;
			cntl_from_ID <= "000111";
			data_from_MEM <= x"00000001";
		wait for 20 ns;
			data_from_MEM <= x"00000002";
		wait for 20 ns;
			data_from_MEM <= x"00000003";
		wait;
   end process;

END;
