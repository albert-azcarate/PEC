LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY datapath IS
    PORT (clk    : IN STD_LOGIC;
          op     : IN STD_LOGIC;
          wrd    : IN STD_LOGIC;
          addr_a : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
          immed  : IN STD_LOGIC_VECTOR(15 DOWNTO 0));
END datapath;


ARCHITECTURE Structure OF datapath IS

	component regfile is
		PORT( clk    : IN  std_logic;
				wrd    : IN  STD_LOGIC;
				d      : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
				addr_a : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
				addr_d : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
				a      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	end component;
	
	component alu is
		PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          op : IN  STD_LOGIC;
          w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	end component;




    -- Aqui iria la declaracion de las entidades que vamos a usar
    -- Usaremos la palabra reservada COMPONENT ...
    -- Tambien crearemos los cables/buses (signals) necesarios para unir las entidades
	 

signal alu_out_to_regbank : std_logic_vector(15 downto 0);
signal regbank_to_alu : std_logic_vector(15 downto 0);

BEGIN
	register_bank : regfile port map (clk => clk, wrd => wrd, d => alu_out_to_regbank, addr_a => addr_a, addr_d => addr_d, a => regbank_to_alu);
	
	alu_unit : alu port map(x => regbank_to_alu, y => immed, op => op , w => alu_out_to_regbank);


    -- Aqui iria la declaracion del "mapeo" (PORT MAP) de los nombres de las entradas/salidas de los componentes
    -- En los esquemas de la documentacion a la instancia del banco de registros le hemos llamado reg0 y a la de la alu le hemos llamado alu0

END Structure;