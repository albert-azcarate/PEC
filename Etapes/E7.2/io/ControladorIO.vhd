library ieee;
use ieee.std_logic_1164.all;

package io_reg is
	type io_array_t is array (0 to 31) of std_logic_vector (15 downto 0);
  --type io_array_t is array (0 to 255) of std_logic_vector (15 downto 0);
end package;

package body io_reg is
end package body;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all; --Esta libreria sera necesaria si usais conversiones CONV_INTEGER
USE ieee.numeric_std.all;        --Esta libreria sera necesaria si usais conversiones TO_INTEGER
use work.io_reg.all;

ENTITY controladores_IO IS
	PORT ( 	boot 		: in	std_logic;
			CLOCK_50 	: in	std_logic;
			clk			: in	std_logic;
			wr_out 		: in	std_logic; --hem d'escriure al nostre banc
			rd_in 		: in	std_logic; --la ALU ens llegeix
			inta		: in	STD_LOGIC;
			KEY 		: in	std_logic_vector(3 DOWNTO 0);
			addr_io 	: in	std_logic_vector(7 downto 0);
			SW 			: in	std_logic_vector(8 DOWNTO 0);
			wr_io 		: in	std_logic_vector(15 downto 0); --entrada que hem d'escriure al nostre banc
			ps2_clk 	: inout std_logic;
			ps2_data 	: inout std_logic;
			led_verdes	: OUT	std_logic_vector(7 DOWNTO 0);
			led_rojos 	: OUT	std_logic_vector(7 DOWNTO 0);
			HEX0 		: OUT	std_logic_vector(6 DOWNTO 0);
			HEX1 		: OUT	std_logic_vector(6 DOWNTO 0);
			HEX2 		: OUT	std_logic_vector(6 DOWNTO 0);
			HEX3 		: OUT	std_logic_vector(6 DOWNTO 0);
			rd_io 		: out	std_logic_vector(15 downto 0); --sortida de lo que llegim dels nostres bancs
			vga_cursor 	: out	std_logic_vector(15 downto 0);
			intr		: out	std_logic;
			vga_cursor_enable : out std_logic
			);
END controladores_IO;

-- Special Ports:
--		 0 - PORT per saber si ens fam la opearació GETIID
-- 		 5 - IN/OUT - los 8 leds VERDES mapeados en los 8 bits de menor peso del puerto5  : 8 green LEDs
-- 		 6 - IN/OUT - los 8 leds ROJOS mapeados en los 8 bits de menor peso del puerto6  : 8 red LEDs
-- 		 7 - IN     - los 4 pulsadores (KEY) de la placa estan constantemente mapeados en los 4 bits de menor peso del registro del puerto7  : 4 push buttons
-- 		 8 - IN     - los 8 interruptores (SW) de la placa estan constantemente mapeados en los 8 bits de menor peso del registro del puerto8  : 8 switches
-- 		 9 - IN/OUT - los 4 bits de menor peso del registro indica si el visor correspondiente debe estar encendido o apagado.9  : On/Off 7-segment
-- 		10 - IN/OUT - el valor de los 16 bits del puerto se muestran mediante caracteres hexadecimales el los 4 visores de la placa (HEX3...HEX0)10 : 7-segment hexadecimal display
-- 		11 - OUT    - posicion del cursor en la pantalla de texto (en caso de que lo implemente el controlador de VGA)15 : PS/2 data (keyboard)
-- 		15 - IN     - Valor del caracter ASCII correspondiente a la tecla pulsada16 : Keyboard status
-- 		16 - IN/OUT - Registro de Status para saber si hay una tecla nueva. El controlador del teclado lo pone a 1 para indicar que hay una tecla nueva y nosotros lo ponemos a 0 cuando ya la hemos leido
-- 		20 - OUT    - Random Numbers
-- 		21 - IN/OUT	- CountDown

ARCHITECTURE Structure OF controladores_IO IS
	
	signal io_registers	: io_array_t := (others => (others => '0'));
	signal adress_reg	: integer;
	signal input_disp	: std_logic_vector(15 downto 0);
	signal char_readed	: std_logic_vector(7 downto 0);
	signal clear		: std_logic;
	signal ready		: std_logic;
	
	signal contador_ciclos			: STD_LOGIC_VECTOR(15 downto 0):=x"0000";
	signal contador_milisegundos	: STD_LOGIC_VECTOR(15 downto 0):=x"0000";
	
	-- Signals per conectar inta i intr de cada component al controlador de interrupcions
	signal ps2_inta_conn : std_logic; 
	signal timer_inta_conn : std_logic; 
	signal key_inta_conn : std_logic; 
	signal switch_inta_conn : std_logic; 
	signal ps2_intr_conn : std_logic; 
	signal timer_intr_conn : std_logic; 
	signal key_intr_conn : std_logic; 
	signal switch_intr_conn : std_logic;
	signal read_key_conn : STD_LOGIC_VECTOR (3 downto 0); 
	signal rd_switch_conn : std_logic_vector(7 downto 0);
	signal rd_io_conn : std_logic_vector(15 downto 0);
	signal iid_conn : std_logic_vector(7 downto 0);
	signal iid_reg	: std_logic_vector(7 downto 0);
	signal rd_io_int : std_LOGIC_VECTOR(15 downto 0);
	
	component keyboard_controller is
	port (	clk 		: in	STD_LOGIC;
			reset		: in	STD_LOGIC;
			inta 		: IN	std_LOGIC;
			clear_char	: in	STD_LOGIC;
			ps2_clk		: inout STD_LOGIC;
			ps2_data	: inout STD_LOGIC;
			data_ready	: out	STD_LOGIC;
			intr 		: out	std_LOGIC;
			read_char	: out	STD_LOGIC_VECTOR (7 downto 0)
			);
	end component keyboard_controller; 
	
	component BCD IS
	PORT (	input		: in  std_logic_vector(15 downto 0);
			OUT_HEX0	: OUT std_logic_vector(6 downto 0);
			OUT_HEX1	: OUT std_logic_vector(6 downto 0);
			OUT_HEX2	: OUT std_logic_vector(6 downto 0);
			OUT_HEX3	: OUT std_logic_vector(6 downto 0)
			);
	END component;
	
	component timer is 
			PORT (
				boot		: in std_logic;
				clk			: in std_logic;
				inta		: in std_logic;
				intr		: out std_logic
			);
	end component;
	
		component interruptores is 
			PORT (
				boot		: in std_logic;
				clk		: in std_logic;
				inta		: in std_logic;
				switches	: in std_logic_vector(7 downto 0);
				intr 		: out std_logic;
				rd_switch : out std_logic_vector(7 downto 0)
			);
	end component;
	
	component pulsadores is 
			PORT (
				boot		: in std_logic;
				clk		: in std_logic;
				inta		: in std_logic;
				keys		: in std_logic_vector(3 downto 0);
				intr 		: out std_logic;
				read_key : out std_logic_vector(3 downto 0)
			);
	end component;
	
	component interrupt_controller is 
			PORT (
				boot			: in std_logic;
				clk			: in std_logic;
				inta			: in std_logic;
				intr 			: out std_logic;
				key_intr 	: in std_logic;
				ps2_intr		: in std_logic;
				switch_intr	: in std_logic;
				timer_intr	: in std_logic;
				key_inta		: out std_logic;
				ps2_inta		: out std_logic;
				switch_inta	: out std_logic;
				timer_inta	: out std_logic;
				iid			: out std_logic_vector(7 downto 0)
			);
	end component;
	
BEGIN

	-- Assignem els 8 bits de menor pes als leds corresponents
	led_rojos <= io_registers(6)(7 downto 0);
	led_verdes <= io_registers(5)(7 downto 0);
	
	-- Quin port IO volem accedir
	adress_reg <= conv_integer(addr_io);

	-- Llegim I/O excepte en adress = 0, que llegim IID
	rd_io <= rd_io_conn when adress_reg /= 0 else x"00"&iid_reg;

	process (clk, boot) begin
		
		if boot='1' then							-- BOOT estem a boot posem el reg 16 a 0 (si no no anava, era sempre 1); REVISAR buscar workaround( diria que amb el others others de io_reg ja esta)
			io_registers(16) <= x"0000";
			-- Posem tots els registres a 0 (others => (others => '0'))
			io_registers <= (others => (others => '0'));
					
		elsif rising_edge(clk) then 			-- RUN
			-- Llegim els Switchs i Keys
			io_registers(8) <= "0000000"&SW;
			io_registers(7) <= x"000"&KEY;
			clear <= '0';
			
			
			-- Si es un port accesible; Else es un NOP(control_l)
			if adress_reg < 32 then
				if wr_out = '1' and adress_reg /= 7 and adress_reg /= 8 and adress_reg /= 20 then	-- OUT; Ports 7, 8 i 20 no es pot escriure (Sw, Kw, Rand)
				
					io_registers(adress_reg) <= wr_io;
					if adress_reg = 16 then										-- Si escribim el port 16 avisem al teclat que ja hem llegit el caracter
						clear <= '1';
					end if;
					
					if adress_reg = 21 then									
						contador_milisegundos <= io_registers(21);
					end if;

				elsif rd_in = '1' then											-- IN
				
					rd_io_conn <=  io_registers(adress_reg);
					if adress_reg = 16 then										-- Si llegim el port 16, el posem a 0, conforme ja hem llegit
						io_registers(16) <= x"0000";
					end if;
				--else 															-- OUT a port 7 o 8; Ho deixo comentat perque no caldria avisar al usuari, ja que es un write
				--	rd_io <= X"DEAD"; 
				end if;
			end if;
			
			if ready = '1' then -- Si PS2 te un char el llegim
				io_registers(16) <= x"0001";
				io_registers(15) <= x"00"&char_readed;
			end if;
			
			-- Counter Port 21 
			if contador_ciclos = x"0000" then
				contador_ciclos <= x"C350"; -- tiempo de ciclo=20ns(50Mhz) 1ms=50000ciclos
				if contador_milisegundos > x"0000" then
					contador_milisegundos <= contador_milisegundos - '1';
				end if;
				
				-- Si no escribim al port 21, posem el comptador actualitzat
				if adress_reg /= 21 then									
					io_registers(21) <= contador_milisegundos;
				end if;	
			else
				contador_ciclos <= contador_ciclos - '1';
			end if;
			

			-- Random numbers Port 20
			io_registers(20) <= contador_ciclos;
			
		end if;
	end process;
	
	-- Si hi ha ack a una interrupcio guardem quin iid es al iid_reg
	process (clk, inta) begin
		if timer_inta_conn = '1' or key_inta_conn = '1' or switch_inta_conn = '1' or ps2_inta_conn = '1' then
				iid_reg <= iid_conn;
		end if;
	end process;
	
	
	-- Bits 3 downto 0 del reg 9 encenen o apaguen els 7-segment; Input X l'apaga
	input_disp(3 downto 0) 	 <= io_registers(10)(3 downto 0)   when io_registers(9)(0) = '1' else (others => '1');
	input_disp(7 downto 4)   <= io_registers(10)(7 downto 4)   when io_registers(9)(1) = '1' else (others => '1');
	input_disp(11 downto 8)  <= io_registers(10)(11 downto 8)  when io_registers(9)(2) = '1' else (others => '1');
	input_disp(15 downto 12) <= io_registers(10)(15 downto 12) when io_registers(9)(3) = '1' else (others => '1');
	
	
	driver : BCD port map(input => input_disp, out_HEX0 => HEX0, out_HEX1 => HEX1, out_HEX2 => HEX2, out_HEX3 => HEX3);
	
	KEYBOARD: keyboard_controller port map(
		clk 		=> CLOCK_50, 			
		reset 		=> boot, 	
		ps2_clk 	=> PS2_CLK, 		-- Rellotge intern del protocol PS2
		ps2_data	=> PS2_DATA, 		-- Bus de comunicacio serie
		read_char 	=> char_readed, 	-- Ultima teclat pitjada
		clear_char 	=> clear, 			-- Ack cap al teclat ; 			Si se desea conectar el teclado para trabajar por encuesta, se debe hacer una instruccion out sobre el puerto al que esta conectada esta senyal para indicar que la tecla ya ha sido leida
		data_ready	=> ready	,		-- Indica noves dades al bus;	Para usar el controlador por encuesta, se debe hacer una instruccion in sobre el puerto al que esta conectada esta senyal para saber si hay una tecla nueva disponible.
		intr => ps2_intr_conn, --out
		inta => ps2_inta_conn --in
		); 
		
	TIMER_INT: timer 	port map(
				boot		=> boot,
				clk			=> CLOCK_50,
				inta		=> timer_inta_conn,
				intr 		=> timer_intr_conn );
	
	PUL_INT: pulsadores port map(
				boot => boot,
				clk => CLOCK_50,
				inta	=> key_inta_conn,
				keys => KEY,
				intr 		=> key_intr_conn,
				read_key => read_key_conn );
	
	INT_INT: interruptores port map(
				boot			=> boot,
				clk			=> CLOCK_50,
				inta			=> switch_inta_conn,
				switches		=> sw(7 downto 0),
				intr 			=> switch_intr_conn,
				rd_switch 	=> rd_switch_conn );
	
	CINT : interrupt_controller port map(
				boot			=> boot,
				clk			=> clk,
				inta			=> inta,
				intr 			=> intr,
				key_intr 	=> key_intr_conn,
				ps2_intr		=> ps2_intr_conn,
				switch_intr	=> switch_intr_conn,
				timer_intr	=> timer_intr_conn,
				key_inta		=> key_inta_conn,
				ps2_inta		=> ps2_inta_conn,
				switch_inta	=> switch_inta_conn,
				timer_inta	=> timer_inta_conn,
				iid			=> iid_conn);
	

END Structure;