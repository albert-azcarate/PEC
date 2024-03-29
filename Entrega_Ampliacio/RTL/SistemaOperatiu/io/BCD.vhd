LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
ENTITY BCD IS
 PORT(input : in std_logic_vector(15 downto 0);
		on_off : in std_logic_vector(3 downto 0);
		OUT_HEX0 : OUT std_logic_vector(6 downto 0);
		OUT_HEX1 : OUT std_logic_vector(6 downto 0);
		OUT_HEX2 : OUT std_logic_vector(6 downto 0);
		OUT_HEX3 : OUT std_logic_vector(6 downto 0));
END BCD;

ARCHITECTURE Structure OF BCD IS

component driver7Segmentos4in is 
		PORT( codigoCaracter : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
				on_off : in std_logic;
				bitsCaracter : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
	end component;

BEGIN
	
	D0: driver7Segmentos4in port map(codigoCaracter => input(3 downto 0) , bitsCaracter => OUT_HEX0,on_off=> on_off(0));
	D1: driver7Segmentos4in port map(codigoCaracter => input(7 downto 4) , bitsCaracter => OUT_HEX1,on_off=> on_off(1));
	D2: driver7Segmentos4in port map(codigoCaracter => input(11 downto 8) , bitsCaracter => OUT_HEX2,on_off=> on_off(2));
	D3: driver7Segmentos4in port map(codigoCaracter => input(15 downto 12) , bitsCaracter => OUT_HEX3,on_off=> on_off(3));
	
END Structure;