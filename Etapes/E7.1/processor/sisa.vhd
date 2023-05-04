LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

use work.all;

ENTITY sisa IS
	PORT (	CLOCK_50	: in  	std_logic;
			SRAM_ADDR 	: out 	std_logic_vector(19 downto 0);
			SRAM_DQ		: inout std_logic_vector(15 downto 0);
			SRAM_UB_N	: out 	std_logic;
			SRAM_LB_N 	: out 	std_logic;
			SRAM_CE_N 	: out 	std_logic := '1';
			SRAM_OE_N 	: out 	std_logic := '1';
			SRAM_WE_N 	: out 	std_logic := '1';
			LEDG		: OUT 	std_logic_vector(7 DOWNTO 0);
			LEDR		: OUT 	std_logic_vector(7 DOWNTO 0);
			HEX0		: OUT 	std_logic_vector(6 DOWNTO 0);
			HEX1		: OUT 	std_logic_vector(6 DOWNTO 0);
			HEX2		: OUT 	std_logic_vector(6 DOWNTO 0);
			HEX3		: OUT 	std_logic_vector(6 DOWNTO 0);
			SW			: in  	std_logic_vector(9 DOWNTO 0);
			KEY			: in  	std_logic_vector(3 DOWNTO 0);
			PS2_CLK		: inout std_logic;
			PS2_DAT		: inout std_logic;
			VGA_R		: out 	std_logic_vector (7 downto 0);
			VGA_G		: out 	std_logic_vector (7 downto 0);
			VGA_B		: out 	std_logic_vector (7 downto 0);
			VGA_HS		: out 	std_logic;
			VGA_VS		: out 	std_logic
			);
END sisa;

ARCHITECTURE Structure OF sisa IS

	component MemoryController is
    port (	CLOCK_50  	: in  	std_logic;
			addr      	: in  	std_logic_vector(15 downto 0);
			wr_data   	: in  	std_logic_vector(15 downto 0);
			rd_data   	: out 	std_logic_vector(15 downto 0);
			we        	: in  	std_logic;
			byte_m    	: in  	std_logic;
			-- senyales para la placa de desarrollo
			SRAM_ADDR 	: out 	std_logic_vector(17 downto 0);
			SRAM_DQ   	: inout std_logic_vector(15 downto 0);
			SRAM_UB_N 	: out	std_logic;
			SRAM_LB_N 	: out	std_logic;
			SRAM_CE_N 	: out	std_logic := '1';
			SRAM_OE_N 	: out	std_logic := '1';
			SRAM_WE_N 	: out	std_logic := '1';
			vga_addr  	: out 	std_logic_vector(12 downto 0);
			vga_we 		: out 	std_logic;
			vga_wr_data	: out 	std_logic_vector(15 downto 0);
			vga_rd_data : in 	std_logic_vector(15 downto 0);
			vga_byte_m 	: out 	std_logic
			);
	end component;
	
	component proc IS
    port (	clk       	: IN  std_logic;
			boot      	: IN  std_logic;
			intr			: IN std_logic;
			datard_m  	: IN  std_logic_vector(15 DOWNTO 0);
			addr_m    	: OUT std_logic_vector(15 DOWNTO 0);
			data_wr   	: OUT std_logic_vector(15 DOWNTO 0);
			wr_m      	: OUT std_logic;
			word_byte	: OUT std_logic;
			addr_io 	: out std_logic_vector(7 downto 0);
			wr_io 		: out std_logic_vector(15 downto 0);
			rd_io 		: in  std_logic_vector(15 downto 0);
			wr_out 		: out std_logic;
			rd_in 		: out std_logic;
			inta		: OUT STD_LOGIC
			);
	END component;

	component controladores_IO is
	port ( 	boot 		: in    std_logic;
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
			vga_cursor 	: out std_logic_vector(15 downto 0);
			vga_cursor_enable : out std_logic;
			intr		: out std_logic;
			inta		: in STD_LOGIC
			);
	END component;
	
	component vga_controller is
	port (	clk_50mhz      		: in  std_logic; 						-- system clock signal
			reset          		: in  std_logic; 						-- system reset
			blank_out      		: out std_logic; 						-- vga control signal
			csync_out      		: out std_logic; 						-- vga control signal
			red_out        		: out std_logic_vector(7 downto 0);		-- vga red pixel value
			green_out      		: out std_logic_vector(7 downto 0);		-- vga green pixel value
			blue_out       		: out std_logic_vector(7 downto 0);		-- vga blue pixel value
			horiz_sync_out 		: out std_logic; 						-- vga control signal
			vert_sync_out  		: out std_logic; 						-- vga control signal
			--
			addr_vga          	: in  std_logic_vector(12 downto 0);
			we                	: in  std_logic;
			wr_data           	: in  std_logic_vector(15 downto 0);
			rd_data           	: out std_logic_vector(15 downto 0);
			byte_m            	: in  std_logic;
			vga_cursor        	: in  std_logic_vector(15 downto 0);		-- simplemente lo ignoramos, este controlador no lo tiene implementado
			vga_cursor_enable	: in  std_logic);						-- simplemente lo ignoramos, este controlador no lo tiene implementado
	end component;




	signal addr_proc_to_mem	: std_logic_vector(15 DOWNTO 0);
	signal word_byte_to_mem	: std_logic;
	signal wr_m_to_mem		: std_logic;
	signal data_wr_to_mem	: std_logic_vector(15 DOWNTO 0);
	signal rd_data_to_proc	: std_logic_vector(15 DOWNTO 0);
	signal intr_to_proc		:std_logic;
	signal inta_to_io		:std_logic;
	
	signal clk : std_logic_vector(2 downto 0) := "000";
	
	signal addr_io_to_io	: std_logic_vector(7 downto 0);
	signal wr_io_to_io 		: std_logic_vector(15 downto 0);
	signal rd_io_to_io 		: std_logic_vector(15 downto 0);
	signal wr_out_to_io 	: std_logic;
	signal rd_in_to_io 		: std_logic;
	
	signal addr_mem_to_vga		: std_logic_vector(12 downto 0);
	signal we_mem_to_vga		: std_logic;
	signal wr_data_mem_to_vga	: std_logic_vector(15 downto 0);
	signal rd_data_vga_to_mem	: std_logic_vector(15 downto 0);
	signal byte_m_mem_to_vga	: std_logic;
	
	signal vga_cursor_dummy     	: std_logic_vector(15 downto 0) := (others => '0');
	signal vga_cursor_enable_dummy	: std_logic := '0';
	
BEGIN

	process (CLOCK_50) BEGIN
		if rising_edge(CLOCK_50) then
			clk <= clk + 1;
		end if;
	END PROcess;
	
	MUC: memoryController port map(
		cloCK_50 	=> CLOCK_50,
		addr 		=> addr_proc_to_mem,
		wr_data 	=> data_wr_to_mem,
		rd_data		=> rd_data_to_proc,
		we 			=> wr_m_to_mem,
		byte_m 		=> word_byte_to_mem,
		SRAM_ADDR 	=> SRAM_ADDR(17 downto 0),
		SRAM_CE_N 	=> SRAM_CE_N,
		SRAM_DQ 	=> SRAM_DQ,
		SRAM_LB_N 	=> SRAM_LB_N,
		SRAM_OE_N 	=> SRAM_OE_N,
		SRAM_UB_N 	=> SRAM_UB_N,
		SRAM_WE_N 	=> SRAM_WE_N,
		vga_addr 	=> addr_mem_to_vga, 	
		vga_we 		=> we_mem_to_vga, 
		vga_wr_data => wr_data_mem_to_vga, 
		vga_rd_data => rd_data_vga_to_mem,
		vga_byte_m	=> byte_m_mem_to_vga
		);
	
	processor: proc port map(
		clk 		=> clk(2),
		boot 		=> sw(9),
		datard_m 	=> rd_data_to_proc,
		addr_m 		=> addr_proc_to_mem,
		data_wr		=> data_wr_to_mem,
		wr_m 		=> wr_m_to_mem,
		word_byte	=> word_byte_to_mem,
		addr_io 	=> addr_io_to_io,
		wr_io 		=> wr_io_to_io,
		rd_io 		=> rd_io_to_io,
		wr_out 		=> wr_out_to_io,
		rd_in 		=> rd_in_to_io,
		intr			=> intr_to_proc,
		inta			=> inta_to_io
		);
		
	CIO : controladores_IO port map (
		boot 		=> SW(9),
		CloCK_50 	=> CLOCK_50,
		addr_io 	=> addr_io_to_io,
		wr_io 		=> wr_io_to_io,
		rd_io 		=> rd_io_to_io,
		wr_out 		=> wr_out_to_io,
		rd_in 		=> rd_in_to_io,
		led_verdes	=> LEDG,
		led_rojos 	=> LEDR,
		SW 			=> SW(8 downto 0),
		HEX0 		=> HEX0,
		HEX1 		=> HEX1,
		HEX2 		=> HEX2,
		HEX3 		=> HEX3,
		KEY 		=> KEY,
		PS2_CLK 	=> PS2_CLK,
		PS2_DATA 	=> PS2_DAT,
		intr		=> intr_to_proc,
		inta			=> inta_to_io
		);	
	
	Display : vga_controller port map(
		clk_50mhz      	=> CLOCK_50,		-- system clock signal
		reset          	=> SW(9),			-- system reset
		red_out        	=> VGA_R,			-- vga red pixel value
		green_out      	=> VGA_G,		-- vga green pixel value
		blue_out       	=> VGA_B,		-- vga blue pixel value
		horiz_sync_out 	=> VGA_HS,	-- vga control signal
		vert_sync_out  	=> VGA_VS,	-- vga control signal
		--
		addr_vga		=> addr_mem_to_vga, 
		we      		=> we_mem_to_vga, 
		wr_data 		=> wr_data_mem_to_vga, 
		rd_data 		=> rd_data_vga_to_mem, 
		byte_m  		=> byte_m_mem_to_vga,
		--
		vga_cursor      	=> vga_cursor_dummy,
		vga_cursor_enable	=> vga_cursor_enable_dummy
		);

END Structure;