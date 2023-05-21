library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--use work.all;
--datasheet: file:///C:/Users/pec05/Desktop/DE1_CD_v08/DE1_CD_v0.8/Datasheets/Memory/61LV25616.pdf


entity SRAMController is
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
end SRAMController;

architecture comportament of SRAMController is
begin

		process (clk) begin
			if rising_edge(clk)then
				SRAM_ADDR <= "000"&address(15 downto 1);--	 when byte_m = '0' else "00"&address(15 downto 0);
				SRAM_CE_N <= '0';
				
				if WR = '0' then 				-- LECTURA
					SRAM_OE_N <= '0';
					SRAM_DQ <= (others=>'Z');
				else 							-- ESCRIPTURA	
					SRAM_OE_N <= '1';
					if  byte_m = '0' then										-- WORD
						SRAM_DQ <= DataToWrite;	
					elsif address(0) = '0'  then								-- LOW
						SRAM_DQ <= "ZZZZZZZZ"&DataToWrite(7 downto 0);
					else 														-- HIGH
						SRAM_DQ <= DataToWrite(7 downto 0)&"ZZZZZZZZ";
					end if;
				end if;
				
				if byte_m = '0' then				-- WORD
					SRAM_UB_N <= '0';
					SRAM_LB_N <= '0';
					dataReaded <= SRAM_DQ(15 downto 0); --extenem signe
				else 								-- BYTE
					SRAM_UB_N <= not address(0);
					SRAM_LB_N <= address(0);
					if address(0) = '0' then 				-- LOWER
						dataReaded(15 downto 8) <= (others => SRAM_DQ(7)); --extenem signe
						dataReaded(7 downto 0) <= SRAM_DQ(7 downto 0);
					else									-- UPPER
						dataReaded(15 downto 8) <= (others => SRAM_DQ(15)); --extenem signe
						dataReaded(7 downto 0) <= SRAM_DQ(15 downto 8);
					end if;
				end if;
				
				SRAM_WE_N <= not WR;
			end if;
	end process;


end comportament;
