----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:15:45 10/30/2009 
-- Design Name: 
-- Module Name:    MemControlTest - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MemControlTest is
    Port ( clock : in  STD_LOGIC;
           address_out : out  STD_LOGIC_VECTOR (23 downto 0);
           data_bus : inout  STD_LOGIC_VECTOR (15 downto 0);
			  output_e : out STD_LOGIC;
			  write_e : out STD_LOGIC;
			  check_out : out STD_LOGIC);
end MemControlTest;

architecture Behavioral of MemControlTest is

begin

	main: process (clock) is
		variable gone : bit := '0';
	begin
		if rising_edge(clock) then
			if gone = '0' then
				gone := '1';
				address_out <= x"000001";
				data_bus <= x"101F";
				write_e <= '1';
			else
				write_e <= '0';
				output_e <= '0';
				data_bus <= x"0000";
			end if;
		end if;
		
		if data_bus = x"101F" then
			check_out <= '1';
		end if;
	end process;

end Behavioral;

