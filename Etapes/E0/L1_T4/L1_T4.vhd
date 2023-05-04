LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY L1_T4 IS
 PORT( SW : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
 KEY : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
 LEDR : OUT STD_LOGIC_VECTOR(0 DOWNTO 0));
END L1_T4;
ARCHITECTURE Structure OF L1_T4 IS
BEGIN
	process(SW) begin
			case SW is
				when "00" => LEDR(0) <= KEY(0);
				when "01" => LEDR(0) <= KEY(1);
				when "10" => LEDR(0) <= KEY(2);
				when others => LEDR(0) <= KEY(3);
			end case;
	end process;

END Structure;