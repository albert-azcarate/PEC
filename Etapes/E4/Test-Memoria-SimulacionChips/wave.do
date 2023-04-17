delete wave *
restart -f
onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label Clock /test_sisa/SoC/clk(2)
add wave -noupdate -label F/D /test_sisa/SoC/processor/UC/multi0/estat
add wave -noupdate -label PC /test_sisa/SoC/processor/UC/regPC
add wave -noupdate -label PC /test_sisa/SoC/processor/UC/newPC
add wave -noupdate -label Instruccion /test_sisa/SoC/processor/UC/control_ins/ir_interna
add wave -noupdate -label Operacio /test_sisa/SoC/processor/UC/control_ins/Instruccio
add wave -noupdate -label Funcio /test_sisa/SoC/processor/UC/control_ins/operacio
add wave -noupdate -divider SoC
add wave -noupdate -group SRAM_C /test_sisa/SoC/SRAM_ADDR
add wave -noupdate -group SRAM_C /test_sisa/SoC/SRAM_DQ
add wave -noupdate -group SRAM_C /test_sisa/SoC/SRAM_UB_N
add wave -noupdate -group SRAM_C /test_sisa/SoC/SRAM_LB_N
add wave -noupdate -group SRAM_C /test_sisa/SoC/SRAM_CE_N
add wave -noupdate -group SRAM_C /test_sisa/SoC/SRAM_OE_N
add wave -noupdate -group SRAM_C /test_sisa/SoC/SRAM_WE_N
add wave -noupdate -group proc_mem_int /test_sisa/SoC/addr_proc_to_mem
add wave -noupdate -group proc_mem_int /test_sisa/SoC/word_byte_to_mem
add wave -noupdate -group proc_mem_int /test_sisa/SoC/wr_m_to_mem
add wave -noupdate -group proc_mem_int /test_sisa/SoC/data_wr_to_mem
add wave -noupdate /test_sisa/SoC/rd_data_to_proc
add wave -noupdate /test_sisa/SoC/SW
add wave -noupdate -divider Processor
add wave -noupdate -group Control /test_sisa/SoC/processor/UC/control_ins/ir
add wave -noupdate -group Control /test_sisa/SoC/processor/UC/control_ins/op
add wave -noupdate -group Control /test_sisa/SoC/processor/UC/control_ins/f
add wave -noupdate -group Control /test_sisa/SoC/processor/UC/control_ins/addr_a
add wave -noupdate -group Control /test_sisa/SoC/processor/UC/control_ins/addr_b
add wave -noupdate -group Control /test_sisa/SoC/processor/UC/control_ins/addr_d
add wave -noupdate -group Control /test_sisa/SoC/processor/UC/control_ins/immed
add wave -noupdate -group Control /test_sisa/SoC/processor/UC/control_ins/in_d
add wave -noupdate -group Control /test_sisa/SoC/processor/UC/control_ins/immed_x2
add wave -noupdate -group Control /test_sisa/SoC/processor/UC/control_ins/immed_or_reg
add wave -noupdate -group Control /test_sisa/SoC/processor/UC/control_ins/Instruccio
add wave -noupdate -group Control /test_sisa/SoC/processor/UC/control_ins/op_code_ir
add wave -noupdate -group Multi /test_sisa/SoC/processor/UC/multi0/ldpc_l
add wave -noupdate -group Multi /test_sisa/SoC/processor/UC/multi0/wrd_l
add wave -noupdate -group Multi /test_sisa/SoC/processor/UC/multi0/wr_m_l
add wave -noupdate -group Multi /test_sisa/SoC/processor/UC/multi0/w_b
add wave -noupdate -group Multi /test_sisa/SoC/processor/UC/multi0/halt_cont
add wave -noupdate -group Multi /test_sisa/SoC/processor/UC/multi0/ldpc
add wave -noupdate -group Multi /test_sisa/SoC/processor/UC/multi0/wrd
add wave -noupdate -group Multi /test_sisa/SoC/processor/UC/multi0/wr_m
add wave -noupdate -group Multi /test_sisa/SoC/processor/UC/multi0/ldir
add wave -noupdate -group Multi /test_sisa/SoC/processor/UC/multi0/ins_dad
add wave -noupdate -group Multi /test_sisa/SoC/processor/UC/multi0/word_byte
add wave -noupdate -group Multi /test_sisa/SoC/processor/UC/multi0/estat
add wave -noupdate -divider PATH
add wave -noupdate -group ALU /test_sisa/SoC/processor/PATH/alu_unit/x
add wave -noupdate -group ALU /test_sisa/SoC/processor/PATH/alu_unit/y
add wave -noupdate -group ALU /test_sisa/SoC/processor/PATH/alu_unit/op
add wave -noupdate -group ALU /test_sisa/SoC/processor/PATH/alu_unit/f
add wave -noupdate -group ALU /test_sisa/SoC/processor/PATH/alu_unit/w
add wave -noupdate -group ALU /test_sisa/SoC/processor/PATH/alu_unit/z
add wave -noupdate -group ALU /test_sisa/SoC/processor/PATH/alu_unit/ext_signe
add wave -noupdate -group ALU /test_sisa/SoC/processor/PATH/alu_unit/mul
add wave -noupdate -group ALU /test_sisa/SoC/processor/PATH/alu_unit/mulu
add wave -noupdate -group ALU /test_sisa/SoC/processor/PATH/alu_unit/shift
add wave -noupdate -group Reg_Bank /test_sisa/SoC/processor/PATH/register_bank/wrd
add wave -noupdate -group Reg_Bank /test_sisa/SoC/processor/PATH/register_bank/d
add wave -noupdate -group Reg_Bank /test_sisa/SoC/processor/PATH/register_bank/addr_a
add wave -noupdate -group Reg_Bank /test_sisa/SoC/processor/PATH/register_bank/addr_b
add wave -noupdate -group Reg_Bank /test_sisa/SoC/processor/PATH/register_bank/addr_d
add wave -noupdate -group Reg_Bank /test_sisa/SoC/processor/PATH/register_bank/a
add wave -noupdate -group Reg_Bank /test_sisa/SoC/processor/PATH/register_bank/b
add wave -noupdate -divider Registres
add wave -noupdate -label Registres -expand /test_sisa/SoC/processor/PATH/register_bank/reg_vector
add wave -noupdate -divider Memoria
add wave -noupdate -label Memoria {/test_sisa/mem0/mem_array(28 downto 0)}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {12000 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 80
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
radix -hexadecimal
echo Running Simulation
run 69200ns
WaveRestoreZoom {0 ps} {14950 ns}
