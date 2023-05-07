library ieee;
USE ieee.std_logic_1164.all;
use work.exc_code.all;

entity exc is
	port(	clk 		: IN  STD_LOGIC;
			boot		: IN  STD_LOGIC;
			no_al		: IN  STD_LOGIC;
			ill_ins		: IN  STD_LOGIC;
			interrupt	: IN  STD_LOGIC;
			div_z		: IN  STD_LOGIC;
			exc_code	: OUT exc_code_t
			);
end entity;

architecture Structure of exc is

signal exc_code_b : exc_code_t := no_exc_c;

begin

	
	exc_code_b <=	ill_ins_c 	when ill_ins 	= '1' else
				no_al_c 		when no_al 		= '1' else
				--ovf_f_c		when ovf_f 		= '1' else
				--div_z_f_c 	when div_z_f 	= '1' else
				div_z_c 		when div_z 		= '1' else
				--no_exc_c		when no_exc 	= '1' else
				--m_tlb_i_c 	when m_tlb_i 	= '1' else
				--m_tlb_d_c 	when m_tlb_d 	= '1' else
				--i_tlb_i_c 	when i_tlb_i 	= '1' else
				--i_tlb_d_c 	when i_tlb_d 	= '1' else
				--pp_tlb_i_c 	when pp_tlb_i 	= '1' else
				--pp_tlb_d_c 	when pp_tlb_d 	= '1' else
				--lec_tlb_c 	when lec_tlb 	= '1' else
				--protec_c		when protec 	= '1' else
				--call_c 		when call 		= '1' else
				--interrupt_c		when interrupt 	= '1' else
				no_exc_c;

	--process (clk, exc_code_b) begin
	--	if boot = '1' then
	--		exc_code <= no_exc_c;
	--	else
	--		if exc_code_b /= no_exc_c then
	--			exc_code <= exc_code_b;
	--		end if;
	--	end if;
	--end process;



end Structure;