library ieee;
USE ieee.std_logic_1164.all;
use work.exc_code.all;

entity exc is
	port(	clk 		: IN  STD_LOGIC;
			boot		: IN  STD_LOGIC;
			no_al		: IN  STD_LOGIC;--
			ill_ins		: IN  STD_LOGIC;--
			interrupt	: IN  STD_LOGIC;--
			div_z		: IN  STD_LOGIC;--
			acces_mem	: IN  STD_LOGIC;--
			pp_tlb_d 	: IN  STD_LOGIC;--
			protect 	: IN  STD_LOGIC;		--
			call		: IN  STD_LOGIC;		 --
			exc_code	: OUT exc_code_t
			);
end entity;

architecture Structure of exc is

signal exc_code_b : exc_code_t := no_exc_c;

begin

	
	exc_code <=	ill_ins_c 		when ill_ins 	= '1' else 						--0
				no_al_c 		when no_al 		= '1' and acces_mem = '1' else	--1
				--ovf_f_c		when ovf_f 		= '1' else						--2
				--div_z_f_c 	when div_z_f 	= '1' else						--3
				div_z_c 		when div_z 		= '1' else							--4
				--no_exc_c		when no_exc 	= '1' else						--5
				--m_tlb_i_c 	when m_tlb_i 	= '1' else						--6
				--m_tlb_d_c 	when m_tlb_d 	= '1' else						--7
				--i_tlb_i_c 	when i_tlb_i 	= '1' else						--8
				--i_tlb_d_c 	when i_tlb_d 	= '1' else						--9
				--pp_tlb_i_c 	when pp_tlb_i 	= '1' else						--10
				pp_tlb_d_c 		when pp_tlb_d 	= '1' else 						--11
				--lec_tlb_c 	when lec_tlb 	= '1' else 						--12
				protec_c		when protect 	= '1' else 						--13
				call_c 			when call 		= '1' else 						--14
				--interrupt_c		when interrupt 	= '1' else					--15
				no_exc_c;




end Structure;