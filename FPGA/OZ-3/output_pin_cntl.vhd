----------------------------------------------------------------------------------
-- Company: 
-- Engineer:       Ben Oztalay
-- 
-- Create Date:    23:51:17 12/20/2009 
-- Design Name: 
-- Module Name:    output_pin_cntl - Behavioral 
-- Project Name:   OZ-3
-- Target Devices: 
-- Tool versions: 
-- Description:    The output pin register and controller for the OZ-3
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Revision 0.20 - File written, will test with rest of processor; not complex enough to warrant the time
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity output_pin_cntl is
    Port ( clock : in  STD_LOGIC;
			  enable : in STD_LOGIC;
           reset : in  STD_LOGIC;
           data : in  STD_LOGIC;
           sel : in  STD_LOGIC_VECTOR(3 downto 0);
           pins : out  STD_LOGIC_VECTOR (15 downto 0));
end output_pin_cntl;

architecture Behavioral of output_pin_cntl is

begin

	opin: process (clock, reset) is
		variable opin_reg : STD_LOGIC_VECTOR(15 downto 0) := x"0000";
	begin
		if falling_edge(clock) then
			if enable = '1' then
				opin_reg(conv_integer(unsigned(sel))) := data;
			end if;
		end if;
		if reset = '1' then
			opin_reg := (others => '0');
		end if;
		pins <= opin_reg;
	end process;

end Behavioral;

