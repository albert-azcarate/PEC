
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all; --Esta libreria sera necesaria si usais conversiones CONV_INTEGER
USE ieee.numeric_std.all;        --Esta libreria sera necesaria si usais conversiones TO_INTEGER
use work.reg.all;
use work.exc_code.all;

ENTITY floatreg IS
    PORT (clk    : IN  STD_LOGIC;
			boot		: IN  STD_LOGIC;
          wrd    : IN  STD_LOGIC;
          d      : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          addr_a : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_b : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          a      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          b      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END floatreg;

ARCHITECTURE Structure OF floatreg IS

signal reg_vector : slv_array_t := (others => x"0000");
signal prev_addr : std_logic_vector(15 downto 0) := (others => '0');


BEGIN
	a <= reg_vector(conv_integer(addr_a));
	b <= reg_vector(conv_integer(addr_b));
	
	process (clk,boot) begin
		if boot = '1' then
			-- Posem tots els registres a 0 (others => (others => '0'))
			reg_vector <= (others => (others => '0'));
		else 
			-- escriptura sinc
			if rising_edge(clk) then
				if wrd = '1' then
					reg_vector(conv_integer(addr_d)) <= d;
				end if;
			end if;
		end if;
	end process;

END Structure;