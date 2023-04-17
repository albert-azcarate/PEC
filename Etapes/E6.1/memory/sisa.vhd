LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

use work.all;

ENTITY sisa IS
 PORT (CLOCK_50 : IN STD_LOGIC;
		 SRAM_ADDR : out std_logic_vector(19 downto 0);
		 SRAM_DQ : inout std_logic_vector(15 downto 0);
		 SRAM_UB_N : out std_logic;
		 SRAM_LB_N : out std_logic;
		 SRAM_CE_N : out std_logic := '1';
		 SRAM_OE_N : out std_logic := '1';
		 SRAM_WE_N : out std_logic := '1';
		 LEDG : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 LEDR : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		 HEX1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		 HEX2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		 HEX3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		 SW : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		 KEY : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 PS2_CLK: inout std_logic;
		 PS2_DAT : inout std_logic
		 );
END sisa;

ARCHITECTURE Structure OF sisa IS

	component MemoryController is
    port (CLOCK_50  : in  std_logic;
	      addr      : in  std_logic_vector(15 downto 0);
          wr_data   : in  std_logic_vector(15 downto 0);
          rd_data   : out std_logic_vector(15 downto 0);
          we        : in  std_logic;
          byte_m    : in  std_logic;
          -- senyales para la placa de desarrollo
          SRAM_ADDR : out   std_logic_vector(17 downto 0);
          SRAM_DQ   : inout std_logic_vector(15 downto 0);
          SRAM_UB_N : out   std_logic;
          SRAM_LB_N : out   std_logic;
          SRAM_CE_N : out   std_logic := '1';
          SRAM_OE_N : out   std_logic := '1';
          SRAM_WE_N : out   std_logic := '1');
	end component;
	
	component proc IS
    PORT (clk       : IN  STD_LOGIC;
          boot      : IN  STD_LOGIC;
          datard_m  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          addr_m    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          data_wr   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          wr_m      : OUT STD_LOGIC;
          word_byte : OUT STD_LOGIC;
			addr_io 		: out std_logic_vector(7 downto 0);
			wr_io 		: out std_logic_vector(15 downto 0);
			rd_io 		: in std_logic_vector(15 downto 0);
			wr_out 		: out std_logic;
			rd_in 		: out std_logic
			 );
	END component;

	component controladores_IO is
		PORT (
			boot 			: IN STD_LOGIC;
			CLOCK_50 	: IN std_logic;
			addr_io 		: IN std_logic_vector(7 downto 0);
			wr_io 		: in std_logic_vector(15 downto 0); --entrada que hem d'escriure al nostre banc
			rd_io 		: out std_logic_vector(15 downto 0); --sortida de lo que llegim dels nostres bancs
			wr_out 		: in std_logic; --hem d'escriure al nostre banc
			rd_in 		: in std_logic; --la ALU ens llegeix
			led_verdes 	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			led_rojos 	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			SW : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
			HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			HEX1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			HEX2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			HEX3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			KEY : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			ps2_clk : inout std_logic;
			ps2_data : inout std_logic
			);
	END component;




	signal addr_proc_to_mem: STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal word_byte_to_mem: std_LOGIC;
	signal wr_m_to_mem: std_LOGIC;
	signal data_wr_to_mem: STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal rd_data_to_proc: STD_LOGIC_VECTOR(15 DOWNTO 0);
	
	signal clk : std_logic_vector(2 downto 0) := "000";
	
	signal addr_io_to_io : std_LOGIC_VECTOR(7 downto 0);
	signal wr_io_to_io : std_LOGIC_VECTOR(15 downto 0);
	signal rd_io_to_io : std_LOGIC_VECTOR(15 downto 0);
	signal wr_out_to_io : std_LOGIC;
	signal rd_in_to_io : std_LOGIC;
BEGIN

	process (CLOCK_50) BEGIN
		if rising_edge(CLOCK_50) then
			clk <= clk + 1;
		end if;
	END PROcess;
	
	MUC: memoryController port map(cloCK_50 => CLOCK_50,
		addr => addr_proc_to_mem,
		wr_data => data_wr_to_mem,
		rd_data => rd_data_to_proc,
		we => wr_m_to_mem,
		byte_m => word_byte_to_mem,
		SRAM_ADDR => SRAM_ADDR(17 downto 0),
		SRAM_CE_N => SRAM_CE_N,
		SRAM_DQ => SRAM_DQ,
		SRAM_LB_N => SRAM_LB_N,
		SRAM_OE_N => SRAM_OE_N,
		SRAM_UB_N => SRAM_UB_N,
		SRAM_WE_N => SRAM_WE_N);
	
	processor: proc port map(clk => clk(2),
		boot => sw(9),
		datard_m => rd_data_to_proc,
		addr_m => addr_proc_to_mem,
		data_wr => data_wr_to_mem,
		wr_m => wr_m_to_mem,
		word_byte => word_byte_to_mem,
		addr_io => addr_io_to_io,
		wr_io => wr_io_to_io,
		rd_io => rd_io_to_io,
		wr_out => wr_out_to_io,
		rd_in => rd_in_to_io
		);
		
	CIO : controladores_IO port map (
		boot => SW(9), --
		CloCK_50 =>CLOCK_50,
		addr_io => addr_io_to_io,
		wr_io => wr_io_to_io,
		rd_io => rd_io_to_io,
		wr_out => wr_out_to_io,
		rd_in => rd_in_to_io,
		led_verdes => LEDG,
		led_rojos => LEDR,
		SW => SW(8 downto 0),
		HEX0 => HEX0,
		HEX1 => HEX1,
		HEX2 => HEX2,
		HEX3 => HEX3,
		KEY => KEY,
		PS2_CLK => PS2_CLK,
		PS2_DATA => PS2_DAT
		);	

END Structure;