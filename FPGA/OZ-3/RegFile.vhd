----------------------------------------------------------------------------------
-- Company: 
-- Engineer:       Ben Oztalay
-- 
-- Create Date:    22:04:52 10/29/2009 
-- Design Name: 
-- Module Name:    RegFile - Behavioral 
-- Project Name:   OZ-3
-- Target Devices: Xilinx XC3S500E-4FG320
-- Tool versions: 
-- Description:    The register file for the OZ-3. Writes on falling edge,
--                 synchronous reset.
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Revision 0.30 - File written and syntax checked
-- Revision 0.90 - Successfully simulated
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

entity RegFile is
	Port ( clock : in STD_LOGIC;
			 reset : in STD_LOGIC;
			 write_e : in STD_LOGIC;
			 data_in : in STD_LOGIC_VECTOR(31 downto 0);
			 r_addr1 : in STD_LOGIC_VECTOR(4 downto 0);
			 r_addr2 : in STD_LOGIC_VECTOR(4 downto 0);
			 r_addr3 : in STD_LOGIC_VECTOR(4 downto 0);
			 w_addr1 : in STD_LOGIC_VECTOR(4 downto 0);
			 data_out_1 : out STD_LOGIC_VECTOR(31 downto 0);
			 data_out_2 : out STD_LOGIC_VECTOR(31 downto 0);
			 data_out_3 : out STD_LOGIC_VECTOR(31 downto 0));
end RegFile;

architecture Behavioral of RegFile is

begin
	
	main: process (clock, reset, r_addr1, r_addr2, r_addr3) is
		type reg_array is array (31 downto 0) of
			STD_LOGIC_VECTOR(31 downto 0);
		variable reg_file: reg_array := (others => x"00000000");
	begin
		if falling_edge(clock) then
			if reset = '1' then
				reg_file := (others => x"00000000");
			elsif write_e = '1' then
				if w_addr1 /= b"00000" then
					reg_file(conv_integer(unsigned(w_addr1))) := data_in;
				end if;
			end if;
		end if;
		
		data_out_1 <= reg_file(conv_integer(unsigned(r_addr1)));
		data_out_2 <= reg_file(conv_integer(unsigned(r_addr2)));
		data_out_3 <= reg_file(conv_integer(unsigned(r_addr3)));
	end process;

end Behavioral;

