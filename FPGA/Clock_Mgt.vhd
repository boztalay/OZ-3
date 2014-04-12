----------------------------------------------------------------------------------
--Ben Oztalay, 2009-2010
--
--This VHDL code is part of the OZ-3 Based Computer System designed for the
--Digilent Nexys 2 FPGA Development Board
--
--Module Title: Clock_Mgt
--Module Description:
--	The clock manager/generator takes the 50 MHz clock from the Nexys 2 board
-- and produces four clock signals using three DCMs. They are:
--		the main clock, 1.5625 MHz
--		the doubled clock, 3.125 MHz
--		an inverted main clock, 1.5625 MHz
--	   a 90 degree shifted doubled clock, 3.125 MHz
-- As a side note, I would have only needed one clock signal if I had my
-- way with which memory resources were on the board and how they were
-- organized.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity Clock_Mgt is
    Port ( board_clock : in  STD_LOGIC;
           clock1_out : out  STD_LOGIC;
			  clock2_out : out STD_LOGIC;
			  clock3_out : out STD_LOGIC;
			  clock4_out : out STD_LOGIC);
end Clock_Mgt;

architecture Behavioral of Clock_Mgt is

--//Signals\\--

--These signals carry DCM 1's outputs and feedback signals
signal DCM_1_out : STD_LOGIC;
signal DCM_1_90 : STD_LOGIC;
signal DCM1_feedback_in : STD_LOGIC;
signal DCM1_feedback_out : STD_LOGIC;

--These signals carry DCM 2's outputs and feedback signals
signal DCM_2_dbl : STD_LOGIC;
signal DCM_2_inv : STD_LOGIC;
signal DCM2_feedback_in : STD_LOGIC;
signal DCM2_feedback_out : STD_LOGIC;

--These signals carry DCM 4's input and output
signal DCM_3_out : STD_LOGIC;
signal DCM_3_in : STD_LOGIC;

--This signal carries the board clock after it's been put
--through a global clock buffer
signal buf_board_clock : STD_LOGIC;

--\\Signals//--

begin

	--This BUFG buffers the board clock
	board_clk: BUFG
		port map (O => buf_board_clock,
					 I => board_clock);

--These DCMs cut the clock down and generate the appropriate clock signals
	
	--DCM 1 generates a shifted 25 MHz clock that'll be cut down by DCM 3 to make the
	--shifted, doubled clock used for the memory bus controller. This DCM also produces
	--the main clock, 1.5625 MHz
	DCM_1 : DCM
   generic map (
      CLKDV_DIVIDE => 2.0, --  Divide by: 1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5,6.0,6.5
                           --     7.0,7.5,8.0,9.0,10.0,11.0,12.0,13.0,14.0,15.0 or 16.0
      CLKFX_DIVIDE => 32,   --  Can be any interger from 1 to 32
		CLKFX_MULTIPLY => 2, --  Can be any integer from 1 to 32
      CLKIN_DIVIDE_BY_2 => TRUE, --  TRUE/FALSE to enable CLKIN divide by two feature
      CLKIN_PERIOD => 40.0,          --  Specify period of input clock
      CLKOUT_PHASE_SHIFT => "NONE", --  Specify phase shift of NONE, FIXED or VARIABLE
      CLK_FEEDBACK => "1X",         --  Specify clock feedback of NONE, 1X or 2X
      DESKEW_ADJUST => "SYSTEM_SYNCHRONOUS", --  SOURCE_SYNCHRONOUS, SYSTEM_SYNCHRONOUS or
                                             --     an integer from 0 to 15
      DFS_FREQUENCY_MODE => "LOW",     --  HIGH or LOW frequency mode for frequency synthesis
      DLL_FREQUENCY_MODE => "LOW",     --  HIGH or LOW frequency mode for DLL
      DUTY_CYCLE_CORRECTION => TRUE, --  Duty cycle correction, TRUE or FALSE
      FACTORY_JF => X"C080",          --  FACTORY JF Values
      PHASE_SHIFT => 0,        --  Amount of fixed phase shift from -255 to 255
      STARTUP_WAIT => FALSE) --  Delay configuration DONE until DCM LOCK, TRUE/FALSE
   port map (
      CLKFX => DCM_1_out,   -- DCM CLK synthesis out (M/D)
      CLKIN => buf_board_clock,
		CLK90 => DCM_1_90,
		
		CLKFB => DCM1_feedback_in,
		CLK0 => DCM1_feedback_out
		);
		
	--This BUFG buffers DCM1's feedback
	DCM1_feedback: BUF
		port map (O => DCM1_feedback_in,
					 I => DCM1_feedback_out);
	
	--DCM 2 produces the inverted main clock, as well as the doubled clock for use by the
	--IF stage
	DCM_2 : DCM
   generic map (
      CLKDV_DIVIDE => 2.0, --  Divide by: 1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5,6.0,6.5
                           --     7.0,7.5,8.0,9.0,10.0,11.0,12.0,13.0,14.0,15.0 or 16.0
      CLKFX_DIVIDE => 2,   --  Can be any interger from 1 to 32
		CLKFX_MULTIPLY => 2, --  Can be any integer from 1 to 32
      CLKIN_DIVIDE_BY_2 => FALSE, --  TRUE/FALSE to enable CLKIN divide by two feature
      CLKIN_PERIOD => 640.0,          --  Specify period of input clock
      CLKOUT_PHASE_SHIFT => "NONE", --  Specify phase shift of NONE, FIXED or VARIABLE
      CLK_FEEDBACK => "1X",         --  Specify clock feedback of NONE, 1X or 2X
      DESKEW_ADJUST => "SYSTEM_SYNCHRONOUS", --  SOURCE_SYNCHRONOUS, SYSTEM_SYNCHRONOUS or
                                             --     an integer from 0 to 15
      DFS_FREQUENCY_MODE => "LOW",     --  HIGH or LOW frequency mode for frequency synthesis
      DLL_FREQUENCY_MODE => "LOW",     --  HIGH or LOW frequency mode for DLL
      DUTY_CYCLE_CORRECTION => TRUE, --  Duty cycle correction, TRUE or FALSE
      FACTORY_JF => X"C080",          --  FACTORY JF Values
      PHASE_SHIFT => 0,        --  Amount of fixed phase shift from -255 to 255
      STARTUP_WAIT => FALSE) --  Delay configuration DONE until DCM LOCK, TRUE/FALSE
   port map (
      CLKIN => DCM_1_out,   -- Clock input (from IBUFG, BUFG or DCM)
		CLK2X => DCM_2_dbl,
		CLK180 => DCM_2_inv,
		
		CLKFB => DCM2_feedback_in,
		CLK0 => DCM2_feedback_out
		);
		
	--This BUFG buffers DCM3's feedback
	DCM2_feedback: BUF
		port map (O => DCM2_feedback_in,
					 I => DCM2_feedback_out);
	
	--This buffer takes care of buffering the 25 MHz shifted clock from DCM 1 so
	--that DCM 3 can use it. I had to do this because of, I think, fanout problems
	DCM1_DCM3_buf: BUFG
		port map (O => DCM_3_in,
					 I => DCM_1_90);
					 
	--DCM 3 takes the shifted, 25 MHz clock signal and divides it down to 3.125 MHz as the
	--shifted, doubled clock that the memory bus controller uses
	DCM_3 : DCM
   generic map (
      CLKDV_DIVIDE => 2.0, --  Divide by: 1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5,6.0,6.5
                           --     7.0,7.5,8.0,9.0,10.0,11.0,12.0,13.0,14.0,15.0 or 16.0
      CLKFX_DIVIDE => 16,   --  Can be any interger from 1 to 32
		CLKFX_MULTIPLY => 2, --  Can be any integer from 1 to 32
      CLKIN_DIVIDE_BY_2 => FALSE, --  TRUE/FALSE to enable CLKIN divide by two feature
      CLKIN_PERIOD => 40.0,          --  Specify period of input clock
      CLKOUT_PHASE_SHIFT => "NONE", --  Specify phase shift of NONE, FIXED or VARIABLE
      CLK_FEEDBACK => "NONE",         --  Specify clock feedback of NONE, 1X or 2X
      DESKEW_ADJUST => "SYSTEM_SYNCHRONOUS", --  SOURCE_SYNCHRONOUS, SYSTEM_SYNCHRONOUS or
                                             --     an integer from 0 to 15
      DFS_FREQUENCY_MODE => "LOW",     --  HIGH or LOW frequency mode for frequency synthesis
      DLL_FREQUENCY_MODE => "LOW",     --  HIGH or LOW frequency mode for DLL
      DUTY_CYCLE_CORRECTION => TRUE, --  Duty cycle correction, TRUE or FALSE
      FACTORY_JF => X"C080",          --  FACTORY JF Values
      PHASE_SHIFT => 0,        --  Amount of fixed phase shift from -255 to 255
      STARTUP_WAIT => FALSE) --  Delay configuration DONE until DCM LOCK, TRUE/FALSE
   port map (
      CLKFX => DCM_3_out,   -- DCM CLK synthesis out (M/D)
      CLKIN => DCM_3_in
		);
								
	--Because of the high fanout of some of these clocks, I placed them all on
	--global clock buffers. To be perfectly honest, I'm not sure I needed to do
	--this, but I think it provides higher stability
	
	--Main Clock
	clock1_out_buf: BUFG
		port map (O => clock1_out,
					 I => DCM_1_out);
	--Doubled Clock
	clock2_out_buf: BUFG
		port map (O => clock2_out,
					 I => DCM_2_dbl);
	--Inverted Clock
	clock3_out_buf: BUFG
		port map (O => clock3_out,
					 I => DCM_2_inv);
	--Shifted Clock
	clock4_out_buf: BUFG
		port map (O => clock4_out,
					 I => DCM_3_out);

end Behavioral;

