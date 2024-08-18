--**********************************************************************************
--* Blocco HW per arrotondamento e scalamento di numeri signed fixed point
--* Arrotondamento in forma Q1.23 secondo la tecnica del rounding to nearest even
--* Scalamento secondo la tecnica del "Unconditional Block Floating Point Scaling"
--* Si assume che lo scalamento da implementare sia sempre di 1 bit
--**********************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.fixed_pkg.all;

entity rounder_sfixed is
    generic (
        M : integer := 3; -- MSB
        N : integer := 50 -- lunghezza numero [bit]
    );
    port (
        DR : in sfixed(M downto (M - N + 1)); -- ingresso (default Q4.46)
        QR : out sfixed(0 downto -23)         -- uscita Q1.23
    );
end entity rounder_sfixed;

architecture structure of rounder_sfixed is

    -- definizione segnali interni
    signal x1, x2, x3 : std_logic;            -- bit -23, -24 e -25 di DR
    signal mA, mB, mC : std_logic;            -- minterm
    signal A, B, C, f : sfixed(3 downto -23); -- Q4.23
    signal LSB_one    : sfixed(2 downto -23); -- Q2.23

begin

    x1 <= DR(-23);
    x2 <= DR(-24);
    x3 <= DR(-25);

    -- somme di minterm ottenute dalla K-map
    mA <= (not x1) and ((not x2) or (x2 and (not x3)));
    mB <= (x1 and (not x2)) or ((not x1) and x2 and x3);
    mC <= x1 and x2;

    -- possibili risultati del rounding to nearest even in funzione di x1, x2 e x3
    A       <= DR(3 downto -23);
    B       <= DR(3 downto -22) & '1';
    LSB_one <= (-23 => '1', others => '0');
    C       <= DR(2 downto -23) + LSB_one;

    -- process per scegliere il valore di f tra A, B e C
    -- f = (mA * A) + (mB * B) + (mC * C)
    ROUND_PROCESS : process (mA, mB, mC, A, B, C)
    begin
        if (mA = '1') then
            f <= A;
        elsif (mB = '1') then
            f <= B;
        elsif (mC = '1') then
            f <= C;
        end if;
    end process ROUND_PROCESS;

    -- eliminazione dei bit 3 e 2 + scalamento di 1 bit per ricondursi alla forma Q1.23
    QR <= f(1 downto -22);

end architecture structure;