-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- VENDOR "Altera"
-- PROGRAM "Quartus II 64-Bit"
-- VERSION "Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Web Edition"

-- DATE "02/25/2023 23:32:19"

-- 
-- Device: Altera EP2C20F484C7 Package FBGA484
-- 

-- 
-- This VHDL file should be used for ModelSim-Altera (VHDL) only
-- 

LIBRARY CYCLONEII;
LIBRARY IEEE;
USE CYCLONEII.CYCLONEII_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	Morse IS
    PORT (
	CLOCK_50 : IN std_logic;
	SW : IN std_logic_vector(2 DOWNTO 0);
	KEY : IN std_logic_vector(1 DOWNTO 0);
	LEDR : OUT std_logic_vector(0 DOWNTO 0);
	LEDG : OUT std_logic_vector(0 DOWNTO 0);
	HEX0 : OUT std_logic_vector(6 DOWNTO 0)
	);
END Morse;

-- Design Ports Information
-- LEDR[0]	=>  Location: PIN_R20,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- LEDG[0]	=>  Location: PIN_U22,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- HEX0[0]	=>  Location: PIN_J2,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- HEX0[1]	=>  Location: PIN_J1,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- HEX0[2]	=>  Location: PIN_H2,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- HEX0[3]	=>  Location: PIN_H1,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- HEX0[4]	=>  Location: PIN_F2,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- HEX0[5]	=>  Location: PIN_F1,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- HEX0[6]	=>  Location: PIN_E2,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- SW[2]	=>  Location: PIN_M22,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- SW[1]	=>  Location: PIN_L21,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- SW[0]	=>  Location: PIN_L22,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- KEY[0]	=>  Location: PIN_R22,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- KEY[1]	=>  Location: PIN_R21,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- CLOCK_50	=>  Location: PIN_L1,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default


ARCHITECTURE structure OF Morse IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_CLOCK_50 : std_logic;
SIGNAL ww_SW : std_logic_vector(2 DOWNTO 0);
SIGNAL ww_KEY : std_logic_vector(1 DOWNTO 0);
SIGNAL ww_LEDR : std_logic_vector(0 DOWNTO 0);
SIGNAL ww_LEDG : std_logic_vector(0 DOWNTO 0);
SIGNAL ww_HEX0 : std_logic_vector(6 DOWNTO 0);
SIGNAL \clock_counter|internal_clock~clkctrl_INCLK_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \CLOCK_50~clkctrl_INCLK_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \clock_counter|Add0~0_combout\ : std_logic;
SIGNAL \clock_counter|Add0~1\ : std_logic;
SIGNAL \clock_counter|Add0~2_combout\ : std_logic;
SIGNAL \clock_counter|Add0~3\ : std_logic;
SIGNAL \clock_counter|Add0~4_combout\ : std_logic;
SIGNAL \clock_counter|Add0~5\ : std_logic;
SIGNAL \clock_counter|Add0~6_combout\ : std_logic;
SIGNAL \clock_counter|Add0~7\ : std_logic;
SIGNAL \clock_counter|Add0~8_combout\ : std_logic;
SIGNAL \clock_counter|Add0~9\ : std_logic;
SIGNAL \clock_counter|Add0~10_combout\ : std_logic;
SIGNAL \clock_counter|Add0~11\ : std_logic;
SIGNAL \clock_counter|Add0~12_combout\ : std_logic;
SIGNAL \clock_counter|Add0~13\ : std_logic;
SIGNAL \clock_counter|Add0~14_combout\ : std_logic;
SIGNAL \clock_counter|Add0~15\ : std_logic;
SIGNAL \clock_counter|Add0~16_combout\ : std_logic;
SIGNAL \clock_counter|Add0~17\ : std_logic;
SIGNAL \clock_counter|Add0~18_combout\ : std_logic;
SIGNAL \clock_counter|Add0~19\ : std_logic;
SIGNAL \clock_counter|Add0~20_combout\ : std_logic;
SIGNAL \clock_counter|Add0~21\ : std_logic;
SIGNAL \clock_counter|Add0~22_combout\ : std_logic;
SIGNAL \clock_counter|Add0~23\ : std_logic;
SIGNAL \clock_counter|Add0~24_combout\ : std_logic;
SIGNAL \clock_counter|Add0~25\ : std_logic;
SIGNAL \clock_counter|Add0~26_combout\ : std_logic;
SIGNAL \clock_counter|Add0~27\ : std_logic;
SIGNAL \clock_counter|Add0~28_combout\ : std_logic;
SIGNAL \clock_counter|Add0~29\ : std_logic;
SIGNAL \clock_counter|Add0~30_combout\ : std_logic;
SIGNAL \clock_counter|Add0~31\ : std_logic;
SIGNAL \clock_counter|Add0~32_combout\ : std_logic;
SIGNAL \clock_counter|Add0~33\ : std_logic;
SIGNAL \clock_counter|Add0~34_combout\ : std_logic;
SIGNAL \clock_counter|Add0~35\ : std_logic;
SIGNAL \clock_counter|Add0~36_combout\ : std_logic;
SIGNAL \clock_counter|Add0~37\ : std_logic;
SIGNAL \clock_counter|Add0~38_combout\ : std_logic;
SIGNAL \clock_counter|Add0~39\ : std_logic;
SIGNAL \clock_counter|Add0~40_combout\ : std_logic;
SIGNAL \clock_counter|Add0~41\ : std_logic;
SIGNAL \clock_counter|Add0~42_combout\ : std_logic;
SIGNAL \clock_counter|Add0~43\ : std_logic;
SIGNAL \clock_counter|Add0~44_combout\ : std_logic;
SIGNAL \clock_counter|Add0~45\ : std_logic;
SIGNAL \clock_counter|Add0~46_combout\ : std_logic;
SIGNAL \clock_counter|Add0~47\ : std_logic;
SIGNAL \clock_counter|Add0~48_combout\ : std_logic;
SIGNAL \clock_counter|Add0~49\ : std_logic;
SIGNAL \clock_counter|Add0~50_combout\ : std_logic;
SIGNAL \clock_counter|Add0~51\ : std_logic;
SIGNAL \clock_counter|Add0~52_combout\ : std_logic;
SIGNAL \clock_counter|Add0~53\ : std_logic;
SIGNAL \clock_counter|Add0~54_combout\ : std_logic;
SIGNAL \clock_counter|Add0~55\ : std_logic;
SIGNAL \clock_counter|Add0~56_combout\ : std_logic;
SIGNAL \clock_counter|Add0~57\ : std_logic;
SIGNAL \clock_counter|Add0~58_combout\ : std_logic;
SIGNAL \clock_counter|Add0~59\ : std_logic;
SIGNAL \clock_counter|Add0~60_combout\ : std_logic;
SIGNAL \clock_counter|Add0~61\ : std_logic;
SIGNAL \clock_counter|Add0~62_combout\ : std_logic;
SIGNAL \clock_counter|Equal0~0_combout\ : std_logic;
SIGNAL \clock_counter|Equal0~1_combout\ : std_logic;
SIGNAL \clock_counter|Equal0~2_combout\ : std_logic;
SIGNAL \clock_counter|Equal0~3_combout\ : std_logic;
SIGNAL \clock_counter|Equal0~4_combout\ : std_logic;
SIGNAL \clock_counter|Equal0~5_combout\ : std_logic;
SIGNAL \clock_counter|Equal0~6_combout\ : std_logic;
SIGNAL \clock_counter|Equal0~7_combout\ : std_logic;
SIGNAL \clock_counter|Equal0~8_combout\ : std_logic;
SIGNAL \clock_counter|Equal0~9_combout\ : std_logic;
SIGNAL \clock_counter|Equal0~10_combout\ : std_logic;
SIGNAL \clock_counter|clock_count~0_combout\ : std_logic;
SIGNAL \clock_counter|clock_count~1_combout\ : std_logic;
SIGNAL \clock_counter|clock_count~2_combout\ : std_logic;
SIGNAL \clock_counter|clock_count~3_combout\ : std_logic;
SIGNAL \clock_counter|clock_count~4_combout\ : std_logic;
SIGNAL \clock_counter|clock_count~5_combout\ : std_logic;
SIGNAL \clock_counter|clock_count~6_combout\ : std_logic;
SIGNAL \clock_counter|clock_count~7_combout\ : std_logic;
SIGNAL \clock_counter|clock_count~8_combout\ : std_logic;
SIGNAL \clock_counter|clock_count~9_combout\ : std_logic;
SIGNAL \clock_counter|clock_count~10_combout\ : std_logic;
SIGNAL \clock_counter|clock_count~11_combout\ : std_logic;
SIGNAL \clock_counter|clock_count~12_combout\ : std_logic;
SIGNAL \clock_counter|clock_count~13_combout\ : std_logic;
SIGNAL \clock_counter|clock_count~14_combout\ : std_logic;
SIGNAL \clock_counter|clock_count~15_combout\ : std_logic;
SIGNAL \clock_counter|clock_count~16_combout\ : std_logic;
SIGNAL \clock_counter|clock_count~17_combout\ : std_logic;
SIGNAL \clock_counter|clock_count~18_combout\ : std_logic;
SIGNAL \clock_counter|clock_count~19_combout\ : std_logic;
SIGNAL \clock_counter|clock_count[5]~20_combout\ : std_logic;
SIGNAL \clock_counter|clock_count[10]~21_combout\ : std_logic;
SIGNAL \clock_counter|clock_count[11]~22_combout\ : std_logic;
SIGNAL \clock_counter|clock_count[12]~23_combout\ : std_logic;
SIGNAL \clock_counter|clock_count[13]~24_combout\ : std_logic;
SIGNAL \clock_counter|clock_count[15]~25_combout\ : std_logic;
SIGNAL \clock_counter|clock_count[17]~26_combout\ : std_logic;
SIGNAL \clock_counter|clock_count[18]~27_combout\ : std_logic;
SIGNAL \clock_counter|clock_count[19]~28_combout\ : std_logic;
SIGNAL \clock_counter|clock_count[20]~29_combout\ : std_logic;
SIGNAL \clock_counter|clock_count[21]~30_combout\ : std_logic;
SIGNAL \clock_counter|clock_count[23]~31_combout\ : std_logic;
SIGNAL \CLOCK_50~combout\ : std_logic;
SIGNAL \CLOCK_50~clkctrl_outclk\ : std_logic;
SIGNAL \clock_counter|internal_clock~0_combout\ : std_logic;
SIGNAL \clock_counter|internal_clock~regout\ : std_logic;
SIGNAL \clock_counter|internal_clock~clkctrl_outclk\ : std_logic;
SIGNAL \reset_morse~feeder_combout\ : std_logic;
SIGNAL \reset_morse~regout\ : std_logic;
SIGNAL \segment|Mux2~1_combout\ : std_logic;
SIGNAL \segment|Mux3~1_combout\ : std_logic;
SIGNAL \conv_morse|next_caracter[12]~13_combout\ : std_logic;
SIGNAL \px_estat~0_combout\ : std_logic;
SIGNAL \px_estat~1_combout\ : std_logic;
SIGNAL \inici_morse~0_combout\ : std_logic;
SIGNAL \inici_morse~regout\ : std_logic;
SIGNAL \conv_morse|caracter_reg[2]~9_combout\ : std_logic;
SIGNAL \conv_morse|caracter_reg[3]~8_combout\ : std_logic;
SIGNAL \conv_morse|caracter_reg[4]~7_combout\ : std_logic;
SIGNAL \conv_morse|caracter_reg[5]~6_combout\ : std_logic;
SIGNAL \conv_morse|caracter_reg[6]~5_combout\ : std_logic;
SIGNAL \conv_morse|caracter_reg[7]~3_combout\ : std_logic;
SIGNAL \conv_morse|caracter_reg[7]~4_combout\ : std_logic;
SIGNAL \conv_morse|caracter_reg[8]~2_combout\ : std_logic;
SIGNAL \conv_morse|caracter_reg[9]~1_combout\ : std_logic;
SIGNAL \conv_morse|caracter_reg[10]~0_combout\ : std_logic;
SIGNAL \conv_morse|next_puls~0_combout\ : std_logic;
SIGNAL \LEDG~0_combout\ : std_logic;
SIGNAL \segment|Mux6~0_combout\ : std_logic;
SIGNAL \segment|Mux5~0_combout\ : std_logic;
SIGNAL \segment|Mux4~0_combout\ : std_logic;
SIGNAL \segment|Mux3~0_combout\ : std_logic;
SIGNAL \segment|Mux2~0_combout\ : std_logic;
SIGNAL \segment|Mux1~0_combout\ : std_logic;
SIGNAL \segment|Mux0~0_combout\ : std_logic;
SIGNAL \SW~combout\ : std_logic_vector(2 DOWNTO 0);
SIGNAL \KEY~combout\ : std_logic_vector(1 DOWNTO 0);
SIGNAL \conv_morse|next_caracter\ : std_logic_vector(12 DOWNTO 0);
SIGNAL \clock_counter|clock_count\ : std_logic_vector(31 DOWNTO 0);
SIGNAL \conv_morse|next_puls\ : std_logic_vector(0 DOWNTO 0);
SIGNAL px_estat : std_logic_vector(1 DOWNTO 0);
SIGNAL \ALT_INV_inici_morse~regout\ : std_logic;
SIGNAL \segment|ALT_INV_Mux6~0_combout\ : std_logic;
SIGNAL \ALT_INV_LEDG~0_combout\ : std_logic;

BEGIN

ww_CLOCK_50 <= CLOCK_50;
ww_SW <= SW;
ww_KEY <= KEY;
LEDR <= ww_LEDR;
LEDG <= ww_LEDG;
HEX0 <= ww_HEX0;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;

\clock_counter|internal_clock~clkctrl_INCLK_bus\ <= (gnd & gnd & gnd & \clock_counter|internal_clock~regout\);

\CLOCK_50~clkctrl_INCLK_bus\ <= (gnd & gnd & gnd & \CLOCK_50~combout\);
\ALT_INV_inici_morse~regout\ <= NOT \inici_morse~regout\;
\segment|ALT_INV_Mux6~0_combout\ <= NOT \segment|Mux6~0_combout\;
\ALT_INV_LEDG~0_combout\ <= NOT \LEDG~0_combout\;

-- Location: LCCOMB_X25_Y14_N0
\clock_counter|Add0~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|Add0~0_combout\ = \clock_counter|clock_count\(0) $ (VCC)
-- \clock_counter|Add0~1\ = CARRY(\clock_counter|clock_count\(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001111001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \clock_counter|clock_count\(0),
	datad => VCC,
	combout => \clock_counter|Add0~0_combout\,
	cout => \clock_counter|Add0~1\);

-- Location: LCCOMB_X25_Y14_N2
\clock_counter|Add0~2\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|Add0~2_combout\ = (\clock_counter|clock_count\(1) & (\clock_counter|Add0~1\ & VCC)) # (!\clock_counter|clock_count\(1) & (!\clock_counter|Add0~1\))
-- \clock_counter|Add0~3\ = CARRY((!\clock_counter|clock_count\(1) & !\clock_counter|Add0~1\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100000011",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \clock_counter|clock_count\(1),
	datad => VCC,
	cin => \clock_counter|Add0~1\,
	combout => \clock_counter|Add0~2_combout\,
	cout => \clock_counter|Add0~3\);

-- Location: LCCOMB_X25_Y14_N4
\clock_counter|Add0~4\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|Add0~4_combout\ = (\clock_counter|clock_count\(2) & ((GND) # (!\clock_counter|Add0~3\))) # (!\clock_counter|clock_count\(2) & (\clock_counter|Add0~3\ $ (GND)))
-- \clock_counter|Add0~5\ = CARRY((\clock_counter|clock_count\(2)) # (!\clock_counter|Add0~3\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110011001111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \clock_counter|clock_count\(2),
	datad => VCC,
	cin => \clock_counter|Add0~3\,
	combout => \clock_counter|Add0~4_combout\,
	cout => \clock_counter|Add0~5\);

-- Location: LCCOMB_X25_Y14_N6
\clock_counter|Add0~6\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|Add0~6_combout\ = (\clock_counter|clock_count\(3) & (\clock_counter|Add0~5\ & VCC)) # (!\clock_counter|clock_count\(3) & (!\clock_counter|Add0~5\))
-- \clock_counter|Add0~7\ = CARRY((!\clock_counter|clock_count\(3) & !\clock_counter|Add0~5\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100000011",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \clock_counter|clock_count\(3),
	datad => VCC,
	cin => \clock_counter|Add0~5\,
	combout => \clock_counter|Add0~6_combout\,
	cout => \clock_counter|Add0~7\);

-- Location: LCCOMB_X25_Y14_N8
\clock_counter|Add0~8\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|Add0~8_combout\ = (\clock_counter|clock_count\(4) & ((GND) # (!\clock_counter|Add0~7\))) # (!\clock_counter|clock_count\(4) & (\clock_counter|Add0~7\ $ (GND)))
-- \clock_counter|Add0~9\ = CARRY((\clock_counter|clock_count\(4)) # (!\clock_counter|Add0~7\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110011001111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \clock_counter|clock_count\(4),
	datad => VCC,
	cin => \clock_counter|Add0~7\,
	combout => \clock_counter|Add0~8_combout\,
	cout => \clock_counter|Add0~9\);

-- Location: LCCOMB_X25_Y14_N10
\clock_counter|Add0~10\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|Add0~10_combout\ = (\clock_counter|clock_count\(5) & (!\clock_counter|Add0~9\)) # (!\clock_counter|clock_count\(5) & (\clock_counter|Add0~9\ & VCC))
-- \clock_counter|Add0~11\ = CARRY((\clock_counter|clock_count\(5) & !\clock_counter|Add0~9\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \clock_counter|clock_count\(5),
	datad => VCC,
	cin => \clock_counter|Add0~9\,
	combout => \clock_counter|Add0~10_combout\,
	cout => \clock_counter|Add0~11\);

-- Location: LCCOMB_X25_Y14_N12
\clock_counter|Add0~12\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|Add0~12_combout\ = (\clock_counter|clock_count\(6) & ((GND) # (!\clock_counter|Add0~11\))) # (!\clock_counter|clock_count\(6) & (\clock_counter|Add0~11\ $ (GND)))
-- \clock_counter|Add0~13\ = CARRY((\clock_counter|clock_count\(6)) # (!\clock_counter|Add0~11\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110011001111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \clock_counter|clock_count\(6),
	datad => VCC,
	cin => \clock_counter|Add0~11\,
	combout => \clock_counter|Add0~12_combout\,
	cout => \clock_counter|Add0~13\);

-- Location: LCCOMB_X25_Y14_N14
\clock_counter|Add0~14\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|Add0~14_combout\ = (\clock_counter|clock_count\(7) & (\clock_counter|Add0~13\ & VCC)) # (!\clock_counter|clock_count\(7) & (!\clock_counter|Add0~13\))
-- \clock_counter|Add0~15\ = CARRY((!\clock_counter|clock_count\(7) & !\clock_counter|Add0~13\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100000011",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \clock_counter|clock_count\(7),
	datad => VCC,
	cin => \clock_counter|Add0~13\,
	combout => \clock_counter|Add0~14_combout\,
	cout => \clock_counter|Add0~15\);

-- Location: LCCOMB_X25_Y14_N16
\clock_counter|Add0~16\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|Add0~16_combout\ = (\clock_counter|clock_count\(8) & ((GND) # (!\clock_counter|Add0~15\))) # (!\clock_counter|clock_count\(8) & (\clock_counter|Add0~15\ $ (GND)))
-- \clock_counter|Add0~17\ = CARRY((\clock_counter|clock_count\(8)) # (!\clock_counter|Add0~15\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110011001111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \clock_counter|clock_count\(8),
	datad => VCC,
	cin => \clock_counter|Add0~15\,
	combout => \clock_counter|Add0~16_combout\,
	cout => \clock_counter|Add0~17\);

-- Location: LCCOMB_X25_Y14_N18
\clock_counter|Add0~18\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|Add0~18_combout\ = (\clock_counter|clock_count\(9) & (\clock_counter|Add0~17\ & VCC)) # (!\clock_counter|clock_count\(9) & (!\clock_counter|Add0~17\))
-- \clock_counter|Add0~19\ = CARRY((!\clock_counter|clock_count\(9) & !\clock_counter|Add0~17\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100000011",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \clock_counter|clock_count\(9),
	datad => VCC,
	cin => \clock_counter|Add0~17\,
	combout => \clock_counter|Add0~18_combout\,
	cout => \clock_counter|Add0~19\);

-- Location: LCCOMB_X25_Y14_N20
\clock_counter|Add0~20\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|Add0~20_combout\ = (\clock_counter|clock_count\(10) & (\clock_counter|Add0~19\ $ (GND))) # (!\clock_counter|clock_count\(10) & ((GND) # (!\clock_counter|Add0~19\)))
-- \clock_counter|Add0~21\ = CARRY((!\clock_counter|Add0~19\) # (!\clock_counter|clock_count\(10)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010101011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \clock_counter|clock_count\(10),
	datad => VCC,
	cin => \clock_counter|Add0~19\,
	combout => \clock_counter|Add0~20_combout\,
	cout => \clock_counter|Add0~21\);

-- Location: LCCOMB_X25_Y14_N22
\clock_counter|Add0~22\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|Add0~22_combout\ = (\clock_counter|clock_count\(11) & (!\clock_counter|Add0~21\)) # (!\clock_counter|clock_count\(11) & (\clock_counter|Add0~21\ & VCC))
-- \clock_counter|Add0~23\ = CARRY((\clock_counter|clock_count\(11) & !\clock_counter|Add0~21\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101000001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \clock_counter|clock_count\(11),
	datad => VCC,
	cin => \clock_counter|Add0~21\,
	combout => \clock_counter|Add0~22_combout\,
	cout => \clock_counter|Add0~23\);

-- Location: LCCOMB_X25_Y14_N24
\clock_counter|Add0~24\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|Add0~24_combout\ = (\clock_counter|clock_count\(12) & (\clock_counter|Add0~23\ $ (GND))) # (!\clock_counter|clock_count\(12) & ((GND) # (!\clock_counter|Add0~23\)))
-- \clock_counter|Add0~25\ = CARRY((!\clock_counter|Add0~23\) # (!\clock_counter|clock_count\(12)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010101011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \clock_counter|clock_count\(12),
	datad => VCC,
	cin => \clock_counter|Add0~23\,
	combout => \clock_counter|Add0~24_combout\,
	cout => \clock_counter|Add0~25\);

-- Location: LCCOMB_X25_Y14_N26
\clock_counter|Add0~26\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|Add0~26_combout\ = (\clock_counter|clock_count\(13) & (!\clock_counter|Add0~25\)) # (!\clock_counter|clock_count\(13) & (\clock_counter|Add0~25\ & VCC))
-- \clock_counter|Add0~27\ = CARRY((\clock_counter|clock_count\(13) & !\clock_counter|Add0~25\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101000001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \clock_counter|clock_count\(13),
	datad => VCC,
	cin => \clock_counter|Add0~25\,
	combout => \clock_counter|Add0~26_combout\,
	cout => \clock_counter|Add0~27\);

-- Location: LCCOMB_X25_Y14_N28
\clock_counter|Add0~28\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|Add0~28_combout\ = (\clock_counter|clock_count\(14) & ((GND) # (!\clock_counter|Add0~27\))) # (!\clock_counter|clock_count\(14) & (\clock_counter|Add0~27\ $ (GND)))
-- \clock_counter|Add0~29\ = CARRY((\clock_counter|clock_count\(14)) # (!\clock_counter|Add0~27\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101010101111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \clock_counter|clock_count\(14),
	datad => VCC,
	cin => \clock_counter|Add0~27\,
	combout => \clock_counter|Add0~28_combout\,
	cout => \clock_counter|Add0~29\);

-- Location: LCCOMB_X25_Y14_N30
\clock_counter|Add0~30\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|Add0~30_combout\ = (\clock_counter|clock_count\(15) & (!\clock_counter|Add0~29\)) # (!\clock_counter|clock_count\(15) & (\clock_counter|Add0~29\ & VCC))
-- \clock_counter|Add0~31\ = CARRY((\clock_counter|clock_count\(15) & !\clock_counter|Add0~29\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101000001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \clock_counter|clock_count\(15),
	datad => VCC,
	cin => \clock_counter|Add0~29\,
	combout => \clock_counter|Add0~30_combout\,
	cout => \clock_counter|Add0~31\);

-- Location: LCCOMB_X25_Y13_N0
\clock_counter|Add0~32\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|Add0~32_combout\ = (\clock_counter|clock_count\(16) & ((GND) # (!\clock_counter|Add0~31\))) # (!\clock_counter|clock_count\(16) & (\clock_counter|Add0~31\ $ (GND)))
-- \clock_counter|Add0~33\ = CARRY((\clock_counter|clock_count\(16)) # (!\clock_counter|Add0~31\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110011001111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \clock_counter|clock_count\(16),
	datad => VCC,
	cin => \clock_counter|Add0~31\,
	combout => \clock_counter|Add0~32_combout\,
	cout => \clock_counter|Add0~33\);

-- Location: LCCOMB_X25_Y13_N2
\clock_counter|Add0~34\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|Add0~34_combout\ = (\clock_counter|clock_count\(17) & (!\clock_counter|Add0~33\)) # (!\clock_counter|clock_count\(17) & (\clock_counter|Add0~33\ & VCC))
-- \clock_counter|Add0~35\ = CARRY((\clock_counter|clock_count\(17) & !\clock_counter|Add0~33\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \clock_counter|clock_count\(17),
	datad => VCC,
	cin => \clock_counter|Add0~33\,
	combout => \clock_counter|Add0~34_combout\,
	cout => \clock_counter|Add0~35\);

-- Location: LCCOMB_X25_Y13_N4
\clock_counter|Add0~36\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|Add0~36_combout\ = (\clock_counter|clock_count\(18) & (\clock_counter|Add0~35\ $ (GND))) # (!\clock_counter|clock_count\(18) & ((GND) # (!\clock_counter|Add0~35\)))
-- \clock_counter|Add0~37\ = CARRY((!\clock_counter|Add0~35\) # (!\clock_counter|clock_count\(18)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \clock_counter|clock_count\(18),
	datad => VCC,
	cin => \clock_counter|Add0~35\,
	combout => \clock_counter|Add0~36_combout\,
	cout => \clock_counter|Add0~37\);

-- Location: LCCOMB_X25_Y13_N6
\clock_counter|Add0~38\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|Add0~38_combout\ = (\clock_counter|clock_count\(19) & (!\clock_counter|Add0~37\)) # (!\clock_counter|clock_count\(19) & (\clock_counter|Add0~37\ & VCC))
-- \clock_counter|Add0~39\ = CARRY((\clock_counter|clock_count\(19) & !\clock_counter|Add0~37\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \clock_counter|clock_count\(19),
	datad => VCC,
	cin => \clock_counter|Add0~37\,
	combout => \clock_counter|Add0~38_combout\,
	cout => \clock_counter|Add0~39\);

-- Location: LCCOMB_X25_Y13_N8
\clock_counter|Add0~40\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|Add0~40_combout\ = (\clock_counter|clock_count\(20) & (\clock_counter|Add0~39\ $ (GND))) # (!\clock_counter|clock_count\(20) & ((GND) # (!\clock_counter|Add0~39\)))
-- \clock_counter|Add0~41\ = CARRY((!\clock_counter|Add0~39\) # (!\clock_counter|clock_count\(20)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \clock_counter|clock_count\(20),
	datad => VCC,
	cin => \clock_counter|Add0~39\,
	combout => \clock_counter|Add0~40_combout\,
	cout => \clock_counter|Add0~41\);

-- Location: LCCOMB_X25_Y13_N10
\clock_counter|Add0~42\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|Add0~42_combout\ = (\clock_counter|clock_count\(21) & (!\clock_counter|Add0~41\)) # (!\clock_counter|clock_count\(21) & (\clock_counter|Add0~41\ & VCC))
-- \clock_counter|Add0~43\ = CARRY((\clock_counter|clock_count\(21) & !\clock_counter|Add0~41\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101000001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \clock_counter|clock_count\(21),
	datad => VCC,
	cin => \clock_counter|Add0~41\,
	combout => \clock_counter|Add0~42_combout\,
	cout => \clock_counter|Add0~43\);

-- Location: LCCOMB_X25_Y13_N12
\clock_counter|Add0~44\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|Add0~44_combout\ = (\clock_counter|clock_count\(22) & ((GND) # (!\clock_counter|Add0~43\))) # (!\clock_counter|clock_count\(22) & (\clock_counter|Add0~43\ $ (GND)))
-- \clock_counter|Add0~45\ = CARRY((\clock_counter|clock_count\(22)) # (!\clock_counter|Add0~43\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110011001111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \clock_counter|clock_count\(22),
	datad => VCC,
	cin => \clock_counter|Add0~43\,
	combout => \clock_counter|Add0~44_combout\,
	cout => \clock_counter|Add0~45\);

-- Location: LCCOMB_X25_Y13_N14
\clock_counter|Add0~46\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|Add0~46_combout\ = (\clock_counter|clock_count\(23) & (!\clock_counter|Add0~45\)) # (!\clock_counter|clock_count\(23) & (\clock_counter|Add0~45\ & VCC))
-- \clock_counter|Add0~47\ = CARRY((\clock_counter|clock_count\(23) & !\clock_counter|Add0~45\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101000001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \clock_counter|clock_count\(23),
	datad => VCC,
	cin => \clock_counter|Add0~45\,
	combout => \clock_counter|Add0~46_combout\,
	cout => \clock_counter|Add0~47\);

-- Location: LCCOMB_X25_Y13_N16
\clock_counter|Add0~48\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|Add0~48_combout\ = (\clock_counter|clock_count\(24) & ((GND) # (!\clock_counter|Add0~47\))) # (!\clock_counter|clock_count\(24) & (\clock_counter|Add0~47\ $ (GND)))
-- \clock_counter|Add0~49\ = CARRY((\clock_counter|clock_count\(24)) # (!\clock_counter|Add0~47\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101010101111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \clock_counter|clock_count\(24),
	datad => VCC,
	cin => \clock_counter|Add0~47\,
	combout => \clock_counter|Add0~48_combout\,
	cout => \clock_counter|Add0~49\);

-- Location: LCCOMB_X25_Y13_N18
\clock_counter|Add0~50\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|Add0~50_combout\ = (\clock_counter|clock_count\(25) & (\clock_counter|Add0~49\ & VCC)) # (!\clock_counter|clock_count\(25) & (!\clock_counter|Add0~49\))
-- \clock_counter|Add0~51\ = CARRY((!\clock_counter|clock_count\(25) & !\clock_counter|Add0~49\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100000101",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \clock_counter|clock_count\(25),
	datad => VCC,
	cin => \clock_counter|Add0~49\,
	combout => \clock_counter|Add0~50_combout\,
	cout => \clock_counter|Add0~51\);

-- Location: LCCOMB_X25_Y13_N20
\clock_counter|Add0~52\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|Add0~52_combout\ = (\clock_counter|clock_count\(26) & ((GND) # (!\clock_counter|Add0~51\))) # (!\clock_counter|clock_count\(26) & (\clock_counter|Add0~51\ $ (GND)))
-- \clock_counter|Add0~53\ = CARRY((\clock_counter|clock_count\(26)) # (!\clock_counter|Add0~51\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110011001111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \clock_counter|clock_count\(26),
	datad => VCC,
	cin => \clock_counter|Add0~51\,
	combout => \clock_counter|Add0~52_combout\,
	cout => \clock_counter|Add0~53\);

-- Location: LCCOMB_X25_Y13_N22
\clock_counter|Add0~54\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|Add0~54_combout\ = (\clock_counter|clock_count\(27) & (\clock_counter|Add0~53\ & VCC)) # (!\clock_counter|clock_count\(27) & (!\clock_counter|Add0~53\))
-- \clock_counter|Add0~55\ = CARRY((!\clock_counter|clock_count\(27) & !\clock_counter|Add0~53\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100000101",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \clock_counter|clock_count\(27),
	datad => VCC,
	cin => \clock_counter|Add0~53\,
	combout => \clock_counter|Add0~54_combout\,
	cout => \clock_counter|Add0~55\);

-- Location: LCCOMB_X25_Y13_N24
\clock_counter|Add0~56\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|Add0~56_combout\ = (\clock_counter|clock_count\(28) & ((GND) # (!\clock_counter|Add0~55\))) # (!\clock_counter|clock_count\(28) & (\clock_counter|Add0~55\ $ (GND)))
-- \clock_counter|Add0~57\ = CARRY((\clock_counter|clock_count\(28)) # (!\clock_counter|Add0~55\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110011001111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \clock_counter|clock_count\(28),
	datad => VCC,
	cin => \clock_counter|Add0~55\,
	combout => \clock_counter|Add0~56_combout\,
	cout => \clock_counter|Add0~57\);

-- Location: LCCOMB_X25_Y13_N26
\clock_counter|Add0~58\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|Add0~58_combout\ = (\clock_counter|clock_count\(29) & (\clock_counter|Add0~57\ & VCC)) # (!\clock_counter|clock_count\(29) & (!\clock_counter|Add0~57\))
-- \clock_counter|Add0~59\ = CARRY((!\clock_counter|clock_count\(29) & !\clock_counter|Add0~57\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100000101",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \clock_counter|clock_count\(29),
	datad => VCC,
	cin => \clock_counter|Add0~57\,
	combout => \clock_counter|Add0~58_combout\,
	cout => \clock_counter|Add0~59\);

-- Location: LCCOMB_X25_Y13_N28
\clock_counter|Add0~60\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|Add0~60_combout\ = (\clock_counter|clock_count\(30) & ((GND) # (!\clock_counter|Add0~59\))) # (!\clock_counter|clock_count\(30) & (\clock_counter|Add0~59\ $ (GND)))
-- \clock_counter|Add0~61\ = CARRY((\clock_counter|clock_count\(30)) # (!\clock_counter|Add0~59\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110011001111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \clock_counter|clock_count\(30),
	datad => VCC,
	cin => \clock_counter|Add0~59\,
	combout => \clock_counter|Add0~60_combout\,
	cout => \clock_counter|Add0~61\);

-- Location: LCCOMB_X25_Y13_N30
\clock_counter|Add0~62\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|Add0~62_combout\ = \clock_counter|Add0~61\ $ (!\clock_counter|clock_count\(31))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000001111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datad => \clock_counter|clock_count\(31),
	cin => \clock_counter|Add0~61\,
	combout => \clock_counter|Add0~62_combout\);

-- Location: LCFF_X24_Y14_N17
\clock_counter|clock_count[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \CLOCK_50~clkctrl_outclk\,
	datain => \clock_counter|clock_count~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clock_counter|clock_count\(0));

-- Location: LCFF_X24_Y14_N23
\clock_counter|clock_count[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \CLOCK_50~clkctrl_outclk\,
	datain => \clock_counter|clock_count~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clock_counter|clock_count\(1));

-- Location: LCFF_X24_Y14_N25
\clock_counter|clock_count[2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \CLOCK_50~clkctrl_outclk\,
	datain => \clock_counter|clock_count~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clock_counter|clock_count\(2));

-- Location: LCFF_X24_Y14_N27
\clock_counter|clock_count[3]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \CLOCK_50~clkctrl_outclk\,
	datain => \clock_counter|clock_count~3_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clock_counter|clock_count\(3));

-- Location: LCCOMB_X23_Y14_N16
\clock_counter|Equal0~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|Equal0~0_combout\ = (!\clock_counter|clock_count\(0) & (!\clock_counter|clock_count\(1) & (!\clock_counter|clock_count\(3) & !\clock_counter|clock_count\(2))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \clock_counter|clock_count\(0),
	datab => \clock_counter|clock_count\(1),
	datac => \clock_counter|clock_count\(3),
	datad => \clock_counter|clock_count\(2),
	combout => \clock_counter|Equal0~0_combout\);

-- Location: LCFF_X25_Y14_N29
\clock_counter|clock_count[5]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \CLOCK_50~clkctrl_outclk\,
	sdata => \clock_counter|clock_count[5]~20_combout\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clock_counter|clock_count\(5));

-- Location: LCFF_X24_Y14_N29
\clock_counter|clock_count[4]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \CLOCK_50~clkctrl_outclk\,
	datain => \clock_counter|clock_count~4_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clock_counter|clock_count\(4));

-- Location: LCFF_X24_Y13_N21
\clock_counter|clock_count[6]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \CLOCK_50~clkctrl_outclk\,
	datain => \clock_counter|clock_count~5_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clock_counter|clock_count\(6));

-- Location: LCFF_X25_Y14_N3
\clock_counter|clock_count[7]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \CLOCK_50~clkctrl_outclk\,
	sdata => \clock_counter|clock_count~6_combout\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clock_counter|clock_count\(7));

-- Location: LCCOMB_X24_Y13_N6
\clock_counter|Equal0~1\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|Equal0~1_combout\ = (!\clock_counter|clock_count\(6) & (\clock_counter|clock_count\(5) & (!\clock_counter|clock_count\(4) & !\clock_counter|clock_count\(7))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \clock_counter|clock_count\(6),
	datab => \clock_counter|clock_count\(5),
	datac => \clock_counter|clock_count\(4),
	datad => \clock_counter|clock_count\(7),
	combout => \clock_counter|Equal0~1_combout\);

-- Location: LCFF_X24_Y14_N3
\clock_counter|clock_count[10]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \CLOCK_50~clkctrl_outclk\,
	datain => \clock_counter|clock_count[10]~21_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clock_counter|clock_count\(10));

-- Location: LCFF_X24_Y14_N1
\clock_counter|clock_count[11]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \CLOCK_50~clkctrl_outclk\,
	datain => \clock_counter|clock_count[11]~22_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clock_counter|clock_count\(11));

-- Location: LCFF_X24_Y14_N7
\clock_counter|clock_count[8]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \CLOCK_50~clkctrl_outclk\,
	datain => \clock_counter|clock_count~7_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clock_counter|clock_count\(8));

-- Location: LCFF_X24_Y14_N5
\clock_counter|clock_count[9]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \CLOCK_50~clkctrl_outclk\,
	datain => \clock_counter|clock_count~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clock_counter|clock_count\(9));

-- Location: LCCOMB_X24_Y14_N18
\clock_counter|Equal0~2\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|Equal0~2_combout\ = (!\clock_counter|clock_count\(8) & (\clock_counter|clock_count\(10) & (!\clock_counter|clock_count\(9) & \clock_counter|clock_count\(11))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000010000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \clock_counter|clock_count\(8),
	datab => \clock_counter|clock_count\(10),
	datac => \clock_counter|clock_count\(9),
	datad => \clock_counter|clock_count\(11),
	combout => \clock_counter|Equal0~2_combout\);

-- Location: LCFF_X24_Y14_N9
\clock_counter|clock_count[12]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \CLOCK_50~clkctrl_outclk\,
	datain => \clock_counter|clock_count[12]~23_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clock_counter|clock_count\(12));

-- Location: LCFF_X24_Y14_N15
\clock_counter|clock_count[13]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \CLOCK_50~clkctrl_outclk\,
	datain => \clock_counter|clock_count[13]~24_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clock_counter|clock_count\(13));

-- Location: LCFF_X24_Y14_N13
\clock_counter|clock_count[15]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \CLOCK_50~clkctrl_outclk\,
	datain => \clock_counter|clock_count[15]~25_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clock_counter|clock_count\(15));

-- Location: LCFF_X24_Y14_N11
\clock_counter|clock_count[14]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \CLOCK_50~clkctrl_outclk\,
	datain => \clock_counter|clock_count~9_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clock_counter|clock_count\(14));

-- Location: LCCOMB_X24_Y14_N20
\clock_counter|Equal0~3\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|Equal0~3_combout\ = (\clock_counter|clock_count\(15) & (\clock_counter|clock_count\(13) & (\clock_counter|clock_count\(12) & !\clock_counter|clock_count\(14))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \clock_counter|clock_count\(15),
	datab => \clock_counter|clock_count\(13),
	datac => \clock_counter|clock_count\(12),
	datad => \clock_counter|clock_count\(14),
	combout => \clock_counter|Equal0~3_combout\);

-- Location: LCCOMB_X24_Y13_N12
\clock_counter|Equal0~4\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|Equal0~4_combout\ = (\clock_counter|Equal0~3_combout\ & (\clock_counter|Equal0~2_combout\ & (\clock_counter|Equal0~0_combout\ & \clock_counter|Equal0~1_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \clock_counter|Equal0~3_combout\,
	datab => \clock_counter|Equal0~2_combout\,
	datac => \clock_counter|Equal0~0_combout\,
	datad => \clock_counter|Equal0~1_combout\,
	combout => \clock_counter|Equal0~4_combout\);

-- Location: LCFF_X26_Y13_N13
\clock_counter|clock_count[17]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \CLOCK_50~clkctrl_outclk\,
	datain => \clock_counter|clock_count[17]~26_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clock_counter|clock_count\(17));

-- Location: LCFF_X26_Y13_N31
\clock_counter|clock_count[18]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \CLOCK_50~clkctrl_outclk\,
	datain => \clock_counter|clock_count[18]~27_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clock_counter|clock_count\(18));

-- Location: LCFF_X26_Y13_N25
\clock_counter|clock_count[19]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \CLOCK_50~clkctrl_outclk\,
	datain => \clock_counter|clock_count[19]~28_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clock_counter|clock_count\(19));

-- Location: LCFF_X26_Y13_N19
\clock_counter|clock_count[16]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \CLOCK_50~clkctrl_outclk\,
	datain => \clock_counter|clock_count~10_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clock_counter|clock_count\(16));

-- Location: LCCOMB_X26_Y13_N16
\clock_counter|Equal0~5\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|Equal0~5_combout\ = (\clock_counter|clock_count\(17) & (\clock_counter|clock_count\(18) & (\clock_counter|clock_count\(19) & !\clock_counter|clock_count\(16))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \clock_counter|clock_count\(17),
	datab => \clock_counter|clock_count\(18),
	datac => \clock_counter|clock_count\(19),
	datad => \clock_counter|clock_count\(16),
	combout => \clock_counter|Equal0~5_combout\);

-- Location: LCFF_X24_Y13_N23
\clock_counter|clock_count[20]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \CLOCK_50~clkctrl_outclk\,
	datain => \clock_counter|clock_count[20]~29_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clock_counter|clock_count\(20));

-- Location: LCFF_X24_Y13_N9
\clock_counter|clock_count[21]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \CLOCK_50~clkctrl_outclk\,
	datain => \clock_counter|clock_count[21]~30_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clock_counter|clock_count\(21));

-- Location: LCFF_X24_Y13_N15
\clock_counter|clock_count[23]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \CLOCK_50~clkctrl_outclk\,
	datain => \clock_counter|clock_count[23]~31_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clock_counter|clock_count\(23));

-- Location: LCFF_X24_Y13_N25
\clock_counter|clock_count[22]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \CLOCK_50~clkctrl_outclk\,
	datain => \clock_counter|clock_count~11_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clock_counter|clock_count\(22));

-- Location: LCCOMB_X24_Y13_N10
\clock_counter|Equal0~6\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|Equal0~6_combout\ = (!\clock_counter|clock_count\(22) & (\clock_counter|clock_count\(23) & (\clock_counter|clock_count\(21) & \clock_counter|clock_count\(20))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0100000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \clock_counter|clock_count\(22),
	datab => \clock_counter|clock_count\(23),
	datac => \clock_counter|clock_count\(21),
	datad => \clock_counter|clock_count\(20),
	combout => \clock_counter|Equal0~6_combout\);

-- Location: LCCOMB_X24_Y13_N4
\clock_counter|Equal0~7\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|Equal0~7_combout\ = (\clock_counter|Equal0~5_combout\ & \clock_counter|Equal0~6_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \clock_counter|Equal0~5_combout\,
	datad => \clock_counter|Equal0~6_combout\,
	combout => \clock_counter|Equal0~7_combout\);

-- Location: LCFF_X24_Y13_N31
\clock_counter|clock_count[24]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \CLOCK_50~clkctrl_outclk\,
	datain => \clock_counter|clock_count~12_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clock_counter|clock_count\(24));

-- Location: LCFF_X24_Y13_N29
\clock_counter|clock_count[25]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \CLOCK_50~clkctrl_outclk\,
	datain => \clock_counter|clock_count~13_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clock_counter|clock_count\(25));

-- Location: LCFF_X24_Y13_N27
\clock_counter|clock_count[26]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \CLOCK_50~clkctrl_outclk\,
	datain => \clock_counter|clock_count~14_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clock_counter|clock_count\(26));

-- Location: LCFF_X24_Y13_N1
\clock_counter|clock_count[27]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \CLOCK_50~clkctrl_outclk\,
	datain => \clock_counter|clock_count~15_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clock_counter|clock_count\(27));

-- Location: LCCOMB_X23_Y13_N14
\clock_counter|Equal0~8\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|Equal0~8_combout\ = (!\clock_counter|clock_count\(26) & (!\clock_counter|clock_count\(25) & (!\clock_counter|clock_count\(27) & !\clock_counter|clock_count\(24))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \clock_counter|clock_count\(26),
	datab => \clock_counter|clock_count\(25),
	datac => \clock_counter|clock_count\(27),
	datad => \clock_counter|clock_count\(24),
	combout => \clock_counter|Equal0~8_combout\);

-- Location: LCFF_X26_Y13_N23
\clock_counter|clock_count[28]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \CLOCK_50~clkctrl_outclk\,
	datain => \clock_counter|clock_count~16_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clock_counter|clock_count\(28));

-- Location: LCFF_X24_Y13_N19
\clock_counter|clock_count[29]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \CLOCK_50~clkctrl_outclk\,
	datain => \clock_counter|clock_count~17_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clock_counter|clock_count\(29));

-- Location: LCFF_X26_Y13_N29
\clock_counter|clock_count[30]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \CLOCK_50~clkctrl_outclk\,
	datain => \clock_counter|clock_count~18_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clock_counter|clock_count\(30));

-- Location: LCFF_X26_Y13_N7
\clock_counter|clock_count[31]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \CLOCK_50~clkctrl_outclk\,
	datain => \clock_counter|clock_count~19_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clock_counter|clock_count\(31));

-- Location: LCCOMB_X26_Y13_N20
\clock_counter|Equal0~9\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|Equal0~9_combout\ = (!\clock_counter|clock_count\(31) & (!\clock_counter|clock_count\(30) & (!\clock_counter|clock_count\(29) & !\clock_counter|clock_count\(28))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \clock_counter|clock_count\(31),
	datab => \clock_counter|clock_count\(30),
	datac => \clock_counter|clock_count\(29),
	datad => \clock_counter|clock_count\(28),
	combout => \clock_counter|Equal0~9_combout\);

-- Location: LCCOMB_X24_Y13_N16
\clock_counter|Equal0~10\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|Equal0~10_combout\ = (\clock_counter|Equal0~8_combout\ & (\clock_counter|Equal0~9_combout\ & (\clock_counter|Equal0~7_combout\ & \clock_counter|Equal0~4_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \clock_counter|Equal0~8_combout\,
	datab => \clock_counter|Equal0~9_combout\,
	datac => \clock_counter|Equal0~7_combout\,
	datad => \clock_counter|Equal0~4_combout\,
	combout => \clock_counter|Equal0~10_combout\);

-- Location: LCCOMB_X24_Y14_N16
\clock_counter|clock_count~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|clock_count~0_combout\ = (\clock_counter|Add0~0_combout\ & !\clock_counter|Equal0~10_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \clock_counter|Add0~0_combout\,
	datad => \clock_counter|Equal0~10_combout\,
	combout => \clock_counter|clock_count~0_combout\);

-- Location: LCCOMB_X24_Y14_N22
\clock_counter|clock_count~1\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|clock_count~1_combout\ = (\clock_counter|Add0~2_combout\ & !\clock_counter|Equal0~10_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \clock_counter|Add0~2_combout\,
	datad => \clock_counter|Equal0~10_combout\,
	combout => \clock_counter|clock_count~1_combout\);

-- Location: LCCOMB_X24_Y14_N24
\clock_counter|clock_count~2\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|clock_count~2_combout\ = (\clock_counter|Add0~4_combout\ & !\clock_counter|Equal0~10_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \clock_counter|Add0~4_combout\,
	datad => \clock_counter|Equal0~10_combout\,
	combout => \clock_counter|clock_count~2_combout\);

-- Location: LCCOMB_X24_Y14_N26
\clock_counter|clock_count~3\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|clock_count~3_combout\ = (\clock_counter|Add0~6_combout\ & !\clock_counter|Equal0~10_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \clock_counter|Add0~6_combout\,
	datad => \clock_counter|Equal0~10_combout\,
	combout => \clock_counter|clock_count~3_combout\);

-- Location: LCCOMB_X24_Y14_N28
\clock_counter|clock_count~4\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|clock_count~4_combout\ = (\clock_counter|Add0~8_combout\ & !\clock_counter|Equal0~10_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \clock_counter|Add0~8_combout\,
	datad => \clock_counter|Equal0~10_combout\,
	combout => \clock_counter|clock_count~4_combout\);

-- Location: LCCOMB_X24_Y13_N20
\clock_counter|clock_count~5\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|clock_count~5_combout\ = (!\clock_counter|Equal0~10_combout\ & \clock_counter|Add0~12_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \clock_counter|Equal0~10_combout\,
	datad => \clock_counter|Add0~12_combout\,
	combout => \clock_counter|clock_count~5_combout\);

-- Location: LCCOMB_X24_Y13_N2
\clock_counter|clock_count~6\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|clock_count~6_combout\ = (!\clock_counter|Equal0~10_combout\ & \clock_counter|Add0~14_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \clock_counter|Equal0~10_combout\,
	datad => \clock_counter|Add0~14_combout\,
	combout => \clock_counter|clock_count~6_combout\);

-- Location: LCCOMB_X24_Y14_N6
\clock_counter|clock_count~7\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|clock_count~7_combout\ = (\clock_counter|Add0~16_combout\ & !\clock_counter|Equal0~10_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \clock_counter|Add0~16_combout\,
	datad => \clock_counter|Equal0~10_combout\,
	combout => \clock_counter|clock_count~7_combout\);

-- Location: LCCOMB_X24_Y14_N4
\clock_counter|clock_count~8\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|clock_count~8_combout\ = (!\clock_counter|Equal0~10_combout\ & \clock_counter|Add0~18_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101010100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \clock_counter|Equal0~10_combout\,
	datad => \clock_counter|Add0~18_combout\,
	combout => \clock_counter|clock_count~8_combout\);

-- Location: LCCOMB_X24_Y14_N10
\clock_counter|clock_count~9\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|clock_count~9_combout\ = (!\clock_counter|Equal0~10_combout\ & \clock_counter|Add0~28_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101000001010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \clock_counter|Equal0~10_combout\,
	datac => \clock_counter|Add0~28_combout\,
	combout => \clock_counter|clock_count~9_combout\);

-- Location: LCCOMB_X26_Y13_N18
\clock_counter|clock_count~10\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|clock_count~10_combout\ = (\clock_counter|Add0~32_combout\ & !\clock_counter|Equal0~10_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \clock_counter|Add0~32_combout\,
	datad => \clock_counter|Equal0~10_combout\,
	combout => \clock_counter|clock_count~10_combout\);

-- Location: LCCOMB_X24_Y13_N24
\clock_counter|clock_count~11\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|clock_count~11_combout\ = (!\clock_counter|Equal0~10_combout\ & \clock_counter|Add0~44_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101000001010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \clock_counter|Equal0~10_combout\,
	datac => \clock_counter|Add0~44_combout\,
	combout => \clock_counter|clock_count~11_combout\);

-- Location: LCCOMB_X24_Y13_N30
\clock_counter|clock_count~12\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|clock_count~12_combout\ = (!\clock_counter|Equal0~10_combout\ & \clock_counter|Add0~48_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101000001010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \clock_counter|Equal0~10_combout\,
	datac => \clock_counter|Add0~48_combout\,
	combout => \clock_counter|clock_count~12_combout\);

-- Location: LCCOMB_X24_Y13_N28
\clock_counter|clock_count~13\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|clock_count~13_combout\ = (!\clock_counter|Equal0~10_combout\ & \clock_counter|Add0~50_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \clock_counter|Equal0~10_combout\,
	datad => \clock_counter|Add0~50_combout\,
	combout => \clock_counter|clock_count~13_combout\);

-- Location: LCCOMB_X24_Y13_N26
\clock_counter|clock_count~14\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|clock_count~14_combout\ = (!\clock_counter|Equal0~10_combout\ & \clock_counter|Add0~52_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \clock_counter|Equal0~10_combout\,
	datad => \clock_counter|Add0~52_combout\,
	combout => \clock_counter|clock_count~14_combout\);

-- Location: LCCOMB_X24_Y13_N0
\clock_counter|clock_count~15\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|clock_count~15_combout\ = (!\clock_counter|Equal0~10_combout\ & \clock_counter|Add0~54_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \clock_counter|Equal0~10_combout\,
	datad => \clock_counter|Add0~54_combout\,
	combout => \clock_counter|clock_count~15_combout\);

-- Location: LCCOMB_X26_Y13_N22
\clock_counter|clock_count~16\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|clock_count~16_combout\ = (!\clock_counter|Equal0~10_combout\ & \clock_counter|Add0~56_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \clock_counter|Equal0~10_combout\,
	datad => \clock_counter|Add0~56_combout\,
	combout => \clock_counter|clock_count~16_combout\);

-- Location: LCCOMB_X24_Y13_N18
\clock_counter|clock_count~17\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|clock_count~17_combout\ = (!\clock_counter|Equal0~10_combout\ & \clock_counter|Add0~58_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101000001010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \clock_counter|Equal0~10_combout\,
	datac => \clock_counter|Add0~58_combout\,
	combout => \clock_counter|clock_count~17_combout\);

-- Location: LCCOMB_X26_Y13_N28
\clock_counter|clock_count~18\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|clock_count~18_combout\ = (!\clock_counter|Equal0~10_combout\ & \clock_counter|Add0~60_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \clock_counter|Equal0~10_combout\,
	datad => \clock_counter|Add0~60_combout\,
	combout => \clock_counter|clock_count~18_combout\);

-- Location: LCCOMB_X26_Y13_N6
\clock_counter|clock_count~19\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|clock_count~19_combout\ = (\clock_counter|Add0~62_combout\ & !\clock_counter|Equal0~10_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \clock_counter|Add0~62_combout\,
	datad => \clock_counter|Equal0~10_combout\,
	combout => \clock_counter|clock_count~19_combout\);

-- Location: LCCOMB_X24_Y14_N30
\clock_counter|clock_count[5]~20\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|clock_count[5]~20_combout\ = !\clock_counter|Add0~10_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \clock_counter|Add0~10_combout\,
	combout => \clock_counter|clock_count[5]~20_combout\);

-- Location: LCCOMB_X24_Y14_N2
\clock_counter|clock_count[10]~21\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|clock_count[10]~21_combout\ = !\clock_counter|Add0~20_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \clock_counter|Add0~20_combout\,
	combout => \clock_counter|clock_count[10]~21_combout\);

-- Location: LCCOMB_X24_Y14_N0
\clock_counter|clock_count[11]~22\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|clock_count[11]~22_combout\ = !\clock_counter|Add0~22_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \clock_counter|Add0~22_combout\,
	combout => \clock_counter|clock_count[11]~22_combout\);

-- Location: LCCOMB_X24_Y14_N8
\clock_counter|clock_count[12]~23\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|clock_count[12]~23_combout\ = !\clock_counter|Add0~24_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \clock_counter|Add0~24_combout\,
	combout => \clock_counter|clock_count[12]~23_combout\);

-- Location: LCCOMB_X24_Y14_N14
\clock_counter|clock_count[13]~24\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|clock_count[13]~24_combout\ = !\clock_counter|Add0~26_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \clock_counter|Add0~26_combout\,
	combout => \clock_counter|clock_count[13]~24_combout\);

-- Location: LCCOMB_X24_Y14_N12
\clock_counter|clock_count[15]~25\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|clock_count[15]~25_combout\ = !\clock_counter|Add0~30_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \clock_counter|Add0~30_combout\,
	combout => \clock_counter|clock_count[15]~25_combout\);

-- Location: LCCOMB_X26_Y13_N12
\clock_counter|clock_count[17]~26\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|clock_count[17]~26_combout\ = !\clock_counter|Add0~34_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \clock_counter|Add0~34_combout\,
	combout => \clock_counter|clock_count[17]~26_combout\);

-- Location: LCCOMB_X26_Y13_N30
\clock_counter|clock_count[18]~27\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|clock_count[18]~27_combout\ = !\clock_counter|Add0~36_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \clock_counter|Add0~36_combout\,
	combout => \clock_counter|clock_count[18]~27_combout\);

-- Location: LCCOMB_X26_Y13_N24
\clock_counter|clock_count[19]~28\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|clock_count[19]~28_combout\ = !\clock_counter|Add0~38_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \clock_counter|Add0~38_combout\,
	combout => \clock_counter|clock_count[19]~28_combout\);

-- Location: LCCOMB_X24_Y13_N22
\clock_counter|clock_count[20]~29\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|clock_count[20]~29_combout\ = !\clock_counter|Add0~40_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \clock_counter|Add0~40_combout\,
	combout => \clock_counter|clock_count[20]~29_combout\);

-- Location: LCCOMB_X24_Y13_N8
\clock_counter|clock_count[21]~30\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|clock_count[21]~30_combout\ = !\clock_counter|Add0~42_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \clock_counter|Add0~42_combout\,
	combout => \clock_counter|clock_count[21]~30_combout\);

-- Location: LCCOMB_X24_Y13_N14
\clock_counter|clock_count[23]~31\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|clock_count[23]~31_combout\ = !\clock_counter|Add0~46_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \clock_counter|Add0~46_combout\,
	combout => \clock_counter|clock_count[23]~31_combout\);

-- Location: PIN_R21,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
\KEY[1]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_KEY(1),
	combout => \KEY~combout\(1));

-- Location: PIN_L1,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
\CLOCK_50~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_CLOCK_50,
	combout => \CLOCK_50~combout\);

-- Location: CLKCTRL_G2
\CLOCK_50~clkctrl\ : cycloneii_clkctrl
-- pragma translate_off
GENERIC MAP (
	clock_type => "global clock",
	ena_register_mode => "none")
-- pragma translate_on
PORT MAP (
	inclk => \CLOCK_50~clkctrl_INCLK_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	outclk => \CLOCK_50~clkctrl_outclk\);

-- Location: LCCOMB_X23_Y13_N16
\clock_counter|internal_clock~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \clock_counter|internal_clock~0_combout\ = \clock_counter|Equal0~10_combout\ $ (\clock_counter|internal_clock~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \clock_counter|Equal0~10_combout\,
	datac => \clock_counter|internal_clock~regout\,
	combout => \clock_counter|internal_clock~0_combout\);

-- Location: LCFF_X23_Y13_N17
\clock_counter|internal_clock\ : cycloneii_lcell_ff
PORT MAP (
	clk => \CLOCK_50~clkctrl_outclk\,
	datain => \clock_counter|internal_clock~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clock_counter|internal_clock~regout\);

-- Location: CLKCTRL_G3
\clock_counter|internal_clock~clkctrl\ : cycloneii_clkctrl
-- pragma translate_off
GENERIC MAP (
	clock_type => "global clock",
	ena_register_mode => "none")
-- pragma translate_on
PORT MAP (
	inclk => \clock_counter|internal_clock~clkctrl_INCLK_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	outclk => \clock_counter|internal_clock~clkctrl_outclk\);

-- Location: PIN_R22,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
\KEY[0]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_KEY(0),
	combout => \KEY~combout\(0));

-- Location: LCCOMB_X47_Y10_N4
\reset_morse~feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \reset_morse~feeder_combout\ = \KEY~combout\(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \KEY~combout\(0),
	combout => \reset_morse~feeder_combout\);

-- Location: LCFF_X47_Y10_N5
reset_morse : cycloneii_lcell_ff
PORT MAP (
	clk => \clock_counter|internal_clock~clkctrl_outclk\,
	datain => \reset_morse~feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \reset_morse~regout\);

-- Location: PIN_L21,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
\SW[1]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_SW(1),
	combout => \SW~combout\(1));

-- Location: LCCOMB_X47_Y10_N28
\segment|Mux2~1\ : cycloneii_lcell_comb
-- Equation(s):
-- \segment|Mux2~1_combout\ = (!\SW~combout\(0) & \SW~combout\(1))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101010100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \SW~combout\(0),
	datad => \SW~combout\(1),
	combout => \segment|Mux2~1_combout\);

-- Location: LCCOMB_X47_Y10_N26
\segment|Mux3~1\ : cycloneii_lcell_comb
-- Equation(s):
-- \segment|Mux3~1_combout\ = (!\SW~combout\(0) & !\SW~combout\(1))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000001010101",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \SW~combout\(0),
	datad => \SW~combout\(1),
	combout => \segment|Mux3~1_combout\);

-- Location: LCCOMB_X47_Y10_N8
\conv_morse|next_caracter[12]~13\ : cycloneii_lcell_comb
-- Equation(s):
-- \conv_morse|next_caracter[12]~13_combout\ = (\SW~combout\(2) & (\segment|Mux2~1_combout\)) # (!\SW~combout\(2) & ((!\segment|Mux3~1_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000100011011101",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \SW~combout\(2),
	datab => \segment|Mux2~1_combout\,
	datad => \segment|Mux3~1_combout\,
	combout => \conv_morse|next_caracter[12]~13_combout\);

-- Location: LCCOMB_X47_Y10_N24
\px_estat~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \px_estat~0_combout\ = (\KEY~combout\(0)) # (px_estat(1) $ (px_estat(0)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100111111111100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \KEY~combout\(0),
	datac => px_estat(1),
	datad => px_estat(0),
	combout => \px_estat~0_combout\);

-- Location: LCFF_X47_Y10_N25
\px_estat[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clock_counter|internal_clock~clkctrl_outclk\,
	datain => \px_estat~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => px_estat(1));

-- Location: LCCOMB_X46_Y10_N8
\px_estat~1\ : cycloneii_lcell_comb
-- Equation(s):
-- \px_estat~1_combout\ = (\KEY~combout\(0)) # ((\KEY~combout\(1) & (!px_estat(0) & !px_estat(1))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110011001110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \KEY~combout\(1),
	datab => \KEY~combout\(0),
	datac => px_estat(0),
	datad => px_estat(1),
	combout => \px_estat~1_combout\);

-- Location: LCFF_X46_Y10_N9
\px_estat[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clock_counter|internal_clock~clkctrl_outclk\,
	datain => \px_estat~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => px_estat(0));

-- Location: LCCOMB_X46_Y10_N4
\inici_morse~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \inici_morse~0_combout\ = (\KEY~combout\(1) & (!\KEY~combout\(0) & (!px_estat(0) & !px_estat(1))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \KEY~combout\(1),
	datab => \KEY~combout\(0),
	datac => px_estat(0),
	datad => px_estat(1),
	combout => \inici_morse~0_combout\);

-- Location: LCFF_X46_Y10_N5
inici_morse : cycloneii_lcell_ff
PORT MAP (
	clk => \clock_counter|internal_clock~clkctrl_outclk\,
	datain => \inici_morse~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inici_morse~regout\);

-- Location: PIN_M22,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
\SW[2]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_SW(2),
	combout => \SW~combout\(2));

-- Location: PIN_L22,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
\SW[0]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_SW(0),
	combout => \SW~combout\(0));

-- Location: LCCOMB_X46_Y10_N22
\conv_morse|caracter_reg[2]~9\ : cycloneii_lcell_comb
-- Equation(s):
-- \conv_morse|caracter_reg[2]~9_combout\ = (\inici_morse~regout\ & !\SW~combout\(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \inici_morse~regout\,
	datad => \SW~combout\(0),
	combout => \conv_morse|caracter_reg[2]~9_combout\);

-- Location: LCFF_X46_Y10_N23
\conv_morse|next_caracter[3]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clock_counter|internal_clock~clkctrl_outclk\,
	datain => \conv_morse|caracter_reg[2]~9_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \conv_morse|next_caracter\(3));

-- Location: LCCOMB_X46_Y10_N12
\conv_morse|caracter_reg[3]~8\ : cycloneii_lcell_comb
-- Equation(s):
-- \conv_morse|caracter_reg[3]~8_combout\ = (!\inici_morse~regout\ & \conv_morse|next_caracter\(3))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \inici_morse~regout\,
	datad => \conv_morse|next_caracter\(3),
	combout => \conv_morse|caracter_reg[3]~8_combout\);

-- Location: LCFF_X46_Y10_N13
\conv_morse|next_caracter[4]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clock_counter|internal_clock~clkctrl_outclk\,
	datain => \conv_morse|caracter_reg[3]~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \conv_morse|next_caracter\(4));

-- Location: LCCOMB_X46_Y10_N2
\conv_morse|caracter_reg[4]~7\ : cycloneii_lcell_comb
-- Equation(s):
-- \conv_morse|caracter_reg[4]~7_combout\ = (\inici_morse~regout\) # (\conv_morse|next_caracter\(4))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \inici_morse~regout\,
	datad => \conv_morse|next_caracter\(4),
	combout => \conv_morse|caracter_reg[4]~7_combout\);

-- Location: LCFF_X46_Y10_N3
\conv_morse|next_caracter[5]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clock_counter|internal_clock~clkctrl_outclk\,
	datain => \conv_morse|caracter_reg[4]~7_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \conv_morse|next_caracter\(5));

-- Location: LCCOMB_X46_Y10_N28
\conv_morse|caracter_reg[5]~6\ : cycloneii_lcell_comb
-- Equation(s):
-- \conv_morse|caracter_reg[5]~6_combout\ = (\inici_morse~regout\ & (!\SW~combout\(0) & (!\SW~combout\(2)))) # (!\inici_morse~regout\ & (((\conv_morse|next_caracter\(5)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001111100010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \SW~combout\(0),
	datab => \SW~combout\(2),
	datac => \inici_morse~regout\,
	datad => \conv_morse|next_caracter\(5),
	combout => \conv_morse|caracter_reg[5]~6_combout\);

-- Location: LCFF_X46_Y10_N29
\conv_morse|next_caracter[6]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clock_counter|internal_clock~clkctrl_outclk\,
	datain => \conv_morse|caracter_reg[5]~6_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \conv_morse|next_caracter\(6));

-- Location: LCCOMB_X46_Y10_N26
\conv_morse|caracter_reg[6]~5\ : cycloneii_lcell_comb
-- Equation(s):
-- \conv_morse|caracter_reg[6]~5_combout\ = (\inici_morse~regout\ & ((\SW~combout\(0)) # ((\SW~combout\(1))))) # (!\inici_morse~regout\ & (((\conv_morse|next_caracter\(6)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111111100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \SW~combout\(0),
	datab => \SW~combout\(1),
	datac => \inici_morse~regout\,
	datad => \conv_morse|next_caracter\(6),
	combout => \conv_morse|caracter_reg[6]~5_combout\);

-- Location: LCFF_X46_Y10_N27
\conv_morse|next_caracter[7]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clock_counter|internal_clock~clkctrl_outclk\,
	datain => \conv_morse|caracter_reg[6]~5_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \conv_morse|next_caracter\(7));

-- Location: LCCOMB_X46_Y10_N0
\conv_morse|caracter_reg[7]~3\ : cycloneii_lcell_comb
-- Equation(s):
-- \conv_morse|caracter_reg[7]~3_combout\ = (\inici_morse~regout\ & (\SW~combout\(2) & ((!\SW~combout\(1)) # (!\SW~combout\(0)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \SW~combout\(0),
	datab => \SW~combout\(1),
	datac => \inici_morse~regout\,
	datad => \SW~combout\(2),
	combout => \conv_morse|caracter_reg[7]~3_combout\);

-- Location: LCCOMB_X46_Y10_N30
\conv_morse|caracter_reg[7]~4\ : cycloneii_lcell_comb
-- Equation(s):
-- \conv_morse|caracter_reg[7]~4_combout\ = (\conv_morse|caracter_reg[7]~3_combout\) # ((\conv_morse|next_caracter\(7) & !\inici_morse~regout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \conv_morse|next_caracter\(7),
	datac => \inici_morse~regout\,
	datad => \conv_morse|caracter_reg[7]~3_combout\,
	combout => \conv_morse|caracter_reg[7]~4_combout\);

-- Location: LCFF_X46_Y10_N31
\conv_morse|next_caracter[8]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clock_counter|internal_clock~clkctrl_outclk\,
	datain => \conv_morse|caracter_reg[7]~4_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \conv_morse|next_caracter\(8));

-- Location: LCCOMB_X47_Y10_N22
\conv_morse|caracter_reg[8]~2\ : cycloneii_lcell_comb
-- Equation(s):
-- \conv_morse|caracter_reg[8]~2_combout\ = (\inici_morse~regout\ & (((!\segment|Mux3~1_combout\)) # (!\SW~combout\(2)))) # (!\inici_morse~regout\ & (((\conv_morse|next_caracter\(8)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111011111110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \SW~combout\(2),
	datab => \segment|Mux3~1_combout\,
	datac => \conv_morse|next_caracter\(8),
	datad => \inici_morse~regout\,
	combout => \conv_morse|caracter_reg[8]~2_combout\);

-- Location: LCFF_X47_Y10_N23
\conv_morse|next_caracter[9]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clock_counter|internal_clock~clkctrl_outclk\,
	datain => \conv_morse|caracter_reg[8]~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \conv_morse|next_caracter\(9));

-- Location: LCCOMB_X47_Y10_N20
\conv_morse|caracter_reg[9]~1\ : cycloneii_lcell_comb
-- Equation(s):
-- \conv_morse|caracter_reg[9]~1_combout\ = (\inici_morse~regout\ & (!\SW~combout\(1) & ((!\SW~combout\(0))))) # (!\inici_morse~regout\ & (((\conv_morse|next_caracter\(9)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000010111001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \SW~combout\(1),
	datab => \conv_morse|next_caracter\(9),
	datac => \SW~combout\(0),
	datad => \inici_morse~regout\,
	combout => \conv_morse|caracter_reg[9]~1_combout\);

-- Location: LCFF_X47_Y10_N21
\conv_morse|next_caracter[10]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clock_counter|internal_clock~clkctrl_outclk\,
	datain => \conv_morse|caracter_reg[9]~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \conv_morse|next_caracter\(10));

-- Location: LCCOMB_X47_Y10_N14
\conv_morse|caracter_reg[10]~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \conv_morse|caracter_reg[10]~0_combout\ = (\inici_morse~regout\ & (((!\segment|Mux3~1_combout\)) # (!\SW~combout\(2)))) # (!\inici_morse~regout\ & (((\conv_morse|next_caracter\(10)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111011111110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \SW~combout\(2),
	datab => \segment|Mux3~1_combout\,
	datac => \conv_morse|next_caracter\(10),
	datad => \inici_morse~regout\,
	combout => \conv_morse|caracter_reg[10]~0_combout\);

-- Location: LCFF_X47_Y10_N15
\conv_morse|next_caracter[11]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clock_counter|internal_clock~clkctrl_outclk\,
	datain => \conv_morse|caracter_reg[10]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \conv_morse|next_caracter\(11));

-- Location: LCFF_X47_Y10_N9
\conv_morse|next_caracter[12]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clock_counter|internal_clock~clkctrl_outclk\,
	datain => \conv_morse|next_caracter[12]~13_combout\,
	sdata => \conv_morse|next_caracter\(11),
	sload => \ALT_INV_inici_morse~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \conv_morse|next_caracter\(12));

-- Location: LCCOMB_X47_Y10_N18
\conv_morse|next_puls~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \conv_morse|next_puls~0_combout\ = (!\reset_morse~regout\ & ((\conv_morse|next_caracter\(12)) # (\inici_morse~regout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001100110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \reset_morse~regout\,
	datac => \conv_morse|next_caracter\(12),
	datad => \inici_morse~regout\,
	combout => \conv_morse|next_puls~0_combout\);

-- Location: LCFF_X47_Y10_N19
\conv_morse|next_puls[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clock_counter|internal_clock~clkctrl_outclk\,
	datain => \conv_morse|next_puls~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \conv_morse|next_puls\(0));

-- Location: LCCOMB_X47_Y10_N6
\LEDG~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \LEDG~0_combout\ = (px_estat(1)) # (px_estat(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => px_estat(1),
	datad => px_estat(0),
	combout => \LEDG~0_combout\);

-- Location: LCCOMB_X46_Y10_N6
\segment|Mux6~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \segment|Mux6~0_combout\ = ((!\SW~combout\(1) & \SW~combout\(2))) # (!\SW~combout\(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101111101010101",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \SW~combout\(0),
	datac => \SW~combout\(1),
	datad => \SW~combout\(2),
	combout => \segment|Mux6~0_combout\);

-- Location: LCCOMB_X46_Y10_N20
\segment|Mux5~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \segment|Mux5~0_combout\ = \SW~combout\(1) $ (((\SW~combout\(0)) # (\SW~combout\(2))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111101011010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \SW~combout\(0),
	datac => \SW~combout\(1),
	datad => \SW~combout\(2),
	combout => \segment|Mux5~0_combout\);

-- Location: LCCOMB_X46_Y10_N10
\segment|Mux4~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \segment|Mux4~0_combout\ = (\SW~combout\(1) & (!\SW~combout\(0) & !\SW~combout\(2))) # (!\SW~combout\(1) & ((\SW~combout\(2))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111101010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \SW~combout\(0),
	datac => \SW~combout\(1),
	datad => \SW~combout\(2),
	combout => \segment|Mux4~0_combout\);

-- Location: LCCOMB_X46_Y10_N24
\segment|Mux3~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \segment|Mux3~0_combout\ = (\SW~combout\(0) & ((\SW~combout\(2)))) # (!\SW~combout\(0) & (!\SW~combout\(1) & !\SW~combout\(2)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101000000101",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \SW~combout\(0),
	datac => \SW~combout\(1),
	datad => \SW~combout\(2),
	combout => \segment|Mux3~0_combout\);

-- Location: LCCOMB_X46_Y10_N18
\segment|Mux2~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \segment|Mux2~0_combout\ = (!\SW~combout\(0) & (\SW~combout\(1) & \SW~combout\(2)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \SW~combout\(0),
	datac => \SW~combout\(1),
	datad => \SW~combout\(2),
	combout => \segment|Mux2~0_combout\);

-- Location: LCCOMB_X46_Y10_N16
\segment|Mux1~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \segment|Mux1~0_combout\ = (\SW~combout\(0) & (\SW~combout\(1) & !\SW~combout\(2)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \SW~combout\(0),
	datac => \SW~combout\(1),
	datad => \SW~combout\(2),
	combout => \segment|Mux1~0_combout\);

-- Location: LCCOMB_X46_Y10_N14
\segment|Mux0~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \segment|Mux0~0_combout\ = (!\SW~combout\(0) & (\SW~combout\(1) & !\SW~combout\(2)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000001010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \SW~combout\(0),
	datac => \SW~combout\(1),
	datad => \SW~combout\(2),
	combout => \segment|Mux0~0_combout\);

-- Location: PIN_R20,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\LEDR[0]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \conv_morse|next_puls\(0),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_LEDR(0));

-- Location: PIN_U22,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\LEDG[0]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \ALT_INV_LEDG~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_LEDG(0));

-- Location: PIN_J2,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\HEX0[0]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \segment|ALT_INV_Mux6~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_HEX0(0));

-- Location: PIN_J1,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\HEX0[1]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \segment|Mux5~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_HEX0(1));

-- Location: PIN_H2,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\HEX0[2]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \segment|Mux4~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_HEX0(2));

-- Location: PIN_H1,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\HEX0[3]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \segment|Mux3~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_HEX0(3));

-- Location: PIN_F2,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\HEX0[4]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \segment|Mux2~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_HEX0(4));

-- Location: PIN_F1,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\HEX0[5]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \segment|Mux1~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_HEX0(5));

-- Location: PIN_E2,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\HEX0[6]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \segment|Mux0~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_HEX0(6));
END structure;


