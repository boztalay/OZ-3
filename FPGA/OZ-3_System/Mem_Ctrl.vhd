----------------------------------------------------------------------------------
--Ben Oztalay, 2009-2010
--
--This VHDL code is part of the OZ-3 Based Computer System designed for the
--Digilent Nexys 2 FPGA Development Board
--
--Module Title: Mem_Ctrl
--Module Description:
--	This module interfaces with the memory resources on the Nexys-2 board. Namely,
-- the Micron RAM and Intel StrataFlash. They share address and data buses,
-- and I wanted to make that transparent to the OZ-3 so I wouldn't have to
-- pull my hair out restructuring the OZ-3 to interface with both memory modules.
-- This works, essentially, by following a clock signal that is twice the
-- frequency of the main clock, and shifted 90 degrees. When that clock signal
-- is high, the Flash has control over the buses, and the RAM when it's low.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Mem_Ctrl is
	Port ( flash_address_from_OZ3 : in STD_LOGIC_VECTOR(22 downto 0);
			 dbl_clk_from_OZ3 : in STD_LOGIC;
			 dRAM_WR_from_OZ3 : in STD_LOGIC;
			 dRAM_address_from_OZ3 : in STD_LOGIC_VECTOR(22 downto 0);			 
			 dRAM_data_from_OZ3 : in STD_LOGIC_VECTOR(15 downto 0);
			 data_bus : inout STD_LOGIC_VECTOR(15 downto 0);
			 dRAM_ce : out STD_LOGIC;
			 dRAM_lb : out STD_LOGIC;
			 dRAM_ub : out STD_LOGIC;
			 dRAM_adv : out STD_LOGIC;
			 dRAM_cre : out STD_LOGIC;
			 dRAM_clk : out STD_LOGIC;
			 flash_ce : out STD_LOGIC;
			 flash_rp : out STD_LOGIC;
			 mem_oe : out STD_LOGIC;
			 mem_we : out STD_LOGIC;
			 address_bus : out STD_LOGIC_VECTOR(22 downto 0);
			 dRAM_data_to_OZ3 : out STD_LOGIC_VECTOR(15 downto 0);
			 instruction_to_OZ3 : out STD_LOGIC_VECTOR(15 downto 0));
end Mem_Ctrl;

architecture Behavioral of Mem_Ctrl is

--//Signals\\--

--The main process of the memory bus controller uses these for interfacing with
--the bidirectional memory data bus, and then the 3-state buffer deals with
--using them and actually dealing with the bus
signal data_bus_in : STD_LOGIC_VECTOR(15 downto 0);
signal data_bus_out : STD_LOGIC_VECTOR(15 downto 0);

--\\Signals//--

begin
	
	--Main process of the memory controller
	
	main : process (dbl_clk_from_OZ3, data_bus, flash_address_from_OZ3, dRAM_address_from_OZ3, dRAM_data_from_OZ3) is
	begin		
	
		  --Default values are set for Flash control of the buses
		  flash_ce <= '0';
		  dRAM_ce <= '1';
		  mem_oe <= '0';
		  mem_we <= '1';
		  
		  --These inputs that go to the OZ-3 never have to change or be disabled,
		  --since other logic takes care of using them at the proper times. Therefore,
		  --placing more logic for that purpose here would be redundant
		  instruction_to_OZ3 <= data_bus_in;
		  dRAM_data_to_OZ3 <= data_bus_in;
		  
		  --If the dRAM needs control, though...
		  if dbl_clk_from_OZ3 = '0' then
				  --Everything needed to be set for a RAM read operation by default
			     flash_ce <= '1';
		    	  dRAM_ce <= '0';
				  
				  --Things need to change a bit for write operations, though. And the
				  --output bus needs to be driven
				  if dRAM_WR_from_OZ3 = '1' then
						 mem_oe <= '1';
				       mem_we <= '0';
						 data_bus_out <= dRAM_data_from_OZ3;
				  end if;
		  end if;
	end process;
	
	--This models a 3-state buffer for using the bidirectional data bus
	buffer3 : process (dRAM_WR_from_OZ3, data_bus, data_bus_out) is
	begin
		--If the OZ-3 needs to drive the bus
		if dRAM_WR_from_OZ3 = '1' then
			data_bus <= data_bus_out;
		--Otherwise, don't drive the bus
		else
			data_bus <= "ZZZZZZZZZZZZZZZZ";
		end if;
		data_bus_in <= data_bus;
	end process;

	--This process multiplexes the Flash and RAM addresses when they
	--need to be switched. I would have normally placed this in the main process,
	--but something weird was happening at higher frequencies that I can
	--only assume has to do with skew due to the other logic in the main
	--process. So I just took it out and now it's able to run parallel, and it works
	address_MUX : process (dbl_clk_from_OZ3) is
	begin
		if dbl_clk_from_OZ3 = '1' then --When the Flash has control
			address_bus <= flash_address_from_OZ3;
		elsif dbl_clk_from_OZ3 = '0' then --When the RAM has control
			address_bus <= dRAM_address_from_OZ3;
		end if;
	end process;
	
	--All of the outputs that remain constant
	dRAM_lb <= '0';
	dRAM_ub <= '0';
	dRAM_adv <= '0';
	dRAM_cre <= '0';
	dRAM_clk <= '0';
	flash_rp <= '1';

end Behavioral;

