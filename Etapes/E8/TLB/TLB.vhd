--TLB
library ieee;
use ieee.std_logic_1164.all;

package TLB_entry is
	type TLB_array_t is array (0 to 7) of std_logic_vector (3 downto 0);
end package;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all; --Esta libreria sera necesaria si usais conversiones CONV_INTEGER
USE ieee.numeric_std.all;        --Esta libreria sera necesaria si usais conversiones TO_INTEGER

ENTITY TLB IS
	PORT ( 	boot 		: in	std_logic;
			CLOCK 	 	: in	std_logic;
			std_input 	: in std_logic_vector(15 downto 0); --acces normal
			std_output 	: out std_logic_vector(15 downto 0); --acces normal
			state			: in std_logic_vector(1 downto 0);
			Ra				: in std_logic_vector(15 downto 0);
			Rb				: in std_logic_vector(15 downto 0);
			exc_tlb		: out std_logic_vector(3 downto 0);--revisar
			priv_lvl		: in std_logic;
			wre			: in std_logic; --write enabled de memoria (store)
			TLB_com		: in std_logic_vector(2 downto 0)--en ordre{WRPI, WRVI, WRPD, WRVD, FLUSH}
			);
END TLB;


ARCHITECTURE Structure OF TLB IS

	component TLB_I is
		PORT ( 	boot 		: in	std_logic;
			CLOCK		 	: in	std_logic;
			exc_tlb_I		: out std_logic_vector(2 downto 0); --{MISS_TLB_I, PPI, PII}
			priv_lvl		: in std_logic;
			command	 	: in std_logic_vector(1 downto 0); --(00) WRPI, WRVI, FLUSH, NOP (11)
			std_input 	: in std_logic_vector(15 downto 0); --acces normal
			std_output 	: out std_logic_vector(15 downto 0); --acces normal
			Ra				: in std_logic_vector(15 downto 0);
			Rb				: in std_logic_vector(15 downto 0));
	end component;
	
	component TLB_D is
		PORT ( 	boot 		: in   std_logic;
			CLOCK		 		: in  std_logic;
			command	 		: in std_logic_vector(1 downto 0);
			priv_lvl			: in std_logic;
			wre				: in std_logic;
			exc_tlb_D		: out std_logic_vector(3 downto 0);--{MISS_TLB_D, PPD, PID, PLD}
			std_input 	: in std_logic_vector(15 downto 0); --acces normal
			std_output 	: out std_logic_vector(15 downto 0); --acces normal
			Ra					: in std_logic_vector(15 downto 0);
			Rb					: in std_logic_vector(15 downto 0));
	end component;
	
	signal TLB_Command_To_data : std_logic_vector(1 downto 0); --(00) WRPI, WRVI, FLUSH, NOP (11)
	signal TLB_Command_To_inst	: std_logic_vector(1 downto 0); --(00) WRPD, WRVD, FLUSH, NOP (11)
	signal exc_I : std_logic_vector(2 downto 0);
	signal exc_D : std_logic_vector(2 downto 0);
	signal ptag_I : std_logic_vector(3 downto 0);
	signal ptag_D : std_logic_vector(3 downto 0);
	signal translation_D : std_logic_vector(15 downto 0);
	signal translation_I : std_logic_vector(15 downto 0);
	
	
BEGIN
--RA 2 -> dades (bit 1)
--RA 8 -> instr (bit 3)

--WR en TAGS Fisics: valid = RB<5>, Oread = RB<4>

--	"000" when wrpi (TLB)
--	"001" when wrvi (TLB)
--	"010" when wrpd (TLB)
--	"011" when wrvD (TLB)
--	"100" when flush_I (TLB)
-- "110" when flush_D (TLB)
--	"111" when NOP (TLB)		
								
	TLB_Command_To_data <=  TLB_Com(2)&TLB_Com(0) when TLB_Com(1) ='1' else
									TLB_Com(2)&'1';
																
	TLB_Command_To_inst <= TLB_Com(2)&TLB_Com(0) when TLB_Com(1) ='0' else
								  TLB_Com(2)&'1';
								
	--diferencies entre ins i data TLB:
		--data te una excepcio mes (READ ONLY PAGE when store)
								  
	exc_tlb <= '0'&exc_I when state = "00" else --fetch
				  exc_D when state = "01" else --decode
				  "000";
	
	ins_TLB: TLB_I port map(boot => boot,
			CLOCK		 	 => Clock,
			exc_tlb_I	 => exc_I,
			priv_lvl		 => priv_lvl,
			command	 	 => TLB_Command_To_inst,
			std_output	 => translation_I,
			std_input	 => std_input,
			Ra				 => Ra,
			Rb				 => Rb);
	
	data_TLB: TLB_D port map(boot => boot,
			CLOCK		 	 => CLOCK,
			command	 	 => TLB_Command_To_data,
			wre			 => wre,
			exc_tlb_D	 => exc_D,
			priv_lvl		 => priv_lvl,
			std_output	 => translation_D,
			std_input	 => std_input,
			Ra				 => Ra,
			Rb				 => Rb);

	 std_output <= translation_I when state = "00" else
						translation_D when state = "01" else
						x"0000"; -- revisar, que passa en els estats de systema
END Structure;