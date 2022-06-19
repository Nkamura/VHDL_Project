ghdl -a banco_reg.vhd
ghdl -a maq_estados.vhd
ghdl -a pc.vhd
ghdl -a rom.vhd
ghdl -a ula.vhd
ghdl -a un_controle.vhd
ghdl -a un_controle_tb.vhd
ghdl -r un_controle_tb --wave=un_controle_tb.ghw
gtkwave un_controle_tb.ghw