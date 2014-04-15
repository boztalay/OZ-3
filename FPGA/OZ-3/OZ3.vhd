----------------------------------------------------------------------------------
-- Company: 
-- Engineer:       Ben Oztalay
-- 
-- Create Date:    11:54:14 10/26/2009 
-- Design Name: 
-- Module Name:    OZ3 - Behavioral 
-- Project Name:   OZ-3
-- Target Devices: Xilinx XC3S500E-4FG320
-- Tool versions: 
-- Description:    A 32-bit, 5-stage RISC for implementation in an FPGA
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Revision 0.20 - Rought draft written, still buggy, nomenclature needs fixing across the board
-- Revision 0.30 - Corrected syntax errors, nomenclature left to be finished
-- Revision 0.40 - Nomenclature cleared up in main file, need to fix port names in the stages' files
-- Revision 0.41 - Nomenclature cleared up throughout the stages' files, first draft complete
--					    Ready for testing
-- Revision 0.50 - Testing started, test of icnrementing PC successful
-- Revision 0.58 - Testing of individual instructions complete, except for that weird error trying to load into the upper half
--						 of a register. I expect that it is a simulation error that won't exist in hardware.
-- Revision 0.59 - Fixed bug, there were two drivers of a signal in the ID. Would have caused errors in hardware.
-- Revision 0.60 - Advanced testing started: placing OZ-3 in a system with an instruction ROM to test basic
--						 program structures and flow.
-- Revision 0.65 - Advanced testing complete, everything checked out after minor changes
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

entity OZ3 is
	Port ( clock : in STD_LOGIC;
		    reset : in STD_LOGIC;
			 input_pins : in STD_LOGIC_VECTOR(15 downto 0);
			 input_port : in STD_LOGIC_VECTOR(31 downto 0);
			 instruction_in : in STD_LOGIC_VECTOR(15 downto 0);
			 dRAM_data_in : in STD_LOGIC_VECTOR(15 downto 0);
			 output_pins : out STD_LOGIC_VECTOR(15 downto 0);
			 output_port : out STD_LOGIC_VECTOR(31 downto 0);
			 instruction_addr_out : out STD_LOGIC_VECTOR(22 downto 0);
			 dRAM_data_out : out STD_LOGIC_VECTOR(15 downto 0);
			 dRAM_addr_out : out STD_LOGIC_VECTOR(22 downto 0);
			 dRAM_WR_out : out STD_LOGIC;
			 mem_ctrl_clk_out : out STD_LOGIC);
end OZ3;

architecture Behavioral of OZ3 is

--//Components\\--

--Five main stages--
component IFetch is
	Port ( clock : in STD_LOGIC;
		    reset : in STD_LOGIC;
			 condition_flag_from_EX : in STD_LOGIC;
			 PC_new_addr_from_EX : in STD_LOGIC_VECTOR(31 downto 0);
			 iROM_data : in STD_LOGIC_VECTOR(15 downto 0);
			 iROM_addr : out STD_LOGIC_VECTOR(22 downto 0);
			 dbl_clk : out STD_LOGIC;
			 instruction_to_ID : out STD_LOGIC_VECTOR(31 downto 0));
end component;

component ID is
	Port ( --Inputs--
	
			 --Main inputs
			 clock : in STD_LOGIC;
			 reset : in STD_LOGIC;
			 instruction_from_IF : in STD_LOGIC_VECTOR(31 downto 0);
			 --Register file inputs
			 rfile_read_addr3_from_MEMIO : in STD_LOGIC_VECTOR(4 downto 0); --AKA RAM reg addr
			 rfile_write_addr_from_WB : in STD_LOGIC_VECTOR(4 downto 0);
			 rfile_write_data_from_WB : in STD_LOGIC_VECTOR(31 downto 0);
			 rfile_write_e_from_WB    : in STD_LOGIC;
			 --Forwarding logic inptus
			 forward_addr_EX    : in STD_LOGIC_VECTOR(4 downto 0);
			 forward_data_EX    : in STD_LOGIC_VECTOR(31 downto 0);
			 forward_addr_MEMIO : in STD_LOGIC_VECTOR(4 downto 0);
			 forward_data_MEMIO : in STD_LOGIC_VECTOR(31 downto 0);
			 forward_addr_WB    : in STD_LOGIC_VECTOR(4 downto 0);
			 forward_data_WB    : in STD_LOGIC_VECTOR(31 downto 0); 
				
			 --Outputs--
			 
			 --EX Control
			 ALU_A_to_EX : out STD_LOGIC_VECTOR(31 downto 0);
			 ALU_B_to_EX : out STD_LOGIC_VECTOR(31 downto 0);
			 EX_control : out STD_LOGIC_VECTOR(11 downto 0);
			 --MEMIO Control
			 RAM_reg_data_to_MEMIO : out STD_LOGIC_VECTOR(31 downto 0);
			 MEMIO_control : out STD_LOGIC_VECTOR(20 downto 0);
			 --WB Control
			 WB_control : out STD_LOGIC_VECTOR(5 downto 0));	 
end component;

component EX is
	Port ( clock : in STD_LOGIC;
		    reset : in STD_LOGIC;
			 ALUA_from_ID  : in STD_LOGIC_VECTOR(31 downto 0);
			 ALUB_from_ID  : in STD_LOGIC_VECTOR(31 downto 0);
			 cntl_from_ID : in STD_LOGIC_VECTOR(11 downto 0);
			 p_flag_from_MEM : in STD_LOGIC;
			 ALUR_to_MEM : out STD_LOGIC_VECTOR(31 downto 0);
			 dest_reg_addr_to_ID : out STD_LOGIC_VECTOR(4 downto 0);
			 cond_bit_to_IF : out STD_LOGIC);
end component;

component MEMIO is
	Port ( clock : in STD_LOGIC;
			 reset : in STD_LOGIC;
			 cntl_from_ID : in STD_LOGIC_VECTOR(20 downto 0);
			 ALU_result_from_EX_in : in STD_LOGIC_VECTOR(31 downto 0);
			 RAM_reg_data_from_ID : in STD_LOGIC_VECTOR(31 downto 0);
			 ipin_reg_data : in STD_LOGIC_VECTOR(15 downto 0);
			 iprt_data : in STD_LOGIC_VECTOR(31 downto 0);
			 dRAM_data_in: in STD_LOGIC_VECTOR(15 downto 0);
			 dRAM_data_out : out STD_LOGIC_VECTOR(15 downto 0);
			 dRAM_WR : out STD_LOGIC;
			 dRAM_addr : out STD_LOGIC_VECTOR(22 downto 0);
			 forward_addr_to_ID : out STD_LOGIC_VECTOR(4 downto 0);
			 pflag_to_EX : out STD_LOGIC;
			 opin_clk_e : out STD_LOGIC;
			 opin_select : out STD_LOGIC_VECTOR(3 downto 0);
			 opin_1_0 : out STD_LOGIC;
			 oprt_data : out STD_LOGIC_VECTOR(31 downto 0);
			 oprt_reg_clk_e : out STD_LOGIC;
			 RAM_reg_addr_to_ID : out STD_LOGIC_VECTOR(4 downto 0);
			 data_to_WB : out STD_LOGIC_VECTOR(31 downto 0));
end component;

component WB is
	Port ( clock : in STD_LOGIC;
	       reset : in STD_LOGIC;
			 data_from_MEM : in STD_LOGIC_VECTOR(31 downto 0);
			 cntl_from_ID  : in STD_LOGIC_VECTOR(5 downto 0);
			 rfile_write_data_to_ID : out STD_LOGIC_VECTOR(31 downto 0);
			 rfile_write_addr_to_ID : out STD_LOGIC_VECTOR(4 downto 0);
			 rfile_write_e_to_ID   : out STD_LOGIC);
end component;

--Output Pin Register and Controller--
component output_pin_cntl is
    Port ( clock : in  STD_LOGIC;
			  enable : in STD_LOGIC;
           reset : in  STD_LOGIC;
           data : in  STD_LOGIC;
           sel : in  STD_LOGIC_VECTOR(3 downto 0);
           pins : out  STD_LOGIC_VECTOR (15 downto 0));
end component;

--Generic Registers--
component GenReg is
	 generic (size : integer);
		 Port ( clock : in  STD_LOGIC;
				  enable : in STD_LOGIC;
				  reset : in  STD_LOGIC;
				  data : in  STD_LOGIC_VECTOR ((size - 1) downto 0);
				  output : out  STD_LOGIC_VECTOR ((size - 1) downto 0));
end component;

component GenRegFalling is
	 generic (size: integer);
		 Port ( clock : in  STD_LOGIC;
				  enable : in STD_LOGIC;
				  reset : in  STD_LOGIC;
				  data : in  STD_LOGIC_VECTOR ((size - 1) downto 0);
				  output : out  STD_LOGIC_VECTOR ((size - 1) downto 0));
end component;

--\\Components//--

--//Signals\\--

--Main Bus Signals--
signal IF_bus_to_ID : STD_LOGIC_VECTOR(31 downto 0);
signal ID_ALU_A_to_EX : STD_LOGIC_VECTOR(31 downto 0);
signal ID_ALU_B_to_EX : STD_LOGIC_VECTOR(31 downto 0);
signal EX_bus_to_MEMIO : STD_LOGIC_VECTOR(31 downto 0);
signal MEMIO_bus_to_WB : STD_LOGIC_VECTOR(31 downto 0);


--Control Signals--
signal EX_control : STD_LOGIC_VECTOR(11 downto 0);
signal MEMIO_control : STD_LOGIC_VECTOR(20 downto 0);
signal WB_control : STD_LOGIC_VECTOR(5 downto 0);

--Other Signals
signal EX_cond_to_IF : STD_LOGIC;

signal WB_rfile_write_addr_to_ID : STD_LOGIC_VECTOR(4 downto 0);
signal WB_rfile_write_data_to_ID : STD_LOGIC_VECTOR(31 downto 0);
signal WB_rfile_write_e_to_ID : STD_LOGIC;

signal MEMIO_rfile_read_addr3_to_ID : STD_LOGIC_VECTOR(4 downto 0);
signal ID_rfile_read_data3_to_MEMIO : STD_LOGIC_VECTOR(31 downto 0);

signal EX_forward_addr_to_ID : STD_LOGIC_VECTOR(4 downto 0);
signal MEMIO_forward_addr_to_ID : STD_LOGIC_VECTOR(4 downto 0);

signal MEMIO_pflag_to_EX : STD_LOGIC;

signal ipin_reg_out : STD_LOGIC_VECTOR(15 downto 0);
signal iprt_reg_out : STD_LOGIC_VECTOR(31 downto 0);
signal opin_clk_e : STD_LOGIC;
signal opin_1_0 : STD_LOGIC;
signal opin_select : STD_LOGIC_VECTOR(3 downto 0);
signal oprt_data : STD_LOGIC_VECTOR(31 downto 0);
signal oprt_reg_clk_e : STD_LOGIC;

--\\Signals//--

begin

	--Instantiate the Stages--
	IF_stage: IFetch port map (clock, 
										reset, 
										EX_cond_to_IF, 
										EX_bus_to_MEMIO, 
										instruction_in, 
										instruction_addr_out,
										mem_ctrl_clk_out, 
										IF_bus_to_ID);
	ID_stage: ID port map (clock, 
								  reset, 
								  IF_bus_to_ID, 
								  MEMIO_rfile_read_addr3_to_ID, 
								  WB_rfile_write_addr_to_ID,
								  WB_rfile_write_data_to_ID, 
								  WB_rfile_write_e_to_ID, 
								  EX_forward_addr_to_ID, 
								  EX_bus_to_MEMIO,
								  MEMIO_forward_addr_to_ID, 
								  MEMIO_bus_to_WB, 
								  WB_rfile_write_addr_to_ID, 
								  WB_rfile_write_data_to_ID,
								  ID_ALU_A_to_EX, 
								  ID_ALU_B_to_EX, 
								  EX_control,
								  ID_rfile_read_data3_to_MEMIO, --change to ID_RAM_reg_data_to_MEMIO
								  MEMIO_control, 
								  WB_control);
	EX_stage: EX port map (clock, 
								  reset, 
								  ID_ALU_A_to_EX, 
								  ID_ALU_B_to_EX, 
								  EX_control, 
								  MEMIO_pflag_to_EX, 
								  EX_bus_to_MEMIO,
								  EX_forward_addr_to_ID, 
								  EX_cond_to_IF);
	MEMIO_stage: MEMIO port map (clock, 
										  reset, 
										  MEMIO_control, 
										  EX_bus_to_MEMIO, 
										  ID_rfile_read_data3_to_MEMIO, 
										  ipin_reg_out,
										  iprt_reg_out, 
										  dRAM_data_in, 
										  dRAM_data_out, 
										  dRAM_WR_out, 
										  dRAM_addr_out, 
										  MEMIO_forward_addr_to_ID,
										  MEMIO_pflag_to_EX, 
										  opin_clk_e, 
										  opin_select, 
										  opin_1_0, 
										  oprt_data, 
										  oprt_reg_clk_e,
										  MEMIO_rfile_read_addr3_to_ID, 
										  MEMIO_bus_to_WB);
	WB_stage: WB port map (clock, 
								  reset, 
								  MEMIO_bus_to_WB, 
								  WB_control, 
								  WB_rfile_write_data_to_ID, 
								  WB_rfile_write_addr_to_ID,
								  WB_rfile_write_e_to_ID);
	
	--Instantiate the Output Pin Controller--
	Opin : output_pin_cntl port map (clock, opin_clk_e, reset, opin_1_0, opin_select, output_pins);
	
	--Instantiate Input/Output Registers--
	Ipin : GenReg generic map (16)
					  port map (clock, '1', reset, input_pins, ipin_reg_out);
	Iport : GenReg generic map (32)
					   port map (clock, '1', reset, input_port, iprt_reg_out);
	Oport : GenRegFalling generic map (32)
								port map (clock, oprt_reg_clk_e, reset, oprt_data, output_port);
end Behavioral;

