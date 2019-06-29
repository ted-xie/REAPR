library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Reducer is
    generic (C0_LENGTH : INTEGER := 16;
            C1_LENGTH : INTEGER := 16;
            C2_LENGTH : INTEGER := 16;
            C3_LENGTH : INTEGER := 16;
            C4_LENGTH : INTEGER := 16;
            C5_LENGTH : INTEGER := 16;
            C6_LENGTH : INTEGER := 16;
            C7_LENGTH : INTEGER := 16;
            C8_LENGTH : INTEGER := 16;
            C9_LENGTH : INTEGER := 16;
            C0_LENGTHLOG2 : INTEGER := 5;
            C1_LENGTHLOG2 : INTEGER := 5;
            C2_LENGTHLOG2 : INTEGER := 5;
            C3_LENGTHLOG2 : INTEGER := 5;
            C4_LENGTHLOG2 : INTEGER := 5;
            C5_LENGTHLOG2 : INTEGER := 5;
            C6_LENGTHLOG2 : INTEGER := 5;
            C7_LENGTHLOG2 : INTEGER := 5;
            C8_LENGTHLOG2 : INTEGER := 5;
            C9_LENGTHLOG2 : INTEGER := 5
        );

    port (clock : in std_logic;
            reset : in std_logic;
            C0 : in std_logic_vector(C0_LENGTH-1 downto 0);
            C1 : in std_logic_vector(C1_LENGTH-1 downto 0);
            C2 : in std_logic_vector(C2_LENGTH-1 downto 0);
            C3 : in std_logic_vector(C3_LENGTH-1 downto 0);
            C4 : in std_logic_vector(C4_LENGTH-1 downto 0);
            C5 : in std_logic_vector(C5_LENGTH-1 downto 0);
            C6 : in std_logic_vector(C6_LENGTH-1 downto 0);
            C7 : in std_logic_vector(C7_LENGTH-1 downto 0);
            C8 : in std_logic_vector(C8_LENGTH-1 downto 0);
            C9 : in std_logic_vector(C9_LENGTH-1 downto 0);
            C0_sum : out std_logic_vector(C0_LENGTHLOG2-1 downto 0);
            C1_sum : out std_logic_vector(C1_LENGTHLOG2-1 downto 0);
            C2_sum : out std_logic_vector(C2_LENGTHLOG2-1 downto 0);
            C3_sum : out std_logic_vector(C3_LENGTHLOG2-1 downto 0);
            C4_sum : out std_logic_vector(C4_LENGTHLOG2-1 downto 0);
            C5_sum : out std_logic_vector(C5_LENGTHLOG2-1 downto 0);
            C6_sum : out std_logic_vector(C6_LENGTHLOG2-1 downto 0);
            C7_sum : out std_logic_vector(C7_LENGTHLOG2-1 downto 0);
            C8_sum : out std_logic_vector(C8_LENGTHLOG2-1 downto 0);
            C9_sum : out std_logic_vector(C9_LENGTHLOG2-1 downto 0)
    );
end Reducer;

architecture Structure of Reducer is
    -- External component declaration
    component HammingWeight is
        generic (INPUT_LENGTH : INTEGER := 20;
                WEIGHT_LENGTH : INTEGER := 20);
                
        port (din : in std_logic_vector(INPUT_LENGTH-1 downto 0);
                weight : out std_logic_vector(WEIGHT_LENGTH-1 downto 0));
    end component;

    -- Signal declarations
    signal C0_sum_comb : std_logic_vector(C0_LENGTHLOG2-1 downto 0);
    signal C1_sum_comb : std_logic_vector(C1_LENGTHLOG2-1 downto 0);
    signal C2_sum_comb : std_logic_vector(C2_LENGTHLOG2-1 downto 0);
    signal C3_sum_comb : std_logic_vector(C3_LENGTHLOG2-1 downto 0);
    signal C4_sum_comb : std_logic_vector(C4_LENGTHLOG2-1 downto 0);
    signal C5_sum_comb : std_logic_vector(C5_LENGTHLOG2-1 downto 0);
    signal C6_sum_comb : std_logic_vector(C6_LENGTHLOG2-1 downto 0);
    signal C7_sum_comb : std_logic_vector(C7_LENGTHLOG2-1 downto 0);
    signal C8_sum_comb : std_logic_vector(C8_LENGTHLOG2-1 downto 0);
    signal C9_sum_comb : std_logic_vector(C9_LENGTHLOG2-1 downto 0);
begin

    -- Generate combinational hamming weights
    hweight0 : HammingWeight
    generic map (INPUT_LENGTH=>C0_LENGTH,
                WEIGHT_LENGTH=>C0_LENGTHLOG2)
    port map (din=>C0,
                weight=>C0_sum_comb);

    hweight1 : HammingWeight
    generic map (INPUT_LENGTH=>C1_LENGTH,
                WEIGHT_LENGTH=>C1_LENGTHLOG2)
    port map (din=>C1,
                weight=>C1_sum_comb);

    hweight2 : HammingWeight
    generic map (INPUT_LENGTH=>C2_LENGTH,
                WEIGHT_LENGTH=>C2_LENGTHLOG2)
    port map (din=>C2,
                weight=>C2_sum_comb);

    hweight3 : HammingWeight
    generic map (INPUT_LENGTH=>C3_LENGTH,
                WEIGHT_LENGTH=>C3_LENGTHLOG2)
    port map (din=>C3,
                weight=>C3_sum_comb);

    hweight4 : HammingWeight
    generic map (INPUT_LENGTH=>C4_LENGTH,
                WEIGHT_LENGTH=>C4_LENGTHLOG2)
    port map (din=>C4,
                weight=>C4_sum_comb);

    hweight5 : HammingWeight
    generic map (INPUT_LENGTH=>C5_LENGTH,
                WEIGHT_LENGTH=>C5_LENGTHLOG2)
    port map (din=>C5,
                weight=>C5_sum_comb);

    hweight6 : HammingWeight
    generic map (INPUT_LENGTH=>C6_LENGTH,
                WEIGHT_LENGTH=>C6_LENGTHLOG2)
    port map (din=>C6,
                weight=>C6_sum_comb);

    hweight7 : HammingWeight
    generic map (INPUT_LENGTH=>C7_LENGTH,
                WEIGHT_LENGTH=>C7_LENGTHLOG2)
    port map (din=>C7,
                weight=>C7_sum_comb);

    hweight8 : HammingWeight
    generic map (INPUT_LENGTH=>C8_LENGTH,
                WEIGHT_LENGTH=>C8_LENGTHLOG2)
    port map (din=>C8,
                weight=>C8_sum_comb);

    hweight9 : HammingWeight
    generic map (INPUT_LENGTH=>C9_LENGTH,
                WEIGHT_LENGTH=>C9_LENGTHLOG2)
    port map (din=>C9,
                weight=>C9_sum_comb);

    process(clock)
    begin
        if (rising_edge(clock)) then
            if (reset = '1') then
                C0_sum <= (others=>'0');
                C1_sum <= (others=>'0');
                C2_sum <= (others=>'0');
                C3_sum <= (others=>'0');
                C4_sum <= (others=>'0');
                C5_sum <= (others=>'0');
                C6_sum <= (others=>'0');
                C7_sum <= (others=>'0');
                C8_sum <= (others=>'0');
                C9_sum <= (others=>'0');
            else
                C0_sum <= C0_sum_comb;
                C1_sum <= C1_sum_comb;
                C2_sum <= C2_sum_comb;
                C3_sum <= C3_sum_comb;
                C4_sum <= C4_sum_comb;
                C5_sum <= C5_sum_comb;
                C6_sum <= C6_sum_comb;
                C7_sum <= C7_sum_comb;
                C8_sum <= C8_sum_comb;
                C9_sum <= C9_sum_comb;
            end if;
        end if;
    end process;
end architecture;
