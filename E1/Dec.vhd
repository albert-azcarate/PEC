-- 
-- Input: wrd -> 1 bit, addr_d -> 3 bits
-- Output: output -> 1 bit

LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

package dec_p is
		component Dec is
			generic (
					size : natural);

			PORT(	wrd : in std_logic;
					addr_d : in std_logic_vector(size - 1 downto 0);
					output: out std_logic_vector((2**size) - 1 downto 0) := x"0"
					);
		end component;
end package dec_p;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

ENTITY Dec IS

-- generics
	generic (
			size : natural);

-- ports
	PORT(	wrd : in std_logic;
			addr_d : in std_logic_vector(size-1 downto 0);
			output: out std_logic_vector((2**size) - 1 downto 0) := x"0"
			);
			
END Dec;

ARCHITECTURE Structure OF Dec IS

-- constants

-- components

-- variables
	signal addr_d2 : natural;
BEGIN
	--addr_d2 <= to_integer(to_unsigned(addr_d, size));
	output <= (others => '0');
	output(addr_d2)<= 1 and wrd;
	
END Structure;
