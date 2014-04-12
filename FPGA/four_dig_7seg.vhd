----------------------------------------------------------------------------------
--Ben Oztalay, 2009-2010
--
--
--Module Title: 4dig_7seg
--Module Description:
--	This is a 4-digit, 7-segment display decoder. It outputs in 16-bit values
-- on the Digilent Nexys 2 board's 4-digit display in hexadecimal. Simply
-- give it a 50 MHz clock and data and it'll start working.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity four_dig_7seg is
    Port ( clock : in  STD_LOGIC;
           display_data : in  STD_LOGIC_VECTOR (15 downto 0);
           anodes : out  STD_LOGIC_VECTOR (3 downto 0);
           to_display : out  STD_LOGIC_VECTOR (6 downto 0));
end four_dig_7seg;

architecture Behavioral of four_dig_7seg is

--//Signals\\--

signal to_decoder : STD_LOGIC_VECTOR(3 downto 0);

--\\Signals//--

begin

	--This process takes the data to display and
	--multiplexes 4-bit chunks of it according
	--to the input clock. The 4-bit chunks are
	--sent to the decoder and the anode lines
	--are switched to activate one digit at a time
	disp_data: process(display_data, clock) is
		variable clk_count : integer := 0; --A variable to count the clock ticks
		variable disp_count : integer := 0; --A variable to hold on to which digit
	begin												--is currently being displayed
		if rising_edge(clock) then
			clk_count := clk_count + 1;
			if clk_count = 100000 then --Refresh rate with 100000 is about 125 Hz for the entire display
				disp_count := disp_count + 1;
				clk_count := 0;
				if disp_count = 4 then
					disp_count := 0;
				end if;
			end if;
		end if;
		
		if disp_count = 0 then --First digit
			anodes <= "1110";
			to_decoder <= display_data(3 downto 0);
		elsif disp_count = 1 then --Second digit
			anodes <= "1101";
			to_decoder <= display_data(7 downto 4);
		elsif disp_count = 2 then --Third digit
			anodes <= "1011";
			to_decoder <= display_data(11 downto 8);
		elsif disp_count = 3 then --Fourth digit
			anodes <= "0111";
			to_decoder <= display_data(15 downto 12);
		end if;
	end process;
	
	--This represents a ROM that will act as the
	--individual 7-segment decoder for each digit
	--of the display
	with to_decoder select
	to_display <= "0000001" when "0000",
					  "1001111" when "0001",
					  "0010010" when "0010",
					  "0000110" when "0011",
					  "1001100" when "0100",
					  "0100100" when "0101",
					  "0100000" when "0110",
					  "0001111" when "0111",
					  "0000000" when "1000",
					  "0000100" when "1001",
					  "0001000" when "1010",
					  "1100000" when "1011",
					  "0110001" when "1100",
					  "1000010" when "1101",
					  "0110000" when "1110",
					  "0111000" when "1111",
					  "0000001" when others;

end Behavioral;

