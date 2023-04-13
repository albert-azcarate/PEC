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
use work.all;

ENTITY controladores_IO IS
	PORT (	boot 		: in    std_logic;
			CLOCK_50 	: in    std_logic;
			addr_io 	: in    std_logic_vector(7 downto 0);
			wr_io 		: in    std_logic_vector(15 downto 0); --entrada que hem d'escriure al nostre banc
			rd_io 		: out   std_logic_vector(15 downto 0); --sortida de lo que llegim dels nostres bancs
			wr_out 		: in    std_logic; --hem d'escriure al nostre banc
			rd_in 		: in    std_logic; --la ALU ens llegeix
			led_verdes	: OUT   std_logic_vector(7 DOWNTO 0);
			led_rojos 	: OUT   std_logic_vector(7 DOWNTO 0);
			SW 			: in    std_logic_vector(8 DOWNTO 0);
			HEX0 		: OUT   std_logic_vector(6 DOWNTO 0);
			HEX1 		: OUT   std_logic_vector(6 DOWNTO 0);
			HEX2 		: OUT   std_logic_vector(6 DOWNTO 0);
			HEX3 		: OUT   std_logic_vector(6 DOWNTO 0);
			KEY 		: in    std_logic_vector(3 DOWNTO 0);
			ps2_clk 	: inout std_logic;
			ps2_data 	: inout std_logic;
			vga_cursor  : out std_logic_vector(15 downto 0);
			vga_cursor_enable : out std_logic
		);
END controladores_IO;

-- Special Ports:
-- 		5  : 8 green LEDs
-- 		6  : 8 red LEDs
-- 		7  : 4 push buttons
-- 		8  : 8 switches
-- 		9  : On/Off 7-segment
-- 		10 : 7-segment hexadecimal display
-- 		15 : PS/2 data (keyboard)
-- 		16 : Keyboard status
--		21 : CountDown

ARCHITECTURE Structure OF controladores_IO IS
	
	signal io_registers	: io_reg.io_array_t := (others => (others => '0'));
	signal adress_reg	: integer;
	signal input_disp	: std_logic_vector(15 downto 0);
	signal char_readed	: std_logic_vector(7 downto 0);
	signal clear		: std_logic;
	signal ready		: std_logic;
	
	signal contador_ciclos			: STD_LOGIC_VECTOR(15 downto 0):=x"0000";
	signal contador_milisegundos	: STD_LOGIC_VECTOR(15 downto 0):=x"0000";
	
	
	component keyboard_controller is
	port (	clk			: in 	STD_LOGIC;
			reset		: in 	STD_LOGIC;
			ps2_clk		: inout STD_LOGIC;
			ps2_data	: inout STD_LOGIC;
			read_char	: out 	STD_LOGIC_VECTOR (7 downto 0);
			clear_char	: in 	STD_LOGIC;
			data_ready	: out 	STD_LOGIC
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

BEGIN

	-- Assignem els 8 bits de menor pes als leds corresponents
	led_rojos <= io_registers(6)(7 downto 0);
	led_verdes <= io_registers(5)(7 downto 0);
	
	-- Quin port IO volem accedir
	adress_reg <= conv_integer(addr_io);	

	process (CLOCK_50, boot) begin
		
		if boot='1' then							-- BOOT estem a boot posem el reg 16 a 0 (si no no anava, era sempre 1); REVISAR buscar workaround( diria que amb el others others de io_reg ja esta)
			io_registers(16) <= x"0000";		
		elsif rising_edge(CLOCK_50) then 			-- RUN
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
					if adress_reg /= 21 then									-- Si no escribim al port 21, posem el comptador actualitzat
						io_registers(21) <= contador_milisegundos;
					end if;					
				elsif rd_in = '1' then											-- IN
				
					rd_io <=  io_registers(adress_reg);
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
			else
				contador_ciclos <= contador_ciclos-1;
			end if;
			
			-- Random numbers Port 20
			io_registers(20) <= contador_ciclos;
			
		end if;
	end process;
	
	-- Bits 3 downto 0 del reg 9 encenen o apaguen els 7-segment; Input X l'apaga
	input_disp(3 downto 0) 	 <= io_registers(10)(3 downto 0)   when io_registers(9)(0) = '1' else (others => 'X');
	input_disp(7 downto 4)   <= io_registers(10)(7 downto 4)   when io_registers(9)(1) = '1' else (others => 'X');
	input_disp(11 downto 8)  <= io_registers(10)(11 downto 8)  when io_registers(9)(2) = '1' else (others => 'X');
	input_disp(15 downto 12) <= io_registers(10)(15 downto 12) when io_registers(9)(3) = '1' else (others => 'X');
	
	
	driver : BCD port map(input => input_disp, out_HEX0 => HEX0, out_HEX1 => HEX1, out_HEX2 => HEX2, out_HEX3 => HEX3);
	
	KEYBOARD: keyboard_controller port map(
		clk 		=> CLOCK_50, 			
		reset 		=> boot, 	
		ps2_clk 	=> PS2_CLK, 		-- Rellotge intern del protocol PS2
		ps2_data	=> PS2_DATA, 		-- Bus de comunicacio serie
		read_char 	=> char_readed, 	-- Ultima teclat pitjada
		clear_char 	=> clear, 			-- Ack cap al teclat ; 			Si se desea conectar el teclado para trabajar por encuesta, se debe hacer una instruccion out sobre el puerto al que esta conectada esta senyal para indicar que la tecla ya ha sido leida
		data_ready	=> ready			-- Indica noves dades al bus;	Para usar el controlador por encuesta, se debe hacer una instruccion in sobre el puerto al que esta conectada esta senyal para saber si hay una tecla nueva disponible.
		); 

END Structure;