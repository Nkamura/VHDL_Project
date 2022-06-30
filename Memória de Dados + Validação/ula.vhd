library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula is
	port (	clk : in std_logic;
			estado : in unsigned (1 downto 0);
			x : in unsigned(17 downto 0);
			y : in unsigned(17 downto 0);
			saida: out unsigned(17 downto 0);
			opcode : in unsigned (3 downto 0);
			CY : out std_logic
);
end entity;

architecture a_ula of ula is
	signal result : unsigned (17 downto 0);
	begin
		process(clk, estado)
		begin
			if rising_edge(clk) and estado = "10" then
				saida <= result;
			end if;
		end process;

		result <= x + y when opcode = "0001" or opcode = "0010" else
		x - y when opcode = "0011" else 
		x when opcode = "0100" else
		x when opcode = "0110" or opcode = "0111" else
		"000000000000000000";

		CY <= '1' when x < y  and opcode = "0101" else '0';




end architecture;
