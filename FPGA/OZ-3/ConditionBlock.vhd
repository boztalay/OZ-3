----------------------------------------------------------------------------------
-- Company: 
-- Engineer:       Ben Oztalay
-- 
-- Create Date:    09:13:21 10/30/2009 
-- Design Name: 
-- Module Name:    ConditionBlock - Behavioral 
-- Project Name:   OZ-3
-- Target Devices: Xilinx XC3S500E-4FG320
-- Tool versions: 
-- Description:    The condition block of the OZ-3; handles the condition flags
--
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

entity ConditionBlock is
	Port ( clock : in STD_LOGIC;
			 reset : in STD_LOGIC;
			 sel   : in STD_LOGIC_VECTOR(2 downto 0);
			 flags : in STD_LOGIC_VECTOR(4 downto 0);
			 cond_out : out STD_LOGIC);
end ConditionBlock;

architecture Behavioral of ConditionBlock is

component GenReg is
	 generic (size: integer);
		 Port ( clock : in  STD_LOGIC;
				  enable : in STD_LOGIC;
				  reset : in  STD_LOGIC;
				  data : in  STD_LOGIC_VECTOR ((size - 1) downto 0);
				  output : out  STD_LOGIC_VECTOR ((size - 1) downto 0));
end component;

signal flags_reg_out : STD_LOGIC_VECTOR(3 downto 0);

begin

	main: process (sel, flags_reg_out, flags(4)) is
	begin
		case (sel) is
			when b"001" =>
				cond_out <= flags_reg_out(0);
			when b"010" =>
				cond_out <= flags_reg_out(1);
			when b"011" =>
				cond_out <= flags_reg_out(2);
			when b"100" =>
				cond_out <= flags_reg_out(3);
			when b"101" =>
				cond_out <= flags(4);
			when b"110" =>
				cond_out <= '1';
			when others =>
				cond_out <= '0';
		end case;
	end process;

	flags_reg: GenReg generic map (size => 4)
	                  port map (clock, '1', reset, flags(3 downto 0), flags_reg_out);

end Behavioral;

