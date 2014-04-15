--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   08:50:46 10/30/2009
-- Design Name:   
-- Module Name:   E:/FPGA/Projects/Current Projects/Systems/OZ-3/RegFile_TB.vhd
-- Project Name:  OZ-3
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: RegFile
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
 
ENTITY RegFile_TB IS
END RegFile_TB;
 
ARCHITECTURE behavior OF RegFile_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT RegFile
    PORT(
         clock : IN  std_logic;
         reset : IN  std_logic;
         write_e : IN  std_logic;
         data_in : IN  std_logic_vector(31 downto 0);
         r_addr1 : IN  std_logic_vector(4 downto 0);
         r_addr2 : IN  std_logic_vector(4 downto 0);
         r_addr3 : IN  std_logic_vector(4 downto 0);
         w_addr1 : IN  std_logic_vector(4 downto 0);
         data_out_1 : OUT  std_logic_vector(31 downto 0);
         data_out_2 : OUT  std_logic_vector(31 downto 0);
         data_out_3 : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clock : std_logic := '0';
   signal reset : std_logic := '0';
   signal write_e : std_logic := '0';
   signal data_in : std_logic_vector(31 downto 0) := (others => '0');
   signal r_addr1 : std_logic_vector(4 downto 0) := (others => '0');
   signal r_addr2 : std_logic_vector(4 downto 0) := (others => '0');
   signal r_addr3 : std_logic_vector(4 downto 0) := (others => '0');
   signal w_addr1 : std_logic_vector(4 downto 0) := (others => '0');

 	--Outputs
   signal data_out_1 : std_logic_vector(31 downto 0);
   signal data_out_2 : std_logic_vector(31 downto 0);
   signal data_out_3 : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: RegFile PORT MAP (
          clock => clock,
          reset => reset,
          write_e => write_e,
          data_in => data_in,
          r_addr1 => r_addr1,
          r_addr2 => r_addr2,
          r_addr3 => r_addr3,
          w_addr1 => w_addr1,
          data_out_1 => data_out_1,
          data_out_2 => data_out_2,
          data_out_3 => data_out_3
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
			w_addr1 <= b"00001";
			data_in <= x"00000001";
			write_e <= '1';
		wait for 10 ns;
			w_addr1 <= b"00010";
			data_in <= x"00000002";
			write_e <= '1';
		wait for 10 ns;
			w_addr1 <= b"00011";
			data_in <= x"00000003";
			write_e <= '1';
		wait for 10 ns;
			r_addr1 <= b"00001";
			r_addr2 <= b"00010";
			r_addr3 <= b"00011";
      wait;
   end process;

END;
