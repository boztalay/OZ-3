----------------------------------------------------------------------------------
--Ben Oztalay, 2009-2010
--
--This VHDL code is part of the OZ-3 Based Computer System designed for the
--Digilent Nexys 2 FPGA Development Board
--
--Module Title: Input_Port_MUX
--Module Description:
-- This module is a simple 4x32 multiplexer to extend the input ports of the
-- OZ-3.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Input_Port_MUX is
    Port ( input0 : in  STD_LOGIC_VECTOR (31 downto 0);
           input1 : in  STD_LOGIC_VECTOR (31 downto 0);
           input2 : in  STD_LOGIC_VECTOR (31 downto 0);
           input3 : in  STD_LOGIC_VECTOR (31 downto 0);
           sel : in  STD_LOGIC_VECTOR (1 downto 0);
           output : out  STD_LOGIC_VECTOR (31 downto 0));
end Input_Port_MUX;

architecture Behavioral of Input_Port_MUX is

begin

	main: process(input0, input1, input2, input3, sel)
	begin
		if sel = b"00" then
			output <= input0;
		elsif sel = b"01" then
			output <= input1;
		elsif sel = b"10" then
			output <= input2;
		elsif sel = b"11" then
			output <= input3;
		end if;
	end process;

end Behavioral;

