LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY Mux4 IS
 PORT( Control : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
 Bus0 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
 Bus1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
 Bus2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
 Bus3 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
 Salida : OUT STD_LOGIC_VECTOR(2 DOWNTO 0));
END Mux4;
ARCHITECTURE Structure OF Mux4 IS
BEGIN
	with Control select
		Salida <= bus0 when "00",
					bus1 when "01",
					bus2 when "10",
					bus3 when others;
END Structure;