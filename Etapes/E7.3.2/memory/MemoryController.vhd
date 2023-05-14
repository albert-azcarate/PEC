library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--use work.all;

entity MemoryController is
    port (	CLOCK_50  	: in	std_logic;
			we        	: in	std_logic;
			byte_m    	: in	std_logic;
			privilege_lvl : in std_logic;
			addr      	: in	std_logic_vector(15 downto 0);
			wr_data   	: in	std_logic_vector(15 downto 0);
			no_al		: out   std_logic;
			pp_tlb_d	: out std_logic; --exc
			rd_data   	: out	std_logic_vector(15 downto 0);
			-- senyales para la placa de desarrollo
			SRAM_ADDR 	: out	std_logic_vector(17 downto 0);
			SRAM_DQ   	: inout	std_logic_vector(15 downto 0);
			SRAM_UB_N 	: out	std_logic;
			SRAM_LB_N 	: out	std_logic;
			SRAM_CE_N 	: out	std_logic := '1';
			SRAM_OE_N 	: out	std_logic := '1';
			SRAM_WE_N 	: out	std_logic := '1';
			vga_addr  	: out	std_logic_vector(12 downto 0);
			vga_we 		: out	std_logic;
			vga_wr_data : out	std_logic_vector(15 downto 0);
			vga_rd_data : in	std_logic_vector(15 downto 0);
			vga_byte_m 	: out	std_logic
			);
end MemoryController;

architecture comportament of MemoryController is

	component SRAMController is
    port (	clk         : in    std_logic;
			-- senyales para la placa de desarrollo
			SRAM_ADDR   : out   std_logic_vector(17 downto 0);
			SRAM_DQ     : inout std_logic_vector(15 downto 0);
			SRAM_UB_N   : out   std_logic;
			SRAM_LB_N   : out   std_logic;
			SRAM_CE_N   : out   std_logic := '1';
			SRAM_OE_N   : out   std_logic := '1';
			SRAM_WE_N   : out   std_logic := '1';
			-- senyales internas del procesador
			address     : in    std_logic_vector(15 downto 0) := "0000000000000000";
			dataReaded  : out   std_logic_vector(15 downto 0);
			dataToWrite : in    std_logic_vector(15 downto 0);
			WR          : in    std_logic;
			byte_m      : in    std_logic := '0'
			);
	end component;	
	

	signal enable: std_logic;
	signal rd_data_mem : std_logic_vector(15 downto 0);
	
begin

	-- Permetem escriure a memoria en zona d'usuari
	enable <= we when addr < x"c000" else '0';
	
	-- exception only when privilege lvl is no system's and accede in sys section
	pp_tlb_d <= '1' when (addr >= x"8000" and privilege_lvl = '0') else '0'; 
	
	no_al <= addr(0);
	
	-----------------------------
	-------- Control VGA --------
	-----------------------------
	
	-- Calculem el offset entre la nostre memoria i la direccio real de la VGA
	-- si no es el cas posem direccio 0x0 pero no pasa res perque tindrem el enable a 0 ; REVISAR, aixo podria ser directe sempre addr(12 downto 0)
	vga_addr <= addr(12 downto 0); -- when addr >= x"A000" and addr < x"c000" else (others => '0');
	
	-- Nomes escribim quan son les addreces correctes
	vga_we <= we when addr >= x"A000" and addr < x"c000" else '0';
	
	-- Dada a escriure a la VGA
	vga_wr_data <= wr_data;
	
	-- Assignem el tipus d'acces
	vga_byte_m <= byte_m;
	
	rd_data <= 	vga_rd_data when addr >= x"A000" and addr < x"c000" else
				rd_data_mem;
	
	
	sram: SRAMController port map (
		clk 		=> CloCK_50,
		sraM_ADDR	=> SRAM_ADDR,
		SRAM_CE_N 	=> SRAM_CE_N,
		SRAM_DQ		=> SRAM_DQ,
		SRAM_LB_N 	=> SRAM_LB_N,
		SRAM_OE_N 	=> SRAM_OE_N,
		SRAM_UB_N 	=> SRAM_UB_N,
		SRAM_WE_N 	=> SRAM_WE_N,
		ADDress 	=> addr,
		dataReaded 	=> rd_data_mem,
		datatoWrite => wr_data,
		WR 			=> enable,
		byte_m 		=> byte_m
		);

end comportament;
