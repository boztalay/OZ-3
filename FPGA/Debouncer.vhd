----------------------------------------------------------------------------------
--Ben Oztalay, 2009-2010
--
--Module Title: Debouncer
--Module Description:
--	This is a simple debouncer for the pushbuttons on the Nexys 2 FPGA board. It
--	can easily be applied in a broader sense, as well. It utilizes three flip
-- flops, linked in series. The output of each flip flop is ANDed together to
-- create the output. The 50 MHz clock input is, rather crudely, reduced to a
-- 190 Hz clock that clocks the flip flops.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Debouncer is
    Port ( clock : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           input : in  STD_LOGIC;
           output : out  STD_LOGIC);
end Debouncer;

architecture Behavioral of Debouncer is

--//Signals\\--

signal clk_190Hz : STD_LOGIC;

--\\Signals//--

begin

	clock_reduce : process (clock, reset) is
		variable count : integer := 0;
	begin
		if rising_edge(clock) then
			count := count + 1;
			
			if reset = '1' then
				count := 0;
			elsif count = 131500 then
				clk_190Hz <= '1';
			elsif count = 263000 then
				clk_190Hz <= '0';
				count := 0;
			end if;
		end if;
	end process;
	
	main : process (clk_190Hz, input, reset) is
		variable delay1, delay2, delay3 : STD_LOGIC;
	begin
		if reset = '1' then
			delay1 := '0';
			delay2 := '0';
			delay3 := '0';
		elsif rising_edge(clk_190Hz) then
			delay1 := input;
			delay2 := delay1;
			delay3 := delay2;
		end if;
		
		output <= delay1 and delay2 and delay3;
	end process;

end Behavioral;

