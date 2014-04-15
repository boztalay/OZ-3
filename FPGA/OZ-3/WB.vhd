----------------------------------------------------------------------------------
-- Company: 
-- Engineer:       Ben Oztalay
-- 
-- Create Date:    11:57:25 10/26/2009 
-- Design Name: 
-- Module Name:    WB - Behavioral 
-- Project Name:   OZ-3
-- Target Devices: Xilinx XC3S500E-4FG320
-- Tool versions: 
-- Description:    The WB (writeback) stage of the OZ-3 pipeline.
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Revision 0.30 - File written and syntax checked
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

entity WB is
	Port ( clock : in STD_LOGIC;
	       reset : in STD_LOGIC;
			 data_from_MEM : in STD_LOGIC_VECTOR(31 downto 0);
			 cntl_from_ID  : in STD_LOGIC_VECTOR(5 downto 0);
			 rfile_write_data_to_ID : out STD_LOGIC_VECTOR(31 downto 0); --These two outputs also used for
			 rfile_write_addr_to_ID : out STD_LOGIC_VECTOR(4 downto 0);  --forwarding logic
			 rfile_write_e_to_ID   : out STD_LOGIC);
end WB;

architecture Behavioral of WB is

--//Component Declarations\\--

component GenReg is
	 generic (size: integer);
		 Port ( clock : in  STD_LOGIC;
				  enable : in STD_LOGIC;
				  reset : in  STD_LOGIC;
				  data : in  STD_LOGIC_VECTOR ((size - 1) downto 0);
				  output : out  STD_LOGIC_VECTOR ((size - 1) downto 0));
end component;

--\\Component Declarations//--

--//Signal Declarations\\--

signal buffer_1_2 : STD_LOGIC_VECTOR(5 downto 0);
signal buffer_2_3 : STD_LOGIC_VECTOR(5 downto 0);
signal buffer_out : STD_LOGIC_VECTOR(5 downto 0);

--\\Signal Declarations//--

begin

	in_reg: GenReg generic map (size => 32)
					   port map (clock, '1', reset, data_from_MEM, rfile_write_data_to_ID);
	buf1 : GenReg generic map (size => 6)
					  port map (clock, '1', reset, cntl_from_ID, buffer_1_2);
	buf2 : GenReg generic map (size => 6)
					  port map (clock, '1', reset, buffer_1_2, buffer_2_3);
	buf3 : GenReg generic map (size => 6)
					  port map (clock, '1', reset, buffer_2_3, buffer_out);
					  
	rfile_write_addr_to_ID <= buffer_out(5 downto 1);
	rfile_write_e_to_ID  <= buffer_out(0);

end Behavioral;

