--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   00:15:56 06/14/2010
-- Design Name:   
-- Module Name:   C:/Users/georgecuris/Desktop/Folders/FPGA/Projects/Current Projects/Systems/OZ-3_System/OZ3_System_TB.vhd
-- Project Name:  OZ-3_System
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: OZ3_System
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
 
ENTITY OZ3_System_TB IS
END OZ3_System_TB;
 
ARCHITECTURE behavior OF OZ3_System_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT OZ3_System
    PORT(
         clock : IN  std_logic;
         reset : IN  std_logic;
         key_clock : IN  std_logic;
         key_data : IN  std_logic;
         button_0 : IN  std_logic;
         button_1 : IN  std_logic;
         button_2 : IN  std_logic;
         switches : IN  std_logic_vector(7 downto 0);
         anodes : OUT  std_logic_vector(3 downto 0);
         decoder_out : OUT  std_logic_vector(6 downto 0);
         LCD_data_bus_out : OUT  std_logic_vector(7 downto 0);
         LCD_RW : OUT  std_logic;
         LCD_RS : OUT  std_logic;
         LCD_E : OUT  std_logic;
         LEDs : OUT  std_logic_vector(7 downto 0);
         memory_data_bus : INOUT  std_logic_vector(15 downto 0);
         memory_address_bus : OUT  std_logic_vector(22 downto 0);
         dRAM_ce : OUT  std_logic;
         dRAM_lb : OUT  std_logic;
         dRAM_ub : OUT  std_logic;
         dRAM_adv : OUT  std_logic;
         dRAM_cre : OUT  std_logic;
         dRAM_clk : OUT  std_logic;
         flash_ce : OUT  std_logic;
         flash_rp : OUT  std_logic;
         mem_oe : OUT  std_logic;
         mem_we : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clock : std_logic := '0';
   signal reset : std_logic := '0';
   signal key_clock : std_logic := '0';
   signal key_data : std_logic := '0';
   signal button_0 : std_logic := '0';
   signal button_1 : std_logic := '0';
   signal button_2 : std_logic := '0';
   signal switches : std_logic_vector(7 downto 0) := (others => '0');

	--BiDirs
   signal memory_data_bus : std_logic_vector(15 downto 0);

 	--Outputs
   signal anodes : std_logic_vector(3 downto 0);
   signal decoder_out : std_logic_vector(6 downto 0);
   signal LCD_data_bus_out : std_logic_vector(7 downto 0);
   signal LCD_RW : std_logic;
   signal LCD_RS : std_logic;
   signal LCD_E : std_logic;
   signal LEDs : std_logic_vector(7 downto 0);
   signal memory_address_bus : std_logic_vector(22 downto 0);
   signal dRAM_ce : std_logic;
   signal dRAM_lb : std_logic;
   signal dRAM_ub : std_logic;
   signal dRAM_adv : std_logic;
   signal dRAM_cre : std_logic;
   signal dRAM_clk : std_logic;
   signal flash_ce : std_logic;
   signal flash_rp : std_logic;
   signal mem_oe : std_logic;
   signal mem_we : std_logic;

   -- Clock period definitions
   constant clock_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: OZ3_System PORT MAP (
          clock => clock,
          reset => reset,
          key_clock => key_clock,
          key_data => key_data,
          button_0 => button_0,
          button_1 => button_1,
          button_2 => button_2,
          switches => switches,
          anodes => anodes,
          decoder_out => decoder_out,
          LCD_data_bus_out => LCD_data_bus_out,
          LCD_RW => LCD_RW,
          LCD_RS => LCD_RS,
          LCD_E => LCD_E,
          LEDs => LEDs,
          memory_data_bus => memory_data_bus,
          memory_address_bus => memory_address_bus,
          dRAM_ce => dRAM_ce,
          dRAM_lb => dRAM_lb,
          dRAM_ub => dRAM_ub,
          dRAM_adv => dRAM_adv,
          dRAM_cre => dRAM_cre,
          dRAM_clk => dRAM_clk,
          flash_ce => flash_ce,
          flash_rp => flash_rp,
          mem_oe => mem_oe,
          mem_we => mem_we
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
      -- hold reset state for 100ms.
      wait for 100ms;	

      wait for clock_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
