LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all; 
use ieee.numeric_std.all;

use work.op_code.all;
use work.f_code.all;


ENTITY alu_fp_muldiv IS
    PORT (	x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			w_mul  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			w_div  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			div_z_f	: OUT std_logic;
			ovf_f_mul : OUT std_logic;
			ovf_f_div : OUT std_logic
		  );
END alu_fp_muldiv;


ARCHITECTURE Structure OF alu_fp_muldiv IS
begin
	
	-- divisio entre 0 en float
	div_z_f <= '1' when y(14 downto 0) = 0 else '0';
	
	-- MULTIPLICACIO

	process(x,y)
			variable x_mantissa : STD_LOGIC_VECTOR (8 downto 0);
			variable x_exponent : STD_LOGIC_VECTOR (5 downto 0);
			variable x_sign : STD_LOGIC;
			variable y_mantissa : STD_LOGIC_VECTOR (8 downto 0);
			variable y_exponent : STD_LOGIC_VECTOR (5 downto 0);
			variable y_sign : STD_LOGIC;
			variable f_mantissa : STD_LOGIC_VECTOR (8 downto 0);
			variable f_exponent : STD_LOGIC_VECTOR (5 downto 0);
			variable f_sign : STD_LOGIC;
			variable aux : STD_LOGIC;
			variable aux2 : STD_LOGIC_VECTOR (19 downto 0);
			variable exponent_sum : STD_LOGIC_VECTOR (6 downto 0);
		begin
			x_mantissa := x(8 downto 0);
			x_exponent := x(14 downto 9);
			x_sign := x(15);
			y_mantissa := y(8 downto 0);
			y_exponent := y(14 downto 9);
			y_sign := y(15);
			ovf_f_mul <= '0';
		
			-- inf*0 is not tested (result would be NaN)
			if (x_exponent=63 or y_exponent=63) then 
			-- inf*x or x*inf
				f_exponent := "111111";
				f_mantissa := (others => '0');
				f_sign := x_sign xor y_sign;
				ovf_f_mul <= '1';
				
			elsif (x_exponent=0 or y_exponent=0) then 
			-- 0*x or x*0
				f_exponent := (others => '0');
				f_mantissa := (others => '0');
				f_sign := '0';
			else
				
				aux2 := ('1' & x_mantissa) * ('1' & y_mantissa);
				-- args in Q23 result in Q46
				if (aux2(19)='1') then 
					-- >=2, shift left and add one to exponent
					f_mantissa := aux2(18 downto 10) + aux2(9); -- with rounding
					aux := '1';
				else
					f_mantissa := aux2(17 downto 9) + aux2(8); -- with rounding
					aux := '0';
				end if;
				
				-- calculate exponent
				exponent_sum := ('0' & x_exponent) + ('0' & y_exponent) + aux - 31;
				
				if (exponent_sum(6)='1') then 
					if (exponent_sum(5)='0') then -- overflow
						f_exponent := "111111";
						f_mantissa := (others => '0');
						f_sign := x_sign xor y_sign;
						ovf_f_mul <= '1';
					else 									-- underflow
						f_exponent := (others => '0');
						f_mantissa := (others => '0');
						f_sign := '0';
					end if;
				else								  		 -- Ok
					f_exponent := exponent_sum(5 downto 0);
					f_sign := x_sign xor y_sign;
				end if;
			end if;
			

			w_mul(8 downto 0) <= f_mantissa;
			w_mul(14 downto 9) <= f_exponent;
			w_mul(15) <= f_sign;
		end process;
		
		
	-- DIVISIO	
			
		process(x,y)
			variable x_mantissa : STD_LOGIC_VECTOR (8 downto 0);
			variable x_exponent : STD_LOGIC_VECTOR (5 downto 0);
			variable x_sign : STD_LOGIC;
			variable y_mantissa : STD_LOGIC_VECTOR (8 downto 0);
			variable y_exponent : STD_LOGIC_VECTOR (5 downto 0);
			variable y_sign : STD_LOGIC;
			variable f_mantissa : STD_LOGIC_VECTOR (8 downto 0);
			variable f_exponent : STD_LOGIC_VECTOR (5 downto 0);
			variable f_sign : STD_LOGIC;

			variable a : STD_LOGIC_VECTOR (11 downto 0);
			-- holds the result of the division of the mantissas
			-- a = a0.a-1a-2a-3... a<2 e a>1/2
			-- 0 to -23 if a0=1 and -1 to -24 if a0=0. a-25 to round.

			variable partial_remainder : STD_LOGIC_VECTOR (10 downto 0);
			-- the partial remainder requires one extra bit for the shift left
			-- P = partial_remainder = xx.xxxx ... < 4
			variable tmp_remainder : STD_LOGIC_VECTOR (10 downto 0);

			variable exponent_aux : STD_LOGIC_VECTOR (6 downto 0);
			-- nine bits = 8+1 to detect underflow and overflow

		begin
			x_mantissa := x(8 downto 0);
			x_exponent := x(14 downto 9);
			x_sign := x(15);
			y_mantissa := y(8 downto 0);
			y_exponent := y(14 downto 9);
			y_sign := y(15);
			ovf_f_div <= '0';

			f_sign := x_sign xor y_sign;

			if (y_exponent="111111") then -- x/inf = 0
				f_exponent := "000000";
				f_mantissa := (others=>'0');
			else
				if (y_exponent=0 or x_exponent=63) then -- result = infinity
					-- x/0 or inf/x = inf
					f_exponent := "111111";
					f_mantissa := (others=>'0');	
					ovf_f_div <= '1';
				else
					exponent_aux := ('0' & x_exponent) - ('0' & y_exponent) + 31;

					partial_remainder := "01" & x_mantissa; -- P = 1.F1

					-- Area with a comparator: 1,851 4 input LUT
					-- Area joining comparacion and subtraction: 1,324 4 input LUT

					digit_loop: for i in 11 downto 0 loop
						tmp_remainder := partial_remainder - ("01" & y_mantissa);

						if ( tmp_remainder(10)='0' ) then
							-- result is non negative: partial_remainder >= ("01" & y_mantissa)
							-- note that tmp_remainder < 2 so bit 24 should be fero
							a(i):='1';
							partial_remainder := tmp_remainder;
						else
							a(i):='0';
						end if;

						partial_remainder := partial_remainder(9 downto 0) & '0'; -- sll
						-- P/2 < y && y < 2 => P < 4

					end loop digit_loop;

					a := a + 1; -- round

					if (a(11)='1') then -- a=1.xxxx
						f_mantissa := a(10 downto 2);
					else -- a=0.1xxxx
						f_mantissa := a(9 downto 1);
						exponent_aux := exponent_aux - 1;
					end if;

					-- z_exponent > 0-254+127-1 = -128 = 1 1000 0000 b
					-- y_exponent = 255 is infinity that was previously taken care
					-- z_exponent < 255-0+127 = 382 = 1 0111 1110 b
					if (exponent_aux(6)='1') then
						if (exponent_aux(5)='1') then -- underflow
							f_exponent := "000000";
							f_mantissa := (others=>'0');
						else -- overflow
							f_exponent := "111111";
							f_mantissa := (others=>'0');	
							ovf_f_div <= '1';
						end if;
					else
						f_exponent := exponent_aux(5 downto 0);
					end if;

				end if;
			end if;

			w_div(8 downto 0) <= f_mantissa;
			w_div(14 downto 9) <= f_exponent;
			w_div(15) <= f_sign;

		
	end process;
	
	
END Structure;
		