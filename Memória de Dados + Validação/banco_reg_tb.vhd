library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_reg_tb is
end;

architecture a_banco_reg_tb of banco_reg_tb is
	component banco_reg
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
	
	constant period_time : time     := 100 ns;
    signal finished      : std_logic := '0';

	signal rst, wr_en, clk : std_logic;
    signal readreg1, readreg2, selectwritereg : unsigned (2 downto 0);
    signal writereg, readdata1, readdata2 : unsigned (17 downto 0);
    signal estado : unsigned (1 downto 0);
	
	begin
		uut: banco_reg port map(
			wr_en => wr_en,
			clk => clk,
			rst => rst,
            writereg => writereg,
            readdata1 => readdata1,
            readdata2 => readdata2,
            readreg1 => readreg1,
            readreg2 => readreg2,
            selectwritereg => selectwritereg,
            estado => estado
		);
		
		reset_global: process
		begin
            rst <= '1';
            wait for period_time*2;
            rst <= '0';
		    wait;
		end process;
			
		sim_time_proc : process
        begin
            wait for 10 us;
            finished <= '1';
            wait;
        end process sim_time_proc;
    
        clk_proc : process
        begin
            while finished /= '1' loop
                clk <= '0';
                wait for period_time/2;
                clk <= '1';
                wait for period_time/2;
            end loop;
            wait;
        end process clk_proc;
		
		process
        begin
            wait for 200 ns;
			wr_en <= '1';
            selectwritereg <= "001";
            writereg <= "111100000000000100";
            readreg1 <= "001";
            estado <= "00";
            wait for 200 ns;
            writereg <= "111100000000100100";
            readreg1 <= "001";
            estado <= "01";
			wait for 200 ns;
            writereg <= "111100000010100100";
            readreg1 <= "001";
            estado <= "11";
			wait for 200 ns;
            writereg <= "111100010000100100";
            readreg1 <= "001";
            estado <= "00";
			wait for 200 ns;
            wait;
		end process;
	end architecture a_banco_reg_tb;