--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   00:34:53 05/09/2010
-- Design Name:   
-- Module Name:   C:/Users/georgecuris/Desktop/Folders/FPGA/Projects/Current Projects/Systems/OZ-3_System/Mem_Ctrl_TB.vhd
-- Project Name:  OZ-3_System
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Mem_Ctrl
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
 
ENTITY Mem_Ctrl_TB IS
END Mem_Ctrl_TB;
 
ARCHITECTURE behavior OF Mem_Ctrl_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Mem_Ctrl
    PORT(
         flash_address_from_OZ3 : IN  std_logic_vector(22 downto 0);
         dbl_clk_from_OZ3 : IN  std_logic;
         dRAM_WR_from_OZ3 : IN  std_logic;
         dRAM_address_from_OZ3 : IN  std_logic_vector(22 downto 0);
         dRAM_data_from_OZ3 : IN  std_logic_vector(15 downto 0);
         data_bus : IN  std_logic_vector(15 downto 0);
         dRAM_ce : OUT  std_logic;
         dRAM_lb : OUT  std_logic;
         dRAM_ub : OUT  std_logic;
         dRAM_adv : OUT  std_logic;
         dRAM_cre : OUT  std_logic;
         dRAM_clk : OUT  std_logic;
         flash_ce : OUT  std_logic;
         mem_oe : OUT  std_logic;
         mem_we : OUT  std_logic;
         address_bus : OUT  std_logic_vector(22 downto 0);
         dRAM_data_to_OZ3 : OUT  std_logic_vector(15 downto 0);
         instruction_to_OZ3 : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal flash_address_from_OZ3 : std_logic_vector(22 downto 0) := (others => '0');
   signal dbl_clk_from_OZ3 : std_logic := '0';
   signal dRAM_WR_from_OZ3 : std_logic := '0';
   signal dRAM_address_from_OZ3 : std_logic_vector(22 downto 0) := (others => '0');
   signal dRAM_data_from_OZ3 : std_logic_vector(15 downto 0) := (others => '0');
   signal data_bus : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal dRAM_ce : std_logic;
   signal dRAM_lb : std_logic;
   signal dRAM_ub : std_logic;
   signal dRAM_adv : std_logic;
   signal dRAM_cre : std_logic;
   signal dRAM_clk : std_logic;
   signal flash_ce : std_logic;
   signal mem_oe : std_logic;
   signal mem_we : std_logic;
   signal address_bus : std_logic_vector(22 downto 0);
   signal dRAM_data_to_OZ3 : std_logic_vector(15 downto 0);
   signal instruction_to_OZ3 : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant dbl_clk_period : time := 40 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Mem_Ctrl PORT MAP (
          flash_address_from_OZ3 => flash_address_from_OZ3,
          dbl_clk_from_OZ3 => dbl_clk_from_OZ3,
          dRAM_WR_from_OZ3 => dRAM_WR_from_OZ3,
          dRAM_address_from_OZ3 => dRAM_address_from_OZ3,
          dRAM_data_from_OZ3 => dRAM_data_from_OZ3,
          data_bus => data_bus,
          dRAM_ce => dRAM_ce,
          dRAM_lb => dRAM_lb,
          dRAM_ub => dRAM_ub,
          dRAM_adv => dRAM_adv,
          dRAM_cre => dRAM_cre,
          dRAM_clk => dRAM_clk,
          flash_ce => flash_ce,
          mem_oe => mem_oe,
          mem_we => mem_we,
          address_bus => address_bus,
          dRAM_data_to_OZ3 => dRAM_data_to_OZ3,
          instruction_to_OZ3 => instruction_to_OZ3
        );

   -- Clock process definitions
   dbl_clk_process :process
   begin
		dbl_clk_from_OZ3 <= '0';
		wait for dbl_clk_period/2;
		dbl_clk_from_OZ3 <= '1';
		wait for dbl_clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		wait;
   end process;

END;
