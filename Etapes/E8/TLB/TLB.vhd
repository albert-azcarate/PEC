--TLB
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all; --Esta libreria sera necesaria si usais conversiones CONV_INTEGER
USE ieee.numeric_std.all;        --Esta libreria sera necesaria si usais conversiones TO_INTEGER
use work.io_reg.all;

ENTITY TLB IS
	PORT ( 	boot 		: in	std_logic;
			CLOCK 	 	: in	std_logic;
			vtag_tlb		: in  std_logic_vector(3 downto 0);
			exc_tlb		: out std_logic_vector(2 downto 0);
			ptag_tlb		: out std_logic_vector(3 downto 0);
			priv_lvl		: in std_logic;
			wre			: in std_logic
			);
END TLB;


ARCHITECTURE Structure OF TLB IS

	
	
BEGIN

END Structure;