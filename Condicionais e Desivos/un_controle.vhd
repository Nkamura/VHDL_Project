library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity un_controle is
	port(clk : in std_logic;
		reset_t : in std_logic
	);
end entity;

architecture a_un_controle of un_controle is
	component pc 
		port(estado : in unsigned(1 downto 0);
			 clk : in std_logic;
			 data_in : in unsigned (6 downto 0);
			 data_out : out unsigned (6 downto 0);
			 reset : in std_logic
		);
	end component;
	component rom
		port(estado : in unsigned (1 downto 0);
			clk : in std_logic;
			endereco : in unsigned (6 downto 0);
			dado : out unsigned (17 downto 0)
		);
	end component;
	component maq_estados
		port(rst : in std_logic;
			clk : in std_logic;
			estado : out unsigned (1 downto 0)
		);
	end component;	
	component banco_reg is
		port(estado : in unsigned(1 downto 0);
			readreg1 : in unsigned (2 downto 0);
			readreg2 : in unsigned (2 downto 0);
			selectwritereg : in unsigned (2 downto 0);
			writereg : in unsigned (17 downto 0);
			wr_en : in std_logic;
			clk : in std_logic;
			rst : in std_logic;
			readdata1 : out unsigned (17 downto 0);
			readdata2 : out unsigned (17 downto 0)
   		);
	end component;
	component ula is
		port(clk : in std_logic;
			estado : in unsigned (1 downto 0);
			x : in unsigned(17 downto 0);
			y : in unsigned(17 downto 0);
			saida: out unsigned(17 downto 0);
			opcode : in unsigned (3 downto 0);
			CY : out std_logic
		);
	end component;
		signal in1, in2, saida_ula, reg_instr, readdata1, readdata2, to18bits, writereg: unsigned (17 downto 0);
		signal saida_pc, entrada_pc, endereco_jump  : unsigned (6 downto 0);
		signal opcode : unsigned (3 downto 0);
		signal selectwritereg, readreg1, readreg2 : unsigned (2 downto 0);
		signal estado : unsigned (1 downto 0);
		signal negative_branch : unsigned (0 downto 0);
		signal wr_en, jump_en, addi_en, add_en, subC_en, mov_en, bl_en, CY: std_logic;

	begin
		liga_estado : maq_estados port map (rst => reset_t, clk => clk, estado => estado);

		liga_rom : rom port map (clk => clk, endereco => saida_pc, dado => reg_instr,
		estado => estado);

		liga_pc : pc port map (data_out => saida_pc, clk => clk,
		data_in => entrada_pc, reset => reset_t, estado => estado);

		liga_reg : banco_reg port map (clk => clk, rst => reset_t, wr_en => wr_en,
		writereg => writereg, selectwritereg => selectwritereg, readdata1 => readdata1,
		readdata2 => readdata2, readreg1 => readreg1, readreg2 => readreg2, estado => estado);
		
		liga_ula : ula port map (clk => clk, estado => estado, x => in1, y => in2, saida => saida_ula,
		opcode => opcode, CY => CY);

		opcode <= reg_instr(17 downto 14);
		negative_branch <= reg_instr(12 downto 12);
		jump_en <= '1' when opcode = "1111" else '0';
		addi_en <= '1' when opcode = "0001" else '0';
		add_en <= '1' when opcode = "0010" else '0';
		subC_en <= '1' when opcode = "0011" else '0';
		mov_en <= '1' when opcode = "0100" else '0';
		bl_en <= '1' when opcode = "0101" else '0';

		wr_en <= '1' when addi_en = '1' or add_en = '1' or subC_en = '1' or mov_en = '1' else 
		'0';

		readreg1 <= reg_instr(5 downto 3) when addi_en = '1' or add_en = '1' or subC_en = '1'
		or mov_en = '1' or bl_en = '1' else 
					"000";
		readreg2 <= reg_instr(2 downto 0) when addi_en = '1' or add_en = '1' or subC_en = '1'
		or mov_en = '1' or bl_en = '1' else
					"000";

		to18bits <= resize(reg_instr(13 downto 6), to18bits'length) when addi_en = '1' or subC_en = '1' else "000000000000000000";

		in2 <= 	to18bits when addi_en = '1' or subC_en = '1' else
				readdata2 when add_en = '1' or mov_en = '1' or bl_en = '1' else 
				"000000000000000000";

		in1 <= readdata1 when addi_en = '1' or add_en = '1' or subC_en = '1' or mov_en = '1'
		or bl_en = '1' else 
				"000000000000000000";

		selectwritereg <= readreg2 when addi_en = '1' or subC_en = '1' or mov_en = '1' else 
						reg_instr(8 downto 6) when add_en = '1' else
						 "000";

		writereg <=	saida_ula when addi_en = '1' or add_en = '1' or subC_en = '1' or mov_en = '1' else
					"000000000000000000";

		entrada_pc <= reg_instr(6 downto 0) when jump_en = '1' else 
		saida_pc + reg_instr(11 downto 6) when CY = '1' and bl_en = '1' and negative_branch = "0" else
		saida_pc - reg_instr(11 downto 6) when CY = '1' and bl_en = '1' and negative_branch = "1" else
		saida_pc + "0000001";
		
end architecture;