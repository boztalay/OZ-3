--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:49:54 12/19/2009
-- Design Name:   
-- Module Name:   E:/FPGA/Projects/Current Projects/Systems/OZ-3/ID_TB.vhd
-- Project Name:  OZ-3
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ID
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
 
ENTITY ID_TB IS
END ID_TB;
 
ARCHITECTURE behavior OF ID_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ID
    PORT(
         clock : IN  std_logic;
         reset : IN  std_logic;
         instruction_in : IN  std_logic_vector(31 downto 0);
         rfile_read_addr3 : IN  std_logic_vector(4 downto 0);
         rfile_write_addr : IN  std_logic_vector(4 downto 0);
         rfile_write_data : IN  std_logic_vector(31 downto 0);
         rfile_write_e : IN  std_logic;
         forward_data_EX : IN  std_logic_vector(31 downto 0);
         forward_data_MEMIO : IN  std_logic_vector(31 downto 0);
         forward_data_WB : IN  std_logic_vector(31 downto 0);
         forward_addr_EX : IN  std_logic_vector(4 downto 0);
         forward_addr_MEMIO : IN  std_logic_vector(4 downto 0);
         forward_addr_WB : IN  std_logic_vector(4 downto 0);
         ALU_A_to_ID : OUT  std_logic_vector(31 downto 0);
         ALU_B_to_ID : OUT  std_logic_vector(31 downto 0);
         EX_control : OUT  std_logic_vector(11 downto 0);
         load_store_reg_data : OUT  std_logic_vector(31 downto 0);
         MEMIO_control : OUT  std_logic_vector(20 downto 0);
         WB_control : OUT  std_logic_vector(5 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clock : std_logic := '0';
   signal reset : std_logic := '0';
   signal instruction_in : std_logic_vector(31 downto 0) := (others => '0');
   signal rfile_read_addr3 : std_logic_vector(4 downto 0) := (others => '0');
   signal rfile_write_addr : std_logic_vector(4 downto 0) := (others => '0');
   signal rfile_write_data : std_logic_vector(31 downto 0) := (others => '0');
   signal rfile_write_e : std_logic := '0';
   signal forward_data_EX : std_logic_vector(31 downto 0) := (others => '0');
   signal forward_data_MEMIO : std_logic_vector(31 downto 0) := (others => '0');
   signal forward_data_WB : std_logic_vector(31 downto 0) := (others => '0');
   signal forward_addr_EX : std_logic_vector(4 downto 0) := (others => '0');
   signal forward_addr_MEMIO : std_logic_vector(4 downto 0) := (others => '0');
   signal forward_addr_WB : std_logic_vector(4 downto 0) := (others => '0');

 	--Outputs
   signal ALU_A_to_ID : std_logic_vector(31 downto 0);
   signal ALU_B_to_ID : std_logic_vector(31 downto 0);
   signal EX_control : std_logic_vector(11 downto 0);
   signal load_store_reg_data : std_logic_vector(31 downto 0);
   signal MEMIO_control : std_logic_vector(20 downto 0);
   signal WB_control : std_logic_vector(5 downto 0);

   -- Clock period definitions
   constant clock_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ID PORT MAP (
          clock => clock,
          reset => reset,
          instruction_in => instruction_in,
          rfile_read_addr3 => rfile_read_addr3,
          rfile_write_addr => rfile_write_addr,
          rfile_write_data => rfile_write_data,
          rfile_write_e => rfile_write_e,
          forward_data_EX => forward_data_EX,
          forward_data_MEMIO => forward_data_MEMIO,
          forward_data_WB => forward_data_WB,
          forward_addr_EX => forward_addr_EX,
          forward_addr_MEMIO => forward_addr_MEMIO,
          forward_addr_WB => forward_addr_WB,
          ALU_A_to_ID => ALU_A_to_ID,
          ALU_B_to_ID => ALU_B_to_ID,
          EX_control => EX_control,
          load_store_reg_data => load_store_reg_data,
          MEMIO_control => MEMIO_control,
          WB_control => WB_control
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
			instruction_in <= x"00000000";
			rfile_write_e <= '1';
		wait for 30 ns;
			rfile_write_addr <= b"00001";
			rfile_write_data <= x"00000001";
		wait for 20 ns;
			rfile_write_addr <= b"00010";
			rfile_write_data <= x"00000002";
		wait for 20 ns;
			rfile_write_addr <= b"00011";
			rfile_write_data <= x"00000003";	
			forward_addr_EX <= b"00010";
			forward_data_EX <= x"0000000F";
			forward_addr_MEMIO <= b"00010";
			forward_data_MEMIO <= x"0000000E";
			forward_addr_WB <= b"00011";
			forward_data_WB <= x"0000000D";
		wait for 20 ns;
			instruction_in <= b"00100000001000110000000000000111";
      wait;
   end process;

END;
