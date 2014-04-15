----------------------------------------------------------------------------------
--Ben Oztalay, 2009-2010
--
--This VHDL code is part of the OZ-3, a 32-bit processor
--
--Module Title: OZ3_System
--Module Description:
--	This is the module that brings all of the pieces together; the OZ-3, the
--	clock generator, and the memory bus controller. Other pieces of hardware
--	can be added to expand the system, such as a 7-segment decoder or VGA
--	controller.
--
--Notes:
-- Nomenclature for signals: OZ3_dRAM_data_to_MC
--									  |^| |---^---| |-^-|
--										|	    |       |
--							sending module  |  receiving module
-- 								 signal name/content
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity OZ3_System is
	Port ( clock : in STD_LOGIC;
			 reset : in STD_LOGIC;
			 
			 --For the keyboard interface
			 key_clock : in STD_LOGIC;
			 key_data : in STD_LOGIC;
			 
			 --Pushbuttons
			 button_0 : in STD_LOGIC;
			 button_1 : in STD_LOGIC;
			 button_2 : in STD_LOGIC;
			 
			 --Switches
			 switches : in STD_LOGIC_VECTOR(7 downto 0);
			 
			 --Control signals for the 4-digit, 7-segment display
			 anodes : out STD_LOGIC_VECTOR(3 downto 0);
			 decoder_out : out STD_LOGIC_VECTOR(6 downto 0);
			 
			 --Outputs for the LCD
			 LCD_data_bus_out : out STD_LOGIC_VECTOR(7 downto 0);
			 LCD_RW : out STD_LOGIC;
			 LCD_RS : out STD_LOGIC;
			 LCD_E  : out STD_LOGIC;
			 
			 --Output to the LEDs
			 LEDs : out STD_LOGIC_VECTOR(7 downto 0);
			 
			 --Memory data and address buses
			 memory_data_bus : inout STD_LOGIC_VECTOR(15 downto 0);
			 memory_address_bus : out STD_LOGIC_VECTOR(22 downto 0);
			 
			 --Data RAM control signals
			 dRAM_ce : out STD_LOGIC;
			 dRAM_lb : out STD_LOGIC;
			 dRAM_ub : out STD_LOGIC;
			 dRAM_adv : out STD_LOGIC;
			 dRAM_cre : out STD_LOGIC;
			 dRAM_clk : out STD_LOGIC;
			 
			 --Instruction Flash control signals
			 flash_ce : out STD_LOGIC;
			 flash_rp : out STD_LOGIC;
			 
			 --Shared memory signals
			 mem_oe : out STD_LOGIC;
			 mem_we : out STD_LOGIC);
end OZ3_System;

architecture Behavioral of OZ3_System is

--//Components\\--

--The OZ-3
component OZ3 is
	Port ( main_clock : in STD_LOGIC;
		    dbl_clock  : in STD_LOGIC;
			 inv_clock  : in STD_LOGIC;
			 reset : in STD_LOGIC;
			 input_pins : in STD_LOGIC_VECTOR(15 downto 0);
			 input_port : in STD_LOGIC_VECTOR(31 downto 0);
			 instruction_from_iROM : in STD_LOGIC_VECTOR(15 downto 0);
			 data_from_dRAM : in STD_LOGIC_VECTOR(15 downto 0);
			 output_pins : out STD_LOGIC_VECTOR(15 downto 0);
			 output_port : out STD_LOGIC_VECTOR(31 downto 0);
			 output_port_enable : out STD_LOGIC;
			 addr_to_iROM : out STD_LOGIC_VECTOR(22 downto 0);
			 data_to_dRAM : out STD_LOGIC_VECTOR(15 downto 0);
			 addr_to_dRAM : out STD_LOGIC_VECTOR(22 downto 0);
			 WR_to_dRAM : out STD_LOGIC);
end component;

--The memory bus controller
component Mem_Ctrl is
	Port ( flash_address_from_OZ3 : in STD_LOGIC_VECTOR(22 downto 0);
			 dbl_clk_from_OZ3 : in STD_LOGIC;
			 dRAM_WR_from_OZ3 : in STD_LOGIC;
			 dRAM_address_from_OZ3 : in STD_LOGIC_VECTOR(22 downto 0);			 
			 dRAM_data_from_OZ3 : in STD_LOGIC_VECTOR(15 downto 0);
			 data_bus : in STD_LOGIC_VECTOR(15 downto 0);
			 dRAM_ce : out STD_LOGIC;
			 dRAM_lb : out STD_LOGIC;
			 dRAM_ub : out STD_LOGIC;
			 dRAM_adv : out STD_LOGIC;
			 dRAM_cre : out STD_LOGIC;
			 dRAM_clk : out STD_LOGIC;
			 flash_ce : out STD_LOGIC;
			 flash_rp : out STD_LOGIC;
			 mem_oe : out STD_LOGIC;
			 mem_we : out STD_LOGIC;
			 address_bus : out STD_LOGIC_VECTOR(22 downto 0);
			 dRAM_data_to_OZ3 : out STD_LOGIC_VECTOR(15 downto 0);
			 instruction_to_OZ3 : out STD_LOGIC_VECTOR(15 downto 0));
end component;

--The clock manager/generator
component Clock_Mgt is
    Port ( board_clock : in  STD_LOGIC;
           clock1_out : out  STD_LOGIC;
			  clock2_out : out STD_LOGIC;
			  clock3_out : out STD_LOGIC;
			  clock4_out : out STD_LOGIC);
end component;

--The 4-digit, 7-segment decoder
component four_dig_7seg is
    Port ( clock : in  STD_LOGIC;
           display_data : in  STD_LOGIC_VECTOR (15 downto 0);
           anodes : out  STD_LOGIC_VECTOR (3 downto 0);
           to_display : out  STD_LOGIC_VECTOR (6 downto 0));
end component;

--An input port extender for the OZ-3
component Input_Port_MUX is
    Port ( input0 : in  STD_LOGIC_VECTOR (31 downto 0);
           input1 : in  STD_LOGIC_VECTOR (31 downto 0);
           input2 : in  STD_LOGIC_VECTOR (31 downto 0);
           input3 : in  STD_LOGIC_VECTOR (31 downto 0);
           sel : in  STD_LOGIC_VECTOR (1 downto 0);
           output : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

--An output port extender for the OZ-3
component Output_Port_MUX is
    Port ( clock : in STD_LOGIC;
			  reset : in STD_LOGIC;
			  enable : in STD_LOGIC;
			  data : in  STD_LOGIC_VECTOR (31 downto 0);
           sel : in  STD_LOGIC_VECTOR (1 downto 0);
           output0 : out  STD_LOGIC_VECTOR (31 downto 0);
           output1 : out  STD_LOGIC_VECTOR (31 downto 0);
           output2 : out  STD_LOGIC_VECTOR (31 downto 0);
           output3 : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

--A simple debouncer for inputs
component Debouncer is
    Port ( clock : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           input : in  STD_LOGIC;
           output : out  STD_LOGIC);
end component;

--A keyboard interface controller
component Keyboard is
    Port ( key_clock : in  STD_LOGIC;
           key_data : in  STD_LOGIC;
           acknowledge : in  STD_LOGIC;
           scan_code : out  STD_LOGIC_VECTOR (0 to 7);
           code_ready : out  STD_LOGIC);
end component;

--\\Components//--

--//Signals\\--

--These signals cary the four clock signals from the clock manager
--to other parts of the system
signal clock_1 : STD_LOGIC;
signal clock_2 : STD_LOGIC;
signal clock_3 : STD_LOGIC;
signal clock_4 : STD_LOGIC;

----Signals between the MC and OZ3
signal OZ3_instruction_addr_to_MC : STD_LOGIC_VECTOR(22 downto 0); --Signals used to send data from OZ-3 to the
signal OZ3_dRAM_data_to_MC : STD_LOGIC_VECTOR(15 downto 0);        --memory controller
signal OZ3_dRAM_addr_to_MC : STD_LOGIC_VECTOR(22 downto 0);
signal OZ3_dRAM_WR_to_MC : STD_LOGIC;

signal MC_instruction_to_OZ3 : STD_LOGIC_VECTOR(15 downto 0);      --Signals used to send data from the memory
signal MC_dRAM_data_to_OZ3 : STD_LOGIC_VECTOR(15 downto 0);        --controller to the OZ-3

--OZ3 I/O bus signals
--These are the signals that the OZ-3 directly takes input from and outputs to.
--Simply use them to connect to peripheral hardware
signal OZ3_input_pins_sig : STD_LOGIC_VECTOR(15 downto 0);
signal OZ3_input_port_sig : STD_LOGIC_VECTOR(31 downto 0);
signal OZ3_output_pins_sig : STD_LOGIC_VECTOR(15 downto 0);
signal OZ3_output_port_sig : STD_LOGIC_VECTOR(31 downto 0);

--Port extension signals
signal OZ3_ex_oport_0_sig : STD_LOGIC_VECTOR(31 downto 0);
signal OZ3_ex_oport_1_sig : STD_LOGIC_VECTOR(31 downto 0);
signal OZ3_ex_oport_2_sig : STD_LOGIC_VECTOR(31 downto 0);
signal OZ3_ex_oport_3_sig : STD_LOGIC_VECTOR(31 downto 0);
signal output_port_MUX_sel : STD_LOGIC_VECTOR(1 downto 0);
signal output_port_MUX_data : STD_LOGIC_VECTOR(31 downto 0);
signal OZ3_output_port_enable : STD_LOGIC;

signal OZ3_ex_iport_0_sig : STD_LOGIC_VECTOR(31 downto 0);
signal OZ3_ex_iport_1_sig : STD_LOGIC_VECTOR(31 downto 0);
signal OZ3_ex_iport_2_sig : STD_LOGIC_VECTOR(31 downto 0);
signal OZ3_ex_iport_3_sig : STD_LOGIC_VECTOR(31 downto 0);
signal input_port_MUX_sel : STD_LOGIC_VECTOR(1 downto 0);
signal input_port_MUX_out : STD_LOGIC_VECTOR(31 downto 0);

--Keyboard signals
signal key_scan_code_sig : STD_LOGIC_VECTOR(7 downto 0); --The code ready signal from the keyboard interface
signal key_acknowledge : STD_LOGIC; --Carries the acknowledgment signal to the keyboard module
signal key_code_ready : STD_LOGIC; --Carries the code ready signal to the OZ-3

--Debounced buttons
signal button_0_debnc : STD_LOGIC;
signal button_1_debnc : STD_LOGIC;
signal button_2_debnc : STD_LOGIC;

--Other signals
signal display_data : STD_LOGIC_VECTOR(15 downto 0); --Carries display data to the 7-segment display decoder

--\\Signals//--

begin

	--OZ-3 instantiation
	OZ3_inst : OZ3 port map (main_clock => clock_1,
									 dbl_clock => clock_2,
									 inv_clock => clock_3,
									 reset => reset, 
									 input_pins => OZ3_input_pins_sig, 
									 input_port => OZ3_input_port_sig,
									 instruction_from_iROM => MC_instruction_to_OZ3,
									 data_from_dRAM => MC_dRAM_data_to_OZ3,
									 output_pins => OZ3_output_pins_sig,
									 output_port => OZ3_output_port_sig,
									 output_port_enable => OZ3_output_port_enable,
									 addr_to_iROM => OZ3_instruction_addr_to_MC,
									 data_to_dRAM => OZ3_dRAM_data_to_MC,
									 addr_to_dRAM => OZ3_dRAM_addr_to_MC,
									 WR_to_dRAM => OZ3_dRAM_WR_to_MC);
									 
	--Memory bus controller instantiation		 
	mem_ctrl_inst : Mem_Ctrl port map (flash_address_from_OZ3 => OZ3_instruction_addr_to_MC,
												  dbl_clk_from_OZ3 => clock_4,
												  dRAM_WR_from_OZ3 => OZ3_dRAM_WR_to_MC,
												  dRAM_address_from_OZ3 => OZ3_dRAM_addr_to_MC,
												  dRAM_data_from_OZ3 => OZ3_dRAM_data_to_MC,
												  data_bus => memory_data_bus,
												  dRAM_ce => dRAM_ce,
												  dRAM_lb => dRAM_lb,
												  dRAM_ub => dRAM_ub,
												  dRAM_adv => dRAM_adv,
												  dRAM_cre => dRAM_cre,
												  dRAM_clk => dRAM_clk,
												  flash_ce => flash_ce,
												  flash_rp => flash_rp,
												  mem_oe => mem_oe,
												  mem_we => mem_we,
												  address_bus => memory_address_bus,
												  dRAM_data_to_OZ3 => MC_dRAM_data_to_OZ3,
												  instruction_to_OZ3 => MC_instruction_to_OZ3);
	
	--Clock manager instantiation
	clk_mgt : Clock_Mgt port map (clock,
											clock_1,
											clock_2,
											clock_3,
											clock_4);
	
	--7-segment display decoder instantiation
	--This is an example of peripheral hardware that can be added to the system
	Decoder: four_dig_7seg port map (clock => clock,
												display_data => display_data,
												anodes => anodes,
												to_display => decoder_out);
												
	Input_Extender: Input_Port_MUX port map (input0 => OZ3_ex_iport_0_sig,
														  input1 => OZ3_ex_iport_1_sig,
														  input2 => OZ3_ex_iport_2_sig,
														  input3 => OZ3_ex_iport_3_sig,
														  sel => input_port_MUX_sel,
														  output => input_port_MUX_out);
	
	Output_Extender: Output_Port_MUX port map (clock => clock_1,
															 reset => reset,
															 enable => OZ3_output_port_enable,
															 data => output_port_MUX_data,
															 sel => output_port_MUX_sel,
															 output0 => OZ3_ex_oport_0_sig,
															 output1 => OZ3_ex_oport_1_sig,
															 output2 => OZ3_ex_oport_2_sig,
															 output3 => OZ3_ex_oport_3_sig);
												
	--The debouncers for the pushbuttons
	Debounce1: Debouncer port map (clock => clock,
											 reset => reset,
											 input => button_0,
											 output => button_0_debnc);
											 
	Debounce2: Debouncer port map (clock => clock,
											 reset => reset,
											 input => button_1,
											 output => button_1_debnc);
	
	Debounce3: Debouncer port map (clock => clock,
											 reset => reset,
											 input => button_2,
											 output => button_2_debnc);
											 
	--The keyboard controller
	keyboard_cntl : Keyboard port map (key_clock => key_clock,
												  key_data => key_data,
												  acknowledge => key_acknowledge,
												  scan_code => key_scan_code_sig,
												  code_ready => key_code_ready);

	--Assigning the OZ-3 I/O
	
	--Main input and output ports
	OZ3_input_port_sig <= input_port_MUX_out;
	output_port_MUX_data <= OZ3_output_port_sig;
	
	--The input pins
	OZ3_input_pins_sig(0)  <= button_2_debnc;
	OZ3_input_pins_sig(1)  <= button_1_debnc;
	OZ3_input_pins_sig(2)  <= button_0_debnc;
	OZ3_input_pins_sig(3)  <= '0';
	OZ3_input_pins_sig(4)  <= '0';
	OZ3_input_pins_sig(5)  <= '0';
	OZ3_input_pins_sig(6)  <= '0';
	OZ3_input_pins_sig(7)  <= '0';
	OZ3_input_pins_sig(8)  <= '0';
	OZ3_input_pins_sig(9)  <= '0';
	OZ3_input_pins_sig(10) <= '0';
	OZ3_input_pins_sig(11) <= '0';
	OZ3_input_pins_sig(12) <= '0';
	OZ3_input_pins_sig(13) <= '0';
	OZ3_input_pins_sig(14) <= '0';
	OZ3_input_pins_sig(15) <= key_code_ready;

--	--The output pins
--	? <= OZ3_output_pins_sig(0);
--	? <= OZ3_output_pins_sig(1);
--	? <= OZ3_output_pins_sig(2);
--	? <= OZ3_output_pins_sig(3);
--	? <= OZ3_output_pins_sig(4);
--	? <= OZ3_output_pins_sig(5);
--	? <= OZ3_output_pins_sig(6);
--	? <= OZ3_output_pins_sig(7);
	LCD_E <= OZ3_output_pins_sig(8);
	LCD_RS <= OZ3_output_pins_sig(9);
	LCD_RW <= OZ3_output_pins_sig(10);
	key_acknowledge <= OZ3_output_pins_sig(11);
	input_port_MUX_sel(0) <= OZ3_output_pins_sig(12);
	input_port_MUX_sel(1) <= OZ3_output_pins_sig(13);
	output_port_MUX_sel(0) <= OZ3_output_pins_sig(14);
	output_port_MUX_sel(1) <= OZ3_output_pins_sig(15);
	
	--The input ports
	--Keyboard scan code
	OZ3_ex_iport_0_sig <= x"000000" & key_scan_code_sig;
	--Switches
	OZ3_ex_iport_1_sig <= x"000000" & switches;
	--Blank
	OZ3_ex_iport_2_sig <= x"00000000";
	--Blank
	OZ3_ex_iport_3_sig <= x"00000000";
	
	--The output ports
	--LCD data bus
	LCD_data_bus_out <= OZ3_ex_oport_0_sig(7 downto 0);
	--LEDs
	LEDs <= OZ3_ex_oport_1_sig(7 downto 0);
	--Data to the 7-segment display
	display_data <= OZ3_ex_oport_2_sig(15 downto 0);
	--Output port 3 is blank
	-- ? <= OZ3_ex_oport_3_sig
	
end Behavioral;

