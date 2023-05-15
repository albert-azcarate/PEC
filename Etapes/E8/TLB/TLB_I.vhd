--TLB

library ieee;
use ieee.std_logic_1164.all;

package TLB_entry is
	type TLB_array_t is array (0 to 7) of std_logic_vector (3 downto 0);
  --type io_array_t is array (0 to 255) of std_logic_vector (15 downto 0);
end package;

package body TLB_entry is
end package body;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all; --Esta libreria sera necesaria si usais conversiones CONV_INTEGER
USE ieee.numeric_std.all;        --Esta libreria sera necesaria si usais conversiones TO_INTEGER
use work.TLB_entry.all;

ENTITY TLB_I IS
	PORT ( 	boot 			: in   std_logic;
			wr_addr_tlb		: in  std_logic_vector(2 downto 0);
			CLOCK		 	: in  std_logic;
			wre_IV			: in  std_logic;	
			wre_IP			: in  std_logic;			
			vtag_tlb		: in  std_logic_vector(3 downto 0);
			ptag_tlb		: out std_logic_vector(3 downto 0);
			valid			: out std_logic;
			miss_I 			: out std_logic;
			rd_only			: out std_logic		
			);
END TLB_I;


ARCHITECTURE Structure OF TLB_I IS
	signal VTags : TLB_array_t:= (others => (others => '0'));
	signal PTags : TLB_array_t:= (others => (others => '0'));
	signal bits : array (0 to 7) of std_logic_vector( 1 downto 0);
	signal adress_reg	: integer;
	
BEGIN
	
	--adress_reg <= conv_integer(vtag_tl);
	
	adress_reg <= 	0	when vtag_tlb = VTags(0) else
					1	when vtag_tlb = VTags(1) else
					2	when vtag_tlb = VTags(2) else
					3	when vtag_tlb = VTags(3) else
					4	when vtag_tlb = VTags(4) else
					5	when vtag_tlb = VTags(5) else
					6	when vtag_tlb = VTags(6) else
					7	when vtag_tlb = VTags(7) else
					-1;
	
	miss_I <= '1' when adress_reg = -1 else '0'; 
						
	ptag_tlb <= PTags(adress_reg) when  adress_reg /= -1 else (others => '0');
	valid <= bits(adress_reg)(1);
	rd_only <= bits(adress_reg)(0);
	
	process (boot, CLOCK) begin
		if rising_edge(CLOCK) then
			if boot = '1' then
				--sys addr hardcoded
			else 
				if wre_IP = '1' then 
					
				elsif wre_IV = '1' then
				
				end if;
			end if;
		end if;
	end process;

	

END Structure;