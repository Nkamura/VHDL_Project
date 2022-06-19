library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc is
 port(estado : in unsigned(1 downto 0);
     clk : in std_logic;
     data_in : in unsigned (6 downto 0);
     data_out : out unsigned (6 downto 0);
	 reset : in std_logic
    );
end entity;
architecture a_pc of pc is
    signal progcounter : unsigned (6 downto 0);
begin 
    process(clk, reset, estado)
    begin
		if reset = '1' then
			progcounter <= "0000000";
        elsif rising_edge(clk) and (estado = "01") then
             progcounter <= data_in;
        end if;
    end process;
    data_out <= progcounter;
end architecture;