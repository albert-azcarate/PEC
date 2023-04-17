LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY alu IS
    PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          op : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
          w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END alu;


ARCHITECTURE Structure OF alu IS

signal movhi_signal : std_logic_vector (15 downto 0) := (others => '0');
signal ext_signe : std_logic_vector (15 downto 0) := (others => '0');

BEGIN

	ext_signe(15 downto 8) <= (others => y(7)); -- extenem singe
	ext_signe(7 downto 0) <= y(7 downto 0); -- copiem

	movhi_signal(15 downto 8) <= y(7 downto 0);
	movhi_signal(7 downto 0) <= x(7 downto 0);
	
	with op select
		w <= 	ext_signe when "00", --MOVI
				movhi_signal when "01", --MOVHI
				x + y when others;
END Structure;