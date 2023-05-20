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
	PORT ( 	boot 		: in  std_logic;
			CLOCK 	 	: in  std_logic;
			priv_lvl	: in  std_logic;
			wre			: in  std_logic; 						-- write enabled de memoria (store)
			ld_m		: in  STD_LOGIC;
			state		: in  std_logic_vector(1 downto 0);        
			TLB_com		: in  std_logic_vector(2 downto 0);		-- en ordre{WRPI, WRVI, WRPD, WRVD, FLUSH}
			std_input 	: in  std_logic_vector(15 downto 0); 	-- acces normal
			Ra			: in  std_logic_vector(15 downto 0);       
			Rb			: in  std_logic_vector(15 downto 0);   
			we_mem		: out std_logic;
			exc_tlb		: out std_logic_vector(3 downto 0);		-- revisar
			std_output 	: out std_logic_vector(15 downto 0) 	-- acces normal
			);
END TLB;


ARCHITECTURE Structure OF TLB IS

	component TLB_I is
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
	end component;
	
	component TLB_D is
		PORT ( 	boot 		: in  std_logic;
				CLOCK		: in  std_logic;
				priv_lvl	: in  std_logic;
				wre			: in  std_logic;
				ld_m		: in  STD_LOGIC;
				command	 	: in  std_logic_vector(1 downto 0);
				std_input 	: in  std_logic_vector(15 downto 0); 	-- acces normal
				Ra			: in  std_logic_vector(15 downto 0);
				Rb			: in  std_logic_vector(15 downto 0);
				exc_tlb_D	: out std_logic_vector(3 downto 0);		-- {MISS_TLB_D, PPD, PID, PLD}
				std_output 	: out std_logic_vector(15 downto 0)		-- acces normal
				);
	end component;
	
signal TLB_Command_To_data	: std_logic_vector(1 downto 0); -- (00) WRPI, WRVI, FLUSH, NOP (11)
signal TLB_Command_To_inst	: std_logic_vector(1 downto 0); -- (00) WRPD, WRVD, FLUSH, NOP (11)
signal exc_I : std_logic_vector(2 downto 0);
signal exc_D : std_logic_vector(3 downto 0);
signal ptag_I : std_logic_vector(3 downto 0);
signal ptag_D : std_logic_vector(3 downto 0);
signal translation_D : std_logic_vector(15 downto 0);
signal translation_I : std_logic_vector(15 downto 0);
	
	
BEGIN

	-- "000" when wrpi (TLB)
	-- "001" when wrvi (TLB)
	-- "010" when wrpd (TLB)
	-- "011" when wrvd (TLB)
	-- "100" when flush (TLB)
	-- "111" when NOP (TLB)		
	-- Fem servir el bit 1 de TLB_Com per codificar la instruccio a fer al TLB de dades o instruccions.
	TLB_Command_To_data <=  "10" when TLB_Com = "100" else
							"11" when TLB_Com = "111" else
							TLB_Com(2)&TLB_Com(0) when TLB_Com(1) ='1' else
							"11";

	TLB_Command_To_inst <= 	"10" when TLB_Com = "100" else
							"11" when TLB_Com = "111" else
							TLB_Com(2)&TLB_Com(0) when TLB_Com(1) ='0'else
							"11";

	--diferencies entre ins i data TLB:
	--data te una excepcio mes (READ ONLY PAGE when store)

	exc_tlb <=	'0'&exc_I when state = "00" else	--fetch
				exc_D when state = "01" else		--decode
				"0000";
				
	we_mem <= wre when exc_I = "000" and exc_D = "0000" else '0';


	std_output <= 	translation_I when state = "00" else
					translation_D when state = "01" else
					translation_I; -- En systema necesitem la adressa de instruccions
	
	
	ins_TLB: TLB_I port map(	boot		=> boot,
								CLOCK		=> Clock,
								wre			=> wre,
								ld_m		=> ld_m,
								exc_tlb_I	=> exc_I,
								estat		=> state,
								priv_lvl	=> priv_lvl,
								command		=> TLB_Command_To_inst,
								std_output	=> translation_I,
								std_input	=> std_input,
								Ra			=> Ra,
								Rb			=> Rb
								);
	
	data_TLB: TLB_D port map(	boot => boot,
								CLOCK		=> CLOCK,
								command		=> TLB_Command_To_data,
								wre			=> wre,
								ld_m		=> ld_m,
								exc_tlb_D	=> exc_D,
								priv_lvl	=> priv_lvl,
								std_output	=> translation_D,
								std_input	=> std_input,
								Ra			=> Ra,
								Rb			=> Rb
								);
END Structure;