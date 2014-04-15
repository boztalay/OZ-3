----------------------------------------------------------------------------------
--Ben Oztalay, 2009-2010
--
--Module Title: Keyboard
--Module Description:
--	This is a simple module that eases the interface with a keyboard. It takes the
-- PS/2 bus clock and data pins as inputs, as well as an acknowledgment signal. The
-- outputs are the 8-bit scan code and a signal that tells the host device that
-- the scan code is ready. Every 11 clock cycles, when the entire packet has been sent,
-- the code_ready output is driven high, and stays high until the acknowledgement
-- input is raised to '1'. It doesn't take scan codes while the code_ready output
-- is high.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Keyboard is
    Port ( key_clock : in  STD_LOGIC;
           key_data : in  STD_LOGIC;
           acknowledge : in  STD_LOGIC;
           scan_code : out  STD_LOGIC_VECTOR (7 downto 0);
           code_ready : out  STD_LOGIC);
end Keyboard;

architecture Behavioral of Keyboard is

--//Components\\--

component Gen_Shift_Reg_Falling is
	 generic (size : integer);
    Port ( clock : in  STD_LOGIC;
			  enable : in STD_LOGIC;
           reset : in  STD_LOGIC;
           data_in : in  STD_LOGIC;
           data_out : out  STD_LOGIC_VECTOR ((size-1) downto 0));
end component;

--\\Components//--

--//Signals\\--

signal code_ready_sig : STD_LOGIC;
signal enable : STD_LOGIC;
signal reg_out : STD_LOGIC_VECTOR(10 downto 0);

--\\Signals//--

begin

	count_chk : process (key_clock, acknowledge, enable) is
		variable count : integer := 0;
		variable ready : STD_LOGIC := '0';
	begin
		if enable = '1' then
			if falling_edge(key_clock) then
				count := count + 1;
				if count = 11 then
					count := 0;
					ready := '1';
				end if;
			end if;
		end if;
		
		if (ready = '1') and (acknowledge = '1') then
				ready := '0';
		end if;
		
		code_ready_sig <= ready;
	end process;
	
	shift_reg : Gen_Shift_Reg_Falling generic map (size => 11)
												 port map (clock => key_clock,
															  enable => enable,
															  reset => '0',
															  data_in => key_data,
															  data_out => reg_out);
															  	
	enable <= (not (key_clock and code_ready_sig));
	code_ready <= code_ready_sig;
	scan_code <= reg_out(2) & reg_out(3) & reg_out(4) & reg_out(5) & reg_out(6) & reg_out(7) & reg_out(8) & reg_out(9);

end Behavioral;

