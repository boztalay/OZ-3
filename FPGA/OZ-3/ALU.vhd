----------------------------------------------------------------------------------
-- Company: 
-- Engineer:       Ben Oztalay
-- 
-- Create Date:    11:19:54 10/27/2009 
-- Design Name: 
-- Module Name:    ALU - Behavioral 
-- Project Name:   OZ-3
-- Target Devices: Xilinx XC3S500E-4FG320
-- Tool versions: 
-- Description:    The ALU for the OZ-3
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

entity ALU is
    Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0);
           sel : in  STD_LOGIC_VECTOR (3 downto 0);
           result : out  STD_LOGIC_VECTOR (31 downto 0);
           cond_bits : out  STD_LOGIC_VECTOR (3 downto 0));
end ALU;

architecture Behavioral of ALU is

begin

	main: process(A, B, sel) is
		variable out_reg : STD_LOGIC_VECTOR(32 downto 0);
	begin
		cond_bits <= "0000";
		
		--operations
		case sel is 
			when "0000" => --add
				out_reg := ('0' & A(31 downto 0)) + ('0' & B(31 downto 0));
			when "0001" => --sub
				out_reg := ('0' & A(31 downto 0)) - ('0' & B(31 downto 0));
			when "0010" => --and
				out_reg := '0' & (A and B);
			when "0011" => --or
				out_reg := '0' & (A or B);
			when "0100" => --xor
				out_reg := '0' & (A xor B);
			when "0101" => --cp
				out_reg := ('0' & A);
			when "0110" => --sll
				out_reg := (A(31 downto 0) & '0');
			when "0111" => --srl
				out_reg := ("00" & A(31 downto 1));
			when "1000" => --rol
				out_reg := (A(0) & A(0) & A(31 downto 1));
			when "1001" => --ror
				out_reg := (A(30) & A(30 downto 0) & A(31));
			when others =>
			   out_reg := ('0' & A);
		end case;
		
		--condition bit logic
		if (A > B) then
			cond_bits(1) <= '1';
		elsif (A = B) then
			cond_bits(2) <= '1';
		elsif (A < B) then
			cond_bits(3) <= '1';
		end if;
		cond_bits(0) <= out_reg(32); --carry
		
		result <= out_reg(31 downto 0);
	end process;

end Behavioral;

