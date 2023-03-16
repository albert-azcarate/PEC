LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY sisa IS
    PORT (CLOCK_50  : IN    STD_LOGIC;
          SRAM_ADDR : out   std_logic_vector(17 downto 0);
          SRAM_DQ   : inout std_logic_vector(15 downto 0);
          SRAM_UB_N : out   std_logic;
          SRAM_LB_N : out   std_logic;
          SRAM_CE_N : out   std_logic := '1';
          SRAM_OE_N : out   std_logic := '1';
          SRAM_WE_N : out   std_logic := '1';
          SW        : in std_logic_vector(9 downto 9));
END sisa;

ARCHITECTURE Structure OF sisa IS

	component MemoryController is
    port (CLOCK_50  : in  std_logic;
	      addr      : in  std_logic_vector(15 downto 0);
          wr_data   : in  std_logic_vector(15 downto 0);
          rd_data   : out std_logic_vector(15 downto 0);
          we        : in  std_logic;
          byte_m    : in  std_logic;
          -- se�ales para la placa de desarrollo
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
          word_byte : OUT STD_LOGIC);
	END component;

	signal addr_proc_to_mem: STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal word_byte_to_mem: std_LOGIC;
	signal wr_m_to_mem: std_LOGIC;
	signal data_wr_to_mem: STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal rd_data_to_proc: STD_LOGIC_VECTOR(15 DOWNTO 0);
	
	signal clk : std_logic_vector(2 downto 0) := "000";
BEGIN

	--falta divisor de freq.

	MUC: memoryController port map(cloCK_50 => CLOCK_50,
		addr => addr_proc_to_mem,
		wr_data => data_wr_to_mem,
		rd_data => rd_data_to_proc,
		we => wr_m_to_mem,
		byte_m => word_byte_to_mem,
		SRAM_ADDR => SRAM_ADDR,
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
		word_byte => word_byte_to_mem);
		
	process (CLOCK_50) BEGIN
		if rising_edge(CLOCK_50) then
			clk <= clk + 1;
		end if;
	END PROcess;

END Structure;