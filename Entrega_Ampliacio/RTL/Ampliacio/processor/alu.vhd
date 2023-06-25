LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all; 
use ieee.numeric_std.all;

use work.op_code.all;
use work.f_code.all;

ENTITY alu IS
    PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          op : IN  op_code_t;
          f  : IN  f_code_t;
		  int : IN std_logic;
		  clk_50 : IN std_logic;
		  reset_f : IN std_logic;
          w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		  z  : OUT std_logic;
		  div_z : OUT std_logic;
		  div_z_f : OUT std_logic;
		  done_add_f : OUT std_logic;
		  ovf_f : OUT std_logic
		  );
END alu;


ARCHITECTURE Structure OF alu IS

constant true		: std_logic_vector (15 downto 0) := "0000000000000001";
constant false		: std_logic_vector (15 downto 0) := (others => '0');

signal w_temporal	: std_logic_vector (15 downto 0);
signal movhi_signal	: std_logic_vector (15 downto 0) := (others => '0');
signal ext_signe	: std_logic_vector (15 downto 0) := (others => '0');
signal mul			: std_logic_vector (31 downto 0) := (others => '0');
signal mulu			: std_logic_vector (31 downto 0) := (others => '0');
signal shift		: integer;
signal floats		: std_logic_vector(15 downto 0);
signal float_div	: std_logic_vector(15 downto 0);
signal float_mul	: std_LOGIC_VECTOR(15 downto 0);
signal float_add	: std_LOGIC_VECTOR(15 downto 0);
signal y_float		: std_LOGIC_VECTOR(15 downto 0);
signal exp_x		: std_logic_vector(5 downto 0);
signal exp_y		: std_logic_vector(5 downto 0);
signal suma_exp		: std_logic_vector(5 downto 0);
signal start_f : std_LOGIC;
signal div_z_f_conn : std_LOGIC;

signal eq_f : std_logic;
signal lt_f : std_logic;
signal le_f : std_logic;


signal ovf_f_mul : std_logic;
signal ovf_f_div : std_logic;
signal ovf_f_alu : std_logic;

	component alu_fp_muldiv is 
		PORT (	x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
				y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
				w_mul  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
				w_div  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
				div_z_f	: OUT std_logic;
				ovf_f_mul : OUT std_logic;
				ovf_f_div : OUT std_logic
			  );
	end component;
	
	
	component alu_fp_cmp IS
    PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          eq  : OUT STD_LOGIC;
			 lt : OUT STD_LOGIC;
			 le: OUT STD_LOGIC
		  );
	end component;
	
	component alu_fp is
	  port(	A      : in  std_logic_vector(15 downto 0);
			B      : in  std_logic_vector(15 downto 0);
			clk    : in  std_logic;
			reset  : in  std_logic;
			start  : in  std_logic;
			done   : out std_logic;
			sum	: out std_logic_vector(15 downto 0);
			ovf_f : OUT std_logic
			);
	end component;

BEGIN
	-- shift es el N a fer shift en ca2 de y
	shift <= conv_integer( not(y(4 downto 0)) + 1);
	
	-- signals per fer movi
	ext_signe(15 downto 8) <= (others => y(7));
	ext_signe(7 downto 0) <= y(7 downto 0);
	
	-- signals per fer movhi
	movhi_signal(15 downto 8) <= y(7 downto 0);
	movhi_signal(7 downto 0) <= x(7 downto 0);
	
	-- signals per mul i mulu
	mul <= std_logic_vector(signed(x) * signed(y));
	mulu <= std_logic_vector(unsigned(x * y));
	
	-- z es un bit per saber si y es 0 o no, per fer servir en BNs i JMPs
	z <= '0' when y = x"0000" else '1';
	
	-- Indicadors de possibles excepcions
	div_z <= '1' when (op = MULDIV and y = x"0000" and (f = DIV_OP  or f = DIVU_OP)) else '0';
	div_z_f <= div_z_f_conn when (op = FLOAT and f = DIVF_OP) else '0';
	
	
	start_f <= '1' when (op = FLOAT and f = ADDF_OP) or (op = FLOAT and f = SUBF_OP) else '0';
	
	
	-- Depen de quina OP i F seleccionem la sortida
	w_temporal <= 	x and y 	when op = AL and f = AND_OP else	--AND
					x or y 	when op = AL and f = OR_OP else			--OR
					x xor y 	when op = AL and f = XOR_OP else	--XOR
					not x 	when op = AL and f = NOT_OP else		--NOT
					x + y 	when op = AL and f = ADD_OP else		--ADD
					x - y 	when op = AL and f = SUB_OP else		--SUB
					
					mul(15 downto 0) when op = MULDIV and f = MUL_OP else	--MUL
					mul(31 downto 16) when op = MULDIV and f = MULH_OP else		--MULH
					mulu(31 downto 16) when op = MULDIV and f = MULHU_OP else	--MULHU
					
					std_logic_vector(signed(x) / signed(y)) 	when op = MULDIV and f = DIV_OP and y /= "0" else	-- DIV
					(others => 'X') 							when op = MULDIV and f = DIV_OP and y = "0" else	-- DIV Excepcio /0
					std_logic_vector(unsigned(x) / unsigned(y))	when op = MULDIV and f = DIVU_OP and y /= "0" else	-- DIVU
					(others => 'X')								when op = MULDIV and f = DIVU_OP and y = "0" else	-- DIVU Excepcio /0
				
					std_logic_vector(shift_left(signed(x), conv_integer(y(4 downto 0)) )) when op = AL and f = SHA_OP and conv_integer(y(4 downto 0)) <= 15  else 	--SHA  >= 0 
					std_logic_vector(shift_left(unsigned(x), conv_integer(y(4 downto 0)) )) when op = AL and f = SHL_OP and conv_integer(y(4 downto 0)) <= 15 else 	--SHL  >= 0
					
					std_logic_vector(shift_right(signed(x), shift)) when op = AL and f = SHA_OP else	--SHA  < 0
					std_logic_vector(shift_right(unsigned(x), shift)) when op = AL and f = SHL_OP else  --SHL  < 0
					
					true when op = COMP and f = CMPLT_OP and signed(x) < signed(y) else			-- CMPLT true
					false when op = COMP and f = CMPLT_OP and signed(x) >= signed(y) else		-- false
					
					true when op = COMP and f = CMPLE_OP and signed(x) <= signed(y) else		-- CMPLE true
					false when op = COMP and f = CMPLE_OP and signed(x) > signed(y) else        -- false
					
					true when op = COMP and f = CMPEQ_OP and signed(x) = signed(y) else			-- CMPLEQ true
					false when op = COMP and f = CMPEQ_OP and signed(x) /= signed(y) else       -- false
					
					true when op = COMP and f = CMPLTU_OP and unsigned(x) < unsigned(y) else	-- CMPLTU true
					false when op = COMP and f = CMPLTU_OP and unsigned(x) >= unsigned(y) else  -- false
					
					true when op = COMP and f = CMPLEU_OP and unsigned(x) <= unsigned(y) else	-- CMPLEU true
					false when op = COMP and f = CMPLEU_OP and unsigned(x) > unsigned(y) else   -- false
					
					(others => 'X') when op = BZ else 	--BZ's son saltos relativos de [-256,255]--por lo que entiendo la direccion de salto viene de la ram
					x when op = JMP else 				--JMP's son salto absolutos de 16bits
					x when op = IO else
					ext_signe 	 when op = MOVE and f = MOVI else	-- MOVI
					movhi_signal when op = MOVE and f = MOVHI else  -- MOVHI
					
					x + y when op = ST or op = LD or op = STB or op = LDB else		-- LDs, STs
					
					x + y when op = STF or op = LDF else		-- LDF, STF
					
					x + y when op = ADDI else
					
					
					float_mul when op = FLOAT and f = MULF_OP else
					float_div when op = FLOAT and f = DIVF_OP else
					
					true when op = FLOAT and f = CMPEQF_OP and eq_f = '1' else
					false when op = FLOAT and f = CMPEQF_OP and eq_f = '0' else
					
					true when op = FLOAT and f = CMPLTF_OP and lt_f = '1' else
					false when op = FLOAT and f = CMPLTF_OP and lt_f = '0' else
					
					true when op = FLOAT and f = CMPLEF_OP and le_f = '1' else
					false when op = FLOAT and f = CMPLEF_OP and le_f = '0' else
					
					float_add when op = FLOAT and f = ADDF_OP else
					float_add when op = FLOAT and f = SUBF_OP else
					
					-- En RETI treurem X, ens entra el Pc antic
					x when op = HALT else
					
					
					(others => 'Z');
					
	-- En RETI treurem X, ens entra el Pc antic
	w <= w_temporal when int = '0' else x;	
	
	
	y_float(15) <= not y(15) when op = FLOAT and f = SUBF_OP else y(15);
	y_float(14 downto 0) <= y(14 downto 0);
	
	
	ovf_f <= ovf_f_alu when op = FLOAT and (f = SUBF_OP or f = ADDF_OP) else
				ovf_f_mul when op = FLOAT and f = MULF_OP else
				ovf_f_div when op = FLOAT and f = DIVF_OP else
				'0';
	
	alu_fp_md : alu_fp_muldiv port map(
			x	=> x,
			y	=> y,
			w_mul	=> float_mul,
			w_div => float_div,
			div_z_f => div_z_f_conn,
			ovf_f_mul => ovf_f_mul,
			ovf_f_div => ovf_f_div
			);

	alu_fp_cmp0 : alu_fp_cmp port map(
			x	=> x,
			y	=> y,
			eq	=> eq_f,
			lt => lt_f,
			le => le_f
			);

	alu_adde : alu_fp port map(
			A => x,						-- s'inicia la operacio amb un start
			B => y_float,						-- quan done val 1 a sum tenim a + b
			clk => clk_50,
			reset => reset_f,
			start => start_f,
			done => done_add_f,
			sum => float_add,
			ovf_f => ovf_f_alu
			);
	
	
	
END Structure;