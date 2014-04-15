----------------------------------------------------------------------------------
--Ben Oztalay, 2009-2010
--
--Module Title: Gen_Latch_High
--Module Description:
--	This module is a generic data latch. When the enable signal is high, a register
-- changes to the value placed on the input. When the enable signal is low, the
-- value is fixed.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Gen_Latch_High is
	 generic (size : integer);
    Port ( enable : in  STD_LOGIC;
           data : in  STD_LOGIC_VECTOR ((size-1) downto 0);
           output : out  STD_LOGIC_VECTOR ((size-1) downto 0));
end Gen_Latch_High;

architecture Behavioral of Gen_Latch_High is

--//Signals\\--

signal data_reg : STD_LOGIC_VECTOR((size-1) downto 0);

begin

	main: process(enable, data, data_reg)
	begin
		if enable = '1' then
			data_reg <= data;
		end if;
		
		output <= data_reg;
	end process;

end Behavioral;

