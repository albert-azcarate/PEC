LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
ENTITY L1_T8 IS
 PORT( KEY : IN std_logic_vector(0 downto 0);
	 SW : IN std_logic_vector(0 downto 0);
	 HEX0 : OUT std_logic_vector(6 downto 0);
	 HEX1 : OUT std_logic_vector(6 downto 0);
	 HEX2 : OUT std_logic_vector(6 downto 0);
	 HEX3 : OUT std_logic_vector(6 downto 0);
	 LEDG : OUT std_logic_vector(2 downto 0);
	 LEDR : OUT std_logic_vector(2 downto 0));
END L1_T8;

ARCHITECTURE Structure OF L1_T8 IS

	component comptador is
		PORT( d : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
				clock : IN std_logic;
				q : OUT STD_LOGIC_VECTOR(2 DOWNTO 0));
	end component;
	
	component driver7Segmentos is 
			PORT( codigoCaracter : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
					bitsCaracter : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
	end component;
	
	

constant h : std_logic_vector (2 downto 0) := "000";	
constant o : std_logic_vector (2 downto 0) := "001";
constant l : std_logic_vector (2 downto 0) := "010";
constant a : std_logic_vector (2 downto 0) := "011";

signal output_comptador : std_logic_vector (2 downto 0) := "000";
--signal outD0, outD1, outD2, outD3 : std_LOGIC_VECTOR (6 downto 0); 
--signal outM0, outM1, outM2, outM3 :  std_LOGIC_VECTOR (6 downto 0); 
SIGNAL offset : std_LOGIC_VECTOR(2 downto 0);
signal sumant : std_LOGIC_VECTOR(2 downto 0);

BEGIN
	offset(2) <= SW(0);
	offset(1) <= SW(0);
	offset(0) <= SW(0);
	
	
   LEDG <= sumant;
	C1: comptador port map (d => sumant, q => output_comptador,  clock => KEY(0));
	D0: driver7Segmentos port map(codigoCaracter => a + output_comptador, bitsCaracter => HEX0);
	D1: driver7Segmentos port map(codigoCaracter => l + output_comptador, bitsCaracter => HEX1);
	D2: driver7Segmentos port map(codigoCaracter => o + output_comptador, bitsCaracter => HEX2);
	D3: driver7Segmentos port map(codigoCaracter => h + output_comptador, bitsCaracter => HEX3);
	
	LEDR <= output_comptador;
	
	sumant <= offset + output_comptador;
END Structure;