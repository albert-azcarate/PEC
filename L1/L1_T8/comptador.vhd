LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY comptador IS
 PORT( d : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
 clock : IN std_logic;
 q : OUT STD_LOGIC_VECTOR(2 DOWNTO 0));
END comptador;
ARCHITECTURE Structure OF comptador IS
--variable suma : std_logic_VECTOR(2 downto 0);
BEGIN
	process (clock) begin
		if rising_edge(clock) then
			q <= d + "001";
		end if;	
	end process;
END Structure;