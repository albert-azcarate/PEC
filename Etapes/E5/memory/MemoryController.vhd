library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity MemoryController is
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
end MemoryController;

architecture comportament of MemoryController is

	component SRAMController is
    port (clk         : in    std_logic;
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
          byte_m      : in    std_logic := '0');
	end component;	
	
		 
	signal enable: std_logic;
begin

	-- Permetem escriure a memoria en zona d'usuari
	enable <= we when addr < x"c000" else '0';
	
	sram: SRAMController port map ( 	clk => CloCK_50,
												sraM_ADDR => SRAM_ADDR,
												SRAM_CE_N => SRAM_CE_N,
												SRAM_DQ => SRAM_DQ,
												SRAM_LB_N => SRAM_LB_N,
												SRAM_OE_N => SRAM_OE_N,
												SRAM_UB_N => SRAM_UB_N,
												SRAM_WE_N => SRAM_WE_N,
												ADDress => addr,
												dataReaded => rd_data,
												datatoWrite => wr_data,
												WR => enable,
												byte_m => byte_m);

end comportament;
