--TLB

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all; --Esta libreria sera necesaria si usais conversiones CONV_INTEGER
USE ieee.numeric_std.all;        --Esta libreria sera necesaria si usais conversiones TO_INTEGER
use work.TLB_entry.all;

ENTITY TLB_D IS
		PORT ( 	boot 		: in   std_logic;
			CLOCK		 		: in  std_logic;
			command	 		: in std_logic_vector(1 downto 0);
			priv_lvl			: in std_logic;
			wre				: in std_logic; --Write en memoria (stores)
			exc_tlb_D		: out std_logic_vector(3 downto 0);--{MISS_TLB_D, PPD, PID, PLD}
			std_input 		: in std_logic_vector(15 downto 0); --acces normal
			std_output 		: out std_logic_vector(15 downto 0); --acces normal
			Ra					: in std_logic_vector(15 downto 0);
			Rb					: in std_logic_vector(15 downto 0));
END TLB_D;


ARCHITECTURE Structure OF TLB_D IS

	signal VTags : TLB_array_t:= (others => (others => '0'));
	signal PTags : TLB_array_t:= (others => (others => '0'));
	signal Valid_bits  : std_logic_vector(7 downto 0):= (others => '0');
	signal Read_bits  : std_logic_vector(7 downto 0):= (others => '0');
	signal adress_reg	: integer;
	signal add_tag_command : integer;
BEGIN
	add_tag_command <= conv_integer(Ra(15 downto 12));
	
	exc_tlb_D(0) <= '1' when adress_reg = -1 else '0'; --MISS_TLB_D
	exc_tlb_D(1) <= '1' when adress_reg > 2 and priv_lvl = '0' else '0'; --Pagina Protegida D
	exc_tlb_D(2) <= '1' when adress_reg /= -1 and VTags(adress_reg)(4) = '0' else '0'; --Pagina Invalida D
	exc_tlb_D(3) <= '1' when adress_reg /= -1 and VTags(adress_reg)(5) = '1' and wre = '1'else '0'; --Pagina solo lectura

	--read asincron TLB, treball standard de la TLB
	std_output <= PTags(adress_reg)&std_input(11 downto 0) when adress_reg /= -1 else (others => '0');
	
	
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
			else 
				if command = "00" then --WRPD
					--WR en TAGS Fisics: valid = RB<5>, Oread = RB<4>
					PTags(add_tag_command)(3 downto 0) <= Rb(15 downto 12);
					Valid_bits(add_tag_command) <= Rb(5);
					Read_bits(add_tag_command) <= Rb(4);
				elsif command = "01" then --WRVI
					VTags(add_tag_command)(3 downto 0) <= Rb(15 downto 12);
				elsif command = "10" and Ra(1)= '1' then --flush // no es fa flush si el bit Ra(1) = '0'
					--que fem? posar-ho tot a zero?
					--pero les direccions del systema tambe?
					--jo he pensat que millor només les del user
					PTags(0) <= x"0"; --usr
					PTags(1) <= x"0"; --usr
					PTags(2) <= x"0"; --usr
					VTags(0) <= x"0"; --usr
					VTags(1) <= x"0"; --usr
					VTags(2) <= x"0"; --usr
				end if;
			end if;
		end if;
	end process;
	
END Structure;