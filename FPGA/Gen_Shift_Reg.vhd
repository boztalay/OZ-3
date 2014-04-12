----------------------------------------------------------------------------------
--Ben Oztalay, 2009-2010
--
--Module Title: Gen_Shift_Reg
--Module Description:
--	This module is a generic serial-in, parallel-out shift register that can be
-- resized. Active on the rising edge.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Gen_Shift_Reg is
	 generic (size : natural);
    Port ( clock : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           data_in : in  STD_LOGIC;
           data_out : out  STD_LOGIC_VECTOR ((size-1) downto 0));
end Gen_Shift_Reg;

architecture Behavioral of Gen_Shift_Reg is

begin

	main : process (clock, reset, data_in) is
		variable data : STD_LOGIC_VECTOR((size-1) downto 0) := (others => '0');
	begin
		if rising_edge(clock) then
			if reset = '1' then
				data := (others => '0');
			else
				data := data((size-2) downto 0) & data_in;
			end if;
		end if;
		data_out <= data;
	end process;
	
end Behavioral;

