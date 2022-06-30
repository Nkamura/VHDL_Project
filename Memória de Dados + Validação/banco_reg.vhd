library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_reg is
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
end entity;

architecture a_banco_reg of banco_reg is
    signal reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7 : unsigned(17 downto 0);
begin
    
    process(clk, rst, wr_en)
    begin
        if rst = '1' then
            reg0 <= "000000000000000000";
            reg1 <= "000000000000000000";
            reg2 <= "000000000000000000";
            reg3 <= "000000000000000000";
            reg4 <= "000000000000000000";
            reg5 <= "000000000000000000";
            reg6 <= "000000000000000000";
            reg7 <= "000000000000000000";
        elsif wr_en='1' then
            if rising_edge(clk) and estado = "00" then
                if selectwritereg = "001" then
                    reg1 <= writereg;
                elsif selectwritereg = "010" then
                    reg2 <= writereg;
                elsif selectwritereg = "011" then
                    reg3 <= writereg;
                elsif selectwritereg = "100" then
                    reg4 <= writereg;
                elsif selectwritereg = "101" then
                    reg5 <= writereg;
                elsif selectwritereg = "110" then
                    reg6 <= writereg;
                elsif selectwritereg = "111" then
                    reg7 <= writereg;
                end if;
            end if;
        end if;
    end process;


    readdata1 <= reg0 when readreg1 = "000" else
                 reg1 when readreg1 = "001" else
                 reg2 when readreg1 = "010" else
                 reg3 when readreg1 = "011" else
                 reg4 when readreg1 = "100" else
                 reg5 when readreg1 = "101" else
                 reg6 when readreg1 = "110" else
                 reg7 when readreg1 = "111" else
                 "000000000000000000";
    readdata2 <= reg0 when readreg2 = "000" else
                 reg1 when readreg2 = "001" else
                 reg2 when readreg2 = "010" else
                 reg3 when readreg2 = "011" else
                 reg4 when readreg2 = "100" else
                 reg5 when readreg2 = "101" else
                 reg6 when readreg2 = "110" else
                 reg7 when readreg2 = "111" else
                 "000000000000000000";
end architecture;

