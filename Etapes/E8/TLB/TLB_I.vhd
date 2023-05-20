
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all; --Esta libreria sera necesaria si usais conversiones CONV_INTEGER
USE ieee.numeric_std.all;        --Esta libreria sera necesaria si usais conversiones TO_INTEGER
use work.TLB_entry.all;

ENTITY TLB_I IS
		PORT ( 	boot 		: in  std_logic;
				CLOCK		: in  std_logic;
				priv_lvl	: in  std_logic;
				wre			: in  std_logic;
				ld_m		: in  STD_LOGIC;
				command	 	: in  std_logic_vector(1 downto 0);		-- (00) WRPI, WRVI, FLUSH, NOP (11)
				estat		: in  std_logic_vector(1 downto 0);
				std_input 	: in  std_logic_vector(15 downto 0);	-- acces normal
				Ra			: in  std_logic_vector(15 downto 0);
				Rb			: in  std_logic_vector(15 downto 0);
				exc_tlb_I	: out std_logic_vector(2 downto 0);		-- {MISS_TLB_I, PPI, PII}
				std_output 	: out std_logic_vector(15 downto 0) 	-- acces normal
				);
END TLB_I;


ARCHITECTURE Structure OF TLB_I IS
	signal VTags : TLB_array_t:= (others => (others => '0'));
	signal PTags : TLB_array_t:= (others => (others => '0'));
	signal Valid_bits : std_logic_vector(7 downto 0):= (others => '0');
	signal Read_bits  : std_logic_vector(7 downto 0):= (others => '0');
	signal adress_reg	: integer;
	signal wr_addr		: integer;
BEGIN
	wr_addr <= conv_integer(Ra(3 downto 0));

	adress_reg <= 	0 when std_input(15 downto 12) = VTags(0) else	-- usr
					1 when std_input(15 downto 12) = VTags(1) else	-- usr
					2 when std_input(15 downto 12) = VTags(2) else	-- usr

					3 when std_input(15 downto 12) = VTags(3) else	-- sys
					4 when std_input(15 downto 12) = VTags(4) else	-- sys
					5 when std_input(15 downto 12) = VTags(5) else	-- sys
					6 when std_input(15 downto 12) = VTags(6) else	-- sys
					7 when std_input(15 downto 12) = VTags(7) else	-- sys
					-1;

	-- Excepcions
	exc_tlb_I(0) <= '1' when adress_reg = -1 and (ld_m = '1' or wre = '1') else '0';			-- MISS_TLB_I
	exc_tlb_I(1) <= '1' when Valid_bits(adress_reg) = '0' else '0';								-- Pagina Invalida 
	exc_tlb_I(2) <= '1' when adress_reg > 2 and (priv_lvl = '0' and estat = "01") else '0';		-- Pagina Protegida 
	
	--read asincron TLB, treball standard de la TLB
	std_output <= PTags(adress_reg)&std_input(11 downto 0) when adress_reg /= -1 and Valid_bits(adress_reg) = '1' else x"0FFF";
	
	
	process (boot, CLOCK) begin
		if rising_edge(CLOCK) then
			if boot = '1' then --sys addr hardcoded
			--HARDCODED: init de TLB pagines sys a carregar{0x0,0x1,0x2,0xC,0xD,0xE,0xF,0x8}
				PTags(0) <= x"0"; --usr
				PTags(1) <= x"1"; --usr
				PTags(2) <= x"2"; --usr
				
				PTags(3) <= x"8"; --sys
				PTags(4) <= x"c"; --sys
				PTags(5) <= x"d"; --sys
				PTags(6) <= x"e"; --sys
				PTags(7) <= x"f"; --sys
				
				VTags(0) <= x"0"; --usr
				VTags(1) <= x"1"; --usr
				VTags(2) <= x"2"; --usr
				
				VTags(3) <= x"8"; --sys
				VTags(4) <= x"c"; --sys
				VTags(5) <= x"d"; --sys
				VTags(6) <= x"e"; --sys
				VTags(7) <= x"f"; --sys
				
				Valid_bits <= (others => '1');
				Read_bits(2 downto 0) <= (others => '0');
				Read_bits(7 downto 3) <= (others => '1'); -- Les pagines de systema nomes en mode lectura
			else 
				if command = "00" then -- WRrite Phisical address into Instruction TLB
				
					PTags(wr_addr) <= Rb(3 downto 0);	-- Ra<3-0> = entrada, Rb<3-0> = Value
					Valid_bits(wr_addr) <= Rb(5);		-- valid = RB<5>
					Read_bits(wr_addr) <= Rb(4);		-- Oread = RB<4>
					
				elsif command = "01" then -- WRrite Virtual address into Instruction TLB
					VTags(wr_addr) <= Rb(3 downto 0);
					
				elsif command = "10" then -- Flush 
					-- FLUSH: 	if ( Ra & 1 ) { flush dcache; }
					-- 			if ( Ra & 2 ) { flush dtlb; }
					-- 			if ( Ra & 4 ) { flush icache; }
					-- 			if ( Ra & 8 ) { flush itlb; }
					
					if Ra = x"0008" then
						PTags(0) <= x"0"; --usr
						PTags(1) <= x"0"; --usr
						PTags(2) <= x"0"; --usr

						PTags(3) <= x"8"; --sys
						PTags(4) <= x"c"; --sys
						PTags(5) <= x"0"; --sys
						PTags(6) <= x"0"; --sys
						PTags(7) <= x"0"; --sys

						VTags(0) <= x"0"; --usr
						VTags(1) <= x"0"; --usr
						VTags(2) <= x"0"; --usr

						VTags(3) <= x"8"; --sys
						VTags(4) <= x"c"; --sys
						VTags(5) <= x"0"; --sys
						VTags(6) <= x"0"; --sys
						VTags(7) <= x"0"; --sys	
						
						Valid_bits <= (others => '1');
						Read_bits(2 downto 0) <= (others => '0');
						Read_bits(7 downto 3) <= (others => '1'); -- Les pagines de systema nomes en mode lectura
					end if;
				end if;
				
				-- else 11 NOP
				
			end if;
		end if;
	end process;

	

END Structure;