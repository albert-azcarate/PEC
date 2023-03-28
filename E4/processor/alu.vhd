LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all; 
use ieee.numeric_std.all;
use work.all;
use work.op_code.all;
use work.f_code.all;

ENTITY alu IS
    PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          op : IN  op_code_t;
          f  : IN  f_code_t;
          w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		  z  : OUT std_logic);
END alu;


ARCHITECTURE Structure OF alu IS

signal movhi_signal : std_logic_vector (15 downto 0) := (others => '0');
signal ext_signe : std_logic_vector (15 downto 0) := (others => '0');
constant true : std_logic_vector (15 downto 0) := "0000000000000001";
constant false : std_logic_vector (15 downto 0) := (others => '0');
signal mul : std_logic_vector (31 downto 0) := (others => '0');
signal mulu : std_logic_vector (31 downto 0) := (others => '0');
signal w_temporal :  std_logic_vector (15 downto 0);
signal shift: integer;

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
	z <= '0' when y = "0" else '1';
	
	-- Depen de quina OP i F seleccionem la sortida
	w_temporal <= 	x and y 	when op = AL and f = AND_OP else	--AND
					x or y 	when op = AL and f = OR_OP else			--OR
					x xor y 	when op = AL and f = XOR_OP else	--XOR
					not x 	when op = AL and f = NOT_OP else		--NOT
					x + y 	when op = AL and f = ADD_OP else		--ADD
					x - y 	when op = AL and f = SUB_OP else		--SUB
					
					mul(15 downto 0) 	when op = MULDIV and f = MUL_OP else	--MUL
					mul(31 downto 16) when op = MULDIV and f = MULH_OP else		--MULH
					mulu(31 downto 16) when op = MULDIV and f = MULHU_OP else	--MULHU
					
					std_logic_vector(signed(x) / signed(y)) 	when op = MULDIV and f = DIV_OP else	-- DIV
					std_logic_vector(unsigned(x) / unsigned(y))	when op = MULDIV and f = DIVU_OP else	-- DIVU
				
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
					
					-- REVISAR
					(others => 'X') when op = BZ else 	--BZ's son saltos relativos de [-256,255]--por lo que entiendo la dirección de salto viene de la ram
					x when op = JMP else 				--JMP's son salto absolutos de 16bits
					
					ext_signe 	 when op = MOVE and f = MOVI else	-- MOVI
					movhi_signal when op = MOVE and f = MOVHI else  -- MOVHI
					
					x + y when op = ST or op = LD or op = STB or op = LDB or op = ADDI else		-- LDs, STs ADDi
					
					(others => 'Z');
				
	w <= w_temporal;
	
END Structure;