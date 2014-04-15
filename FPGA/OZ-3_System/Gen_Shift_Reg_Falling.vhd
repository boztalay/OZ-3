----------------------------------------------------------------------------------
--Ben Oztalay, 2009-2010
--
--Module Title: Gen_Shift_Reg_Falling
--Module Description:
--	This module is a generic serial-in, parallel-out shift register that can be
-- resized. Active on the falling edge.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Gen_Shift_Reg_Falling is
	 generic (size : integer);
    Port ( clock : in  STD_LOGIC;
			  enable : in STD_LOGIC;
           reset : in  STD_LOGIC;
           data_in : in  STD_LOGIC;
           data_out : out  STD_LOGIC_VECTOR ((size-1) downto 0));
end Gen_Shift_Reg_Falling;

architecture Behavioral of Gen_Shift_Reg_Falling is

begin

	main : process (clock, enable, reset, data_in) is
		variable data : STD_LOGIC_VECTOR((size-1) downto 0) := (others => '0');
	begin
		if falling_edge(clock) then
			if enable = '1' then
				if reset = '1' then
					data := (others => '0');
				else
					data := data((size-2) downto 0) & data_in;
				end if;
			end if;
		end if;
		data_out <= data;
	end process;
	
end Behavioral;
