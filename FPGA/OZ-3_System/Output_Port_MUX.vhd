----------------------------------------------------------------------------------
--Ben Oztalay, 2009-2010
--
--This VHDL code is part of the OZ-3 Based Computer System designed for the
--Digilent Nexys 2 FPGA Development Board
--
--Module Title: Output_Port_MUX
--Module Description:
-- This module holds four 32-bit latches,
-- one for each extended output port, and the multiplexer that handles
-- sending data to the correct latch. This is tied to output pins 15
-- and 14, which select which one of the four latches get the output of the OZ-3.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Output_Port_MUX is
    Port ( clock : in STD_LOGIC;
			  reset : in STD_LOGIC;
			  enable : in STD_LOGIC;
			  data : in  STD_LOGIC_VECTOR (31 downto 0);
           sel : in  STD_LOGIC_VECTOR (1 downto 0);
           output0 : out  STD_LOGIC_VECTOR (31 downto 0);
           output1 : out  STD_LOGIC_VECTOR (31 downto 0);
           output2 : out  STD_LOGIC_VECTOR (31 downto 0);
           output3 : out  STD_LOGIC_VECTOR (31 downto 0));
end Output_Port_MUX;

architecture Behavioral of Output_Port_MUX is

--//Signals\\--

signal reg0 : STD_LOGIC_VECTOR(31 downto 0);
signal reg1 : STD_LOGIC_VECTOR(31 downto 0);
signal reg2 : STD_LOGIC_VECTOR(31 downto 0);
signal reg3 : STD_LOGIC_VECTOR(31 downto 0);

signal enable0 : STD_LOGIC;
signal enable1 : STD_LOGIC;
signal enable2 : STD_LOGIC;
signal enable3 : STD_LOGIC;

--\\Signals//--

--//Components\\--

component GenRegFalling is
	 generic (size : integer);
		 Port ( clock : in  STD_LOGIC;
				  enable : in STD_LOGIC;
				  reset : in  STD_LOGIC;
				  data : in  STD_LOGIC_VECTOR ((size - 1) downto 0);
				  output : out  STD_LOGIC_VECTOR ((size - 1) downto 0));
end component;

--\\Components//--

begin

	main : process (sel, data)
	begin
		reg0 <= (others => '0');
		reg1 <= (others => '0');
		reg2 <= (others => '0');
		reg3 <= (others => '0');
	
		case sel is
			when "00" =>
				reg0 <= data;
			when "01" =>
				reg1 <= data;
			when "10" =>
				reg2 <= data;
			when "11" =>
				reg3 <= data;
			when others =>
				reg0 <= (others => '0');
		end case;
	end process;
	
	reg_0 : GenRegFalling generic map (size => 32)
									 port map (clock => clock,
												  enable => enable0,
												  reset => reset,
												  data => reg0,
												  output => output0);

	reg_1 : GenRegFalling generic map (size => 32)
									 port map (clock => clock,
												  enable => enable1,
												  reset => reset,
												  data => reg1,
												  output => output1);
												 
	reg_2 : GenRegFalling generic map (size => 32)
									 port map (clock => clock,
												  enable => enable2,
												  reset => reset,
												  data => reg2,
												  output => output2);
												  
	reg_3 : GenRegFalling generic map (size => 32)
									 port map (clock => clock,
												  enable => enable3,
												  reset => reset,
												  data => reg3,
												  output => output3);
												  
	enable0 <= ((not sel(0)) and (not sel(1))) and enable;
	enable1 <= (sel(0) and (not sel(1))) and enable;
	enable2 <= ((not sel(0)) and sel(1)) and enable;
	enable3 <= (sel(0) and sel(1)) and enable;
end Behavioral;

