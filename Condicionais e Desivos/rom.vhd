library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    port(estado : unsigned (1 downto 0); 
    clk : in std_logic;
    endereco : in unsigned(6 downto 0);
    dado : out unsigned(17 downto 0)
    );
end entity;

architecture a_rom of rom is
 type mem is array (0 to 127) of unsigned(17 downto 0);
 constant conteudo_rom : mem := (

        0 => "000100011110000001",
        1 => "000100000001000010",
        2 => "000100000000000011",
        3 => "000100000000000100",
        4 => "001000000100011100",
        5 => "001000000011010011",
        6 => "010101000010011001",
        7 => "010000000000100101",
        others => (others=>'0')
    );
    begin
        process(clk, estado)
        begin
            if(rising_edge(clk)) and (estado = "00") then
                dado <= conteudo_rom(to_integer(endereco));
            end if;
        end process;
end architecture;
       
