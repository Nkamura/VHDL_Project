library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity un_controle_tb is
end;

architecture a_un_controle_tb of un_controle_tb is
	component un_controle
		port(clk : in std_logic;
			 reset_t: in std_logic
		);
	end component;
	
	constant period_time : time     := 100 ns;
    signal finished      : std_logic := '0';

	signal reset_t, clk : std_logic;
	
	begin
		uut: un_controle port map(
			clk => clk,
			reset_t => reset_t
		);
		
		reset_global: process
		begin
		reset_t <= '1';
		wait for period_time*2;
		reset_t <= '0';
		wait;
		end process;
			
		sim_time_proc : process
        begin
            wait for 100 us;
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
            wait for 500 ns;
			wait;
		end process;
	end architecture a_un_controle_tb;
			
			