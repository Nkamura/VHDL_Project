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
        2 => "000110101010000011",
        3 => "000100000001000100",
        4 => "000100000010000101",
        5 => "000100000011000110",
        6 => "000100000100000100",
        7 => "011100000000001110",
        8 => "011000000000010110",
        9 => "011100000000001110",              
        10 => "000000000000000000",
        12 => "000100000000000101",
        13 => "000100000000000101",
        14 => "000100000000000101",
        15 => "000100000000000101",
        16 => "000100000000000101",
        17 => "000100000000000101",
        18 => "000100000000000101",
        19 => "000100000000000101",
        20 => "000100000000000101",
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
       
