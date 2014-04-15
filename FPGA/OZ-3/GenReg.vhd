----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:58:50 10/27/2009 
-- Design Name: 
-- Module Name:    GenReg - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Revision 0.90 - File written and syntax checked. No simulation necessary
-- Additional Comments: 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity GenReg is
	 generic (size : integer);
		 Port ( clock : in  STD_LOGIC;
				  enable : in STD_LOGIC;
				  reset : in  STD_LOGIC;
				  data : in  STD_LOGIC_VECTOR ((size - 1) downto 0);
				  output : out  STD_LOGIC_VECTOR ((size - 1) downto 0));
end GenReg;

architecture Behavioral of GenReg is

begin

	main: process (clock, reset) is
		variable data_reg : STD_LOGIC_VECTOR((size - 1) downto 0);
	begin
		if rising_edge(clock) then
			if reset = '1' then
				data_reg := (others => '0');
			elsif enable = '1' then
				data_reg := data;
			end if;
		end if;
		output <= data_reg;
	end process;
	
end Behavioral;

