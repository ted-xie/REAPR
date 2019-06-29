library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Voter is
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
            C9_LENGTHLOG2 : INTEGER := 5;
            VOTE_LENGTH : INTEGER := 32;
            ID_LENGTH : INTEGER := 8 
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
            result : out std_logic_vector(VOTE_LENGTH-1 downto 0)
    );
end Voter;
   
architecture Structure of Voter is
    -- Component instantiations
    component Reducer is
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
    end component;

    component VoterStage is
        generic (C0_SUM_LENGTH : INTEGER := 4;
                C1_SUM_LENGTH : INTEGER := 4;
                C2_SUM_LENGTH : INTEGER := 4;
                C3_SUM_LENGTH : INTEGER := 4;
                C4_SUM_LENGTH : INTEGER := 4;
                C5_SUM_LENGTH : INTEGER := 4;
                C6_SUM_LENGTH : INTEGER := 4;
                C7_SUM_LENGTH : INTEGER := 4;
                C8_SUM_LENGTH : INTEGER := 4;
                C9_SUM_LENGTH : INTEGER := 4;
                VOTE_LENGTH : INTEGER := 8; -- should be log2(longest classification vec)
                ID_LENGTH : INTEGER := 8; -- should be byte-aligned
                ID : INTEGER := 0
                );
    
        port (clock : in std_logic;
                reset : in std_logic;
                C0_sum : in std_logic_vector(C0_SUM_LENGTH-1 downto 0); 
                C1_sum : in std_logic_vector(C1_SUM_LENGTH-1 downto 0); 
                C2_sum : in std_logic_vector(C2_SUM_LENGTH-1 downto 0); 
                C3_sum : in std_logic_vector(C3_SUM_LENGTH-1 downto 0); 
                C4_sum : in std_logic_vector(C4_SUM_LENGTH-1 downto 0); 
                C5_sum : in std_logic_vector(C5_SUM_LENGTH-1 downto 0); 
                C6_sum : in std_logic_vector(C6_SUM_LENGTH-1 downto 0); 
                C7_sum : in std_logic_vector(C7_SUM_LENGTH-1 downto 0); 
                C8_sum : in std_logic_vector(C8_SUM_LENGTH-1 downto 0); 
                C9_sum : in std_logic_vector(C9_SUM_LENGTH-1 downto 0); 
                ID_in : in std_logic_vector(ID_LENGTH-1 downto 0);
                vote_in : in std_logic_vector(VOTE_LENGTH-1 downto 0);
                C0_sum_out : out std_logic_vector(C0_SUM_LENGTH-1 downto 0);
                C1_sum_out : out std_logic_vector(C1_SUM_LENGTH-1 downto 0);
                C2_sum_out : out std_logic_vector(C2_SUM_LENGTH-1 downto 0);
                C3_sum_out : out std_logic_vector(C3_SUM_LENGTH-1 downto 0);
                C4_sum_out : out std_logic_vector(C4_SUM_LENGTH-1 downto 0);
                C5_sum_out : out std_logic_vector(C5_SUM_LENGTH-1 downto 0);
                C6_sum_out : out std_logic_vector(C6_SUM_LENGTH-1 downto 0);
                C7_sum_out : out std_logic_vector(C7_SUM_LENGTH-1 downto 0);
                C8_sum_out : out std_logic_vector(C8_SUM_LENGTH-1 downto 0);
                C9_sum_out : out std_logic_vector(C9_SUM_LENGTH-1 downto 0);
                ID_out : out std_logic_vector(ID_LENGTH-1 downto 0);
                vote_out : out std_logic_vector(VOTE_LENGTH-1 downto 0)
                );
    end component;
    -- Reducer output signals
    signal reduc_C0_sum : std_logic_vector(C0_LENGTHLOG2-1 downto 0);
    signal reduc_C1_sum : std_logic_vector(C1_LENGTHLOG2-1 downto 0);
    signal reduc_C2_sum : std_logic_vector(C2_LENGTHLOG2-1 downto 0);
    signal reduc_C3_sum : std_logic_vector(C3_LENGTHLOG2-1 downto 0);
    signal reduc_C4_sum : std_logic_vector(C4_LENGTHLOG2-1 downto 0);
    signal reduc_C5_sum : std_logic_vector(C5_LENGTHLOG2-1 downto 0);
    signal reduc_C6_sum : std_logic_vector(C6_LENGTHLOG2-1 downto 0);
    signal reduc_C7_sum : std_logic_vector(C7_LENGTHLOG2-1 downto 0);
    signal reduc_C8_sum : std_logic_vector(C8_LENGTHLOG2-1 downto 0);
    signal reduc_C9_sum : std_logic_vector(C9_LENGTHLOG2-1 downto 0);
   
    -- Voter stage 0 signals
    signal vote0_ID_in : std_logic_vector(ID_LENGTH-1 downto 0) := (others=>'0');
    signal vote0_vote_in : std_logic_vector(VOTE_LENGTH-1 downto 0) := (others=>'0');
    signal vote0_C0_sum_out : std_logic_vector(C0_LENGTHLOG2-1 downto 0);
    signal vote0_C1_sum_out : std_logic_vector(C1_LENGTHLOG2-1 downto 0);
    signal vote0_C2_sum_out : std_logic_vector(C2_LENGTHLOG2-1 downto 0);
    signal vote0_C3_sum_out : std_logic_vector(C3_LENGTHLOG2-1 downto 0);
    signal vote0_C4_sum_out : std_logic_vector(C4_LENGTHLOG2-1 downto 0);
    signal vote0_C5_sum_out : std_logic_vector(C5_LENGTHLOG2-1 downto 0);
    signal vote0_C6_sum_out : std_logic_vector(C6_LENGTHLOG2-1 downto 0);
    signal vote0_C7_sum_out : std_logic_vector(C7_LENGTHLOG2-1 downto 0);
    signal vote0_C8_sum_out : std_logic_vector(C8_LENGTHLOG2-1 downto 0);
    signal vote0_C9_sum_out : std_logic_vector(C9_LENGTHLOG2-1 downto 0);
    signal vote0_ID_out : std_logic_vector(ID_LENGTH-1 downto 0);
    signal vote0_vote_out : std_logic_vector(VOTE_LENGTH-1 downto 0);

    -- Voter stage 1 signals
    signal vote1_C0_sum_out : std_logic_vector(C0_LENGTHLOG2-1 downto 0);
    signal vote1_C1_sum_out : std_logic_vector(C1_LENGTHLOG2-1 downto 0);
    signal vote1_C2_sum_out : std_logic_vector(C2_LENGTHLOG2-1 downto 0);
    signal vote1_C3_sum_out : std_logic_vector(C3_LENGTHLOG2-1 downto 0);
    signal vote1_C4_sum_out : std_logic_vector(C4_LENGTHLOG2-1 downto 0);
    signal vote1_C5_sum_out : std_logic_vector(C5_LENGTHLOG2-1 downto 0);
    signal vote1_C6_sum_out : std_logic_vector(C6_LENGTHLOG2-1 downto 0);
    signal vote1_C7_sum_out : std_logic_vector(C7_LENGTHLOG2-1 downto 0);
    signal vote1_C8_sum_out : std_logic_vector(C8_LENGTHLOG2-1 downto 0);
    signal vote1_C9_sum_out : std_logic_vector(C9_LENGTHLOG2-1 downto 0);
    signal vote1_ID_out : std_logic_vector(ID_LENGTH-1 downto 0);
    signal vote1_vote_out : std_logic_vector(VOTE_LENGTH-1 downto 0);

    -- Voter stage 2 signals
    signal vote2_C0_sum_out : std_logic_vector(C0_LENGTHLOG2-1 downto 0);
    signal vote2_C1_sum_out : std_logic_vector(C1_LENGTHLOG2-1 downto 0);
    signal vote2_C2_sum_out : std_logic_vector(C2_LENGTHLOG2-1 downto 0);
    signal vote2_C3_sum_out : std_logic_vector(C3_LENGTHLOG2-1 downto 0);
    signal vote2_C4_sum_out : std_logic_vector(C4_LENGTHLOG2-1 downto 0);
    signal vote2_C5_sum_out : std_logic_vector(C5_LENGTHLOG2-1 downto 0);
    signal vote2_C6_sum_out : std_logic_vector(C6_LENGTHLOG2-1 downto 0);
    signal vote2_C7_sum_out : std_logic_vector(C7_LENGTHLOG2-1 downto 0);
    signal vote2_C8_sum_out : std_logic_vector(C8_LENGTHLOG2-1 downto 0);
    signal vote2_C9_sum_out : std_logic_vector(C9_LENGTHLOG2-1 downto 0);
    signal vote2_ID_out : std_logic_vector(ID_LENGTH-1 downto 0);
    signal vote2_vote_out : std_logic_vector(VOTE_LENGTH-1 downto 0);

    -- Voter stage 3 signals
    signal vote3_C0_sum_out : std_logic_vector(C0_LENGTHLOG2-1 downto 0);
    signal vote3_C1_sum_out : std_logic_vector(C1_LENGTHLOG2-1 downto 0);
    signal vote3_C2_sum_out : std_logic_vector(C2_LENGTHLOG2-1 downto 0);
    signal vote3_C3_sum_out : std_logic_vector(C3_LENGTHLOG2-1 downto 0);
    signal vote3_C4_sum_out : std_logic_vector(C4_LENGTHLOG2-1 downto 0);
    signal vote3_C5_sum_out : std_logic_vector(C5_LENGTHLOG2-1 downto 0);
    signal vote3_C6_sum_out : std_logic_vector(C6_LENGTHLOG2-1 downto 0);
    signal vote3_C7_sum_out : std_logic_vector(C7_LENGTHLOG2-1 downto 0);
    signal vote3_C8_sum_out : std_logic_vector(C8_LENGTHLOG2-1 downto 0);
    signal vote3_C9_sum_out : std_logic_vector(C9_LENGTHLOG2-1 downto 0);
    signal vote3_ID_out : std_logic_vector(ID_LENGTH-1 downto 0);
    signal vote3_vote_out : std_logic_vector(VOTE_LENGTH-1 downto 0);
    
    -- Voter stage 4 signals
    signal vote4_C0_sum_out : std_logic_vector(C0_LENGTHLOG2-1 downto 0);
    signal vote4_C1_sum_out : std_logic_vector(C1_LENGTHLOG2-1 downto 0);
    signal vote4_C2_sum_out : std_logic_vector(C2_LENGTHLOG2-1 downto 0);
    signal vote4_C3_sum_out : std_logic_vector(C3_LENGTHLOG2-1 downto 0);
    signal vote4_C4_sum_out : std_logic_vector(C4_LENGTHLOG2-1 downto 0);
    signal vote4_C5_sum_out : std_logic_vector(C5_LENGTHLOG2-1 downto 0);
    signal vote4_C6_sum_out : std_logic_vector(C6_LENGTHLOG2-1 downto 0);
    signal vote4_C7_sum_out : std_logic_vector(C7_LENGTHLOG2-1 downto 0);
    signal vote4_C8_sum_out : std_logic_vector(C8_LENGTHLOG2-1 downto 0);
    signal vote4_C9_sum_out : std_logic_vector(C9_LENGTHLOG2-1 downto 0);
    signal vote4_ID_out : std_logic_vector(ID_LENGTH-1 downto 0);
    signal vote4_vote_out : std_logic_vector(VOTE_LENGTH-1 downto 0);

    -- Voter stage 5 signals
    signal vote5_C0_sum_out : std_logic_vector(C0_LENGTHLOG2-1 downto 0);
    signal vote5_C1_sum_out : std_logic_vector(C1_LENGTHLOG2-1 downto 0);
    signal vote5_C2_sum_out : std_logic_vector(C2_LENGTHLOG2-1 downto 0);
    signal vote5_C3_sum_out : std_logic_vector(C3_LENGTHLOG2-1 downto 0);
    signal vote5_C4_sum_out : std_logic_vector(C4_LENGTHLOG2-1 downto 0);
    signal vote5_C5_sum_out : std_logic_vector(C5_LENGTHLOG2-1 downto 0);
    signal vote5_C6_sum_out : std_logic_vector(C6_LENGTHLOG2-1 downto 0);
    signal vote5_C7_sum_out : std_logic_vector(C7_LENGTHLOG2-1 downto 0);
    signal vote5_C8_sum_out : std_logic_vector(C8_LENGTHLOG2-1 downto 0);
    signal vote5_C9_sum_out : std_logic_vector(C9_LENGTHLOG2-1 downto 0);
    signal vote5_ID_out : std_logic_vector(ID_LENGTH-1 downto 0);
    signal vote5_vote_out : std_logic_vector(VOTE_LENGTH-1 downto 0);

    -- Voter stage 6 signals
    signal vote6_C0_sum_out : std_logic_vector(C0_LENGTHLOG2-1 downto 0);
    signal vote6_C1_sum_out : std_logic_vector(C1_LENGTHLOG2-1 downto 0);
    signal vote6_C2_sum_out : std_logic_vector(C2_LENGTHLOG2-1 downto 0);
    signal vote6_C3_sum_out : std_logic_vector(C3_LENGTHLOG2-1 downto 0);
    signal vote6_C4_sum_out : std_logic_vector(C4_LENGTHLOG2-1 downto 0);
    signal vote6_C5_sum_out : std_logic_vector(C5_LENGTHLOG2-1 downto 0);
    signal vote6_C6_sum_out : std_logic_vector(C6_LENGTHLOG2-1 downto 0);
    signal vote6_C7_sum_out : std_logic_vector(C7_LENGTHLOG2-1 downto 0);
    signal vote6_C8_sum_out : std_logic_vector(C8_LENGTHLOG2-1 downto 0);
    signal vote6_C9_sum_out : std_logic_vector(C9_LENGTHLOG2-1 downto 0);
    signal vote6_ID_out : std_logic_vector(ID_LENGTH-1 downto 0);
    signal vote6_vote_out : std_logic_vector(VOTE_LENGTH-1 downto 0);
  
    -- Voter stage 7 signals
    signal vote7_C0_sum_out : std_logic_vector(C0_LENGTHLOG2-1 downto 0);
    signal vote7_C1_sum_out : std_logic_vector(C1_LENGTHLOG2-1 downto 0);
    signal vote7_C2_sum_out : std_logic_vector(C2_LENGTHLOG2-1 downto 0);
    signal vote7_C3_sum_out : std_logic_vector(C3_LENGTHLOG2-1 downto 0);
    signal vote7_C4_sum_out : std_logic_vector(C4_LENGTHLOG2-1 downto 0);
    signal vote7_C5_sum_out : std_logic_vector(C5_LENGTHLOG2-1 downto 0);
    signal vote7_C6_sum_out : std_logic_vector(C6_LENGTHLOG2-1 downto 0);
    signal vote7_C7_sum_out : std_logic_vector(C7_LENGTHLOG2-1 downto 0);
    signal vote7_C8_sum_out : std_logic_vector(C8_LENGTHLOG2-1 downto 0);
    signal vote7_C9_sum_out : std_logic_vector(C9_LENGTHLOG2-1 downto 0);
    signal vote7_ID_out : std_logic_vector(ID_LENGTH-1 downto 0);
    signal vote7_vote_out : std_logic_vector(VOTE_LENGTH-1 downto 0);

    -- Voter stage 8 signals
    signal vote8_C0_sum_out : std_logic_vector(C0_LENGTHLOG2-1 downto 0);
    signal vote8_C1_sum_out : std_logic_vector(C1_LENGTHLOG2-1 downto 0);
    signal vote8_C2_sum_out : std_logic_vector(C2_LENGTHLOG2-1 downto 0);
    signal vote8_C3_sum_out : std_logic_vector(C3_LENGTHLOG2-1 downto 0);
    signal vote8_C4_sum_out : std_logic_vector(C4_LENGTHLOG2-1 downto 0);
    signal vote8_C5_sum_out : std_logic_vector(C5_LENGTHLOG2-1 downto 0);
    signal vote8_C6_sum_out : std_logic_vector(C6_LENGTHLOG2-1 downto 0);
    signal vote8_C7_sum_out : std_logic_vector(C7_LENGTHLOG2-1 downto 0);
    signal vote8_C8_sum_out : std_logic_vector(C8_LENGTHLOG2-1 downto 0);
    signal vote8_C9_sum_out : std_logic_vector(C9_LENGTHLOG2-1 downto 0);
    signal vote8_ID_out : std_logic_vector(ID_LENGTH-1 downto 0);
    signal vote8_vote_out : std_logic_vector(VOTE_LENGTH-1 downto 0);

    -- Voter stage 9 signals
    signal vote9_C0_sum_out : std_logic_vector(C0_LENGTHLOG2-1 downto 0);
    signal vote9_C1_sum_out : std_logic_vector(C1_LENGTHLOG2-1 downto 0);
    signal vote9_C2_sum_out : std_logic_vector(C2_LENGTHLOG2-1 downto 0);
    signal vote9_C3_sum_out : std_logic_vector(C3_LENGTHLOG2-1 downto 0);
    signal vote9_C4_sum_out : std_logic_vector(C4_LENGTHLOG2-1 downto 0);
    signal vote9_C5_sum_out : std_logic_vector(C5_LENGTHLOG2-1 downto 0);
    signal vote9_C6_sum_out : std_logic_vector(C6_LENGTHLOG2-1 downto 0);
    signal vote9_C7_sum_out : std_logic_vector(C7_LENGTHLOG2-1 downto 0);
    signal vote9_C8_sum_out : std_logic_vector(C8_LENGTHLOG2-1 downto 0);
    signal vote9_C9_sum_out : std_logic_vector(C9_LENGTHLOG2-1 downto 0);
    signal vote9_ID_out : std_logic_vector(ID_LENGTH-1 downto 0);
    signal vote9_vote_out : std_logic_vector(VOTE_LENGTH-1 downto 0);
begin
    -- First stage: reduction
    reduc : Reducer
    generic map (C0_LENGTH=>C0_LENGTH,
                C1_LENGTH=>C1_LENGTH,
                C2_LENGTH=>C2_LENGTH,
                C3_LENGTH=>C3_LENGTH,
                C4_LENGTH=>C4_LENGTH,
                C5_LENGTH=>C5_LENGTH,
                C6_LENGTH=>C6_LENGTH,
                C7_LENGTH=>C7_LENGTH,
                C8_LENGTH=>C8_LENGTH,
                C9_LENGTH=>C9_LENGTH,
                C0_LENGTHLOG2=>C0_LENGTHLOG2,
                C1_LENGTHLOG2=>C1_LENGTHLOG2,
                C2_LENGTHLOG2=>C2_LENGTHLOG2,
                C3_LENGTHLOG2=>C3_LENGTHLOG2,
                C4_LENGTHLOG2=>C4_LENGTHLOG2,
                C5_LENGTHLOG2=>C5_LENGTHLOG2,
                C6_LENGTHLOG2=>C6_LENGTHLOG2,
                C7_LENGTHLOG2=>C7_LENGTHLOG2,
                C8_LENGTHLOG2=>C8_LENGTHLOG2,
                C9_LENGTHLOG2=>C9_LENGTHLOG2)
    port map (clock=>clock,
                reset=>reset,
                C0=>C0,
                C1=>C1,
                C2=>C2,
                C3=>C3,
                C4=>C4,
                C5=>C5,
                C6=>C6,
                C7=>C7,
                C8=>C8,
                C9=>C9,
                C0_sum=>reduc_C0_sum,
                C1_sum=>reduc_C1_sum,
                C2_sum=>reduc_C2_sum,
                C3_sum=>reduc_C3_sum,
                C4_sum=>reduc_C4_sum,
                C5_sum=>reduc_C5_sum,
                C6_sum=>reduc_C6_sum,
                C7_sum=>reduc_C7_sum,
                C8_sum=>reduc_C8_sum,
                C9_sum=>reduc_C9_sum);

    -- Voter stage 0
    vote0 : VoterStage
    generic map (C0_SUM_LENGTH=>C0_LENGTHLOG2,
                C1_SUM_LENGTH=>C1_LENGTHLOG2,
                C2_SUM_LENGTH=>C2_LENGTHLOG2,
                C3_SUM_LENGTH=>C3_LENGTHLOG2,
                C4_SUM_LENGTH=>C4_LENGTHLOG2,
                C5_SUM_LENGTH=>C5_LENGTHLOG2,
                C6_SUM_LENGTH=>C6_LENGTHLOG2,
                C7_SUM_LENGTH=>C7_LENGTHLOG2,
                C8_SUM_LENGTH=>C8_LENGTHLOG2,
                C9_SUM_LENGTH=>C9_LENGTHLOG2,
                VOTE_LENGTH=>VOTE_LENGTH,
                ID_LENGTH=>ID_LENGTH,
                ID=>0)
    port map (clock=>clock,
                reset=>reset,
                C0_sum=>reduc_C0_sum,
                C1_sum=>reduc_C1_sum,
                C2_sum=>reduc_C2_sum,
                C3_sum=>reduc_C3_sum,
                C4_sum=>reduc_C4_sum,
                C5_sum=>reduc_C5_sum,
                C6_sum=>reduc_C6_sum,
                C7_sum=>reduc_C7_sum,
                C8_sum=>reduc_C8_sum,
                C9_sum=>reduc_C9_sum,
                ID_in=>vote0_ID_in,
                vote_in=>vote0_vote_in,
                C0_sum_out=>vote0_C0_sum_out,
                C1_sum_out=>vote0_C1_sum_out,
                C2_sum_out=>vote0_C2_sum_out,
                C3_sum_out=>vote0_C3_sum_out,
                C4_sum_out=>vote0_C4_sum_out,
                C5_sum_out=>vote0_C5_sum_out,
                C6_sum_out=>vote0_C6_sum_out,
                C7_sum_out=>vote0_C7_sum_out,
                C8_sum_out=>vote0_C8_sum_out,
                C9_sum_out=>vote0_C9_sum_out,
                ID_out=>vote0_id_out,
                vote_out=>vote0_vote_out);

    -- Voter stage 1
    vote1 : VoterStage
    generic map (C0_SUM_LENGTH=>C0_LENGTHLOG2,
                C1_SUM_LENGTH=>C1_LENGTHLOG2,
                C2_SUM_LENGTH=>C2_LENGTHLOG2,
                C3_SUM_LENGTH=>C3_LENGTHLOG2,
                C4_SUM_LENGTH=>C4_LENGTHLOG2,
                C5_SUM_LENGTH=>C5_LENGTHLOG2,
                C6_SUM_LENGTH=>C6_LENGTHLOG2,
                C7_SUM_LENGTH=>C7_LENGTHLOG2,
                C8_SUM_LENGTH=>C8_LENGTHLOG2,
                C9_SUM_LENGTH=>C9_LENGTHLOG2,
                VOTE_LENGTH=>VOTE_LENGTH,
                ID_LENGTH=>ID_LENGTH,
                ID=>1)
    port map (clock=>clock,
                reset=>reset,
                C0_sum=>vote0_C0_sum_out,
                C1_sum=>vote0_C1_sum_out,
                C2_sum=>vote0_C2_sum_out,
                C3_sum=>vote0_C3_sum_out,
                C4_sum=>vote0_C4_sum_out,
                C5_sum=>vote0_C5_sum_out,
                C6_sum=>vote0_C6_sum_out,
                C7_sum=>vote0_C7_sum_out,
                C8_sum=>vote0_C8_sum_out,
                C9_sum=>vote0_C9_sum_out,
                ID_in=>vote0_ID_out,
                vote_in=>vote0_vote_out,
                C0_sum_out=>vote1_C0_sum_out,
                C1_sum_out=>vote1_C1_sum_out,
                C2_sum_out=>vote1_C2_sum_out,
                C3_sum_out=>vote1_C3_sum_out,
                C4_sum_out=>vote1_C4_sum_out,
                C5_sum_out=>vote1_C5_sum_out,
                C6_sum_out=>vote1_C6_sum_out,
                C7_sum_out=>vote1_C7_sum_out,
                C8_sum_out=>vote1_C8_sum_out,
                C9_sum_out=>vote1_C9_sum_out,
                ID_out=>vote1_id_out,
                vote_out=>vote1_vote_out);


    -- Voter stage 2
    vote2 : VoterStage
    generic map (C0_SUM_LENGTH=>C0_LENGTHLOG2,
                C1_SUM_LENGTH=>C1_LENGTHLOG2,
                C2_SUM_LENGTH=>C2_LENGTHLOG2,
                C3_SUM_LENGTH=>C3_LENGTHLOG2,
                C4_SUM_LENGTH=>C4_LENGTHLOG2,
                C5_SUM_LENGTH=>C5_LENGTHLOG2,
                C6_SUM_LENGTH=>C6_LENGTHLOG2,
                C7_SUM_LENGTH=>C7_LENGTHLOG2,
                C8_SUM_LENGTH=>C8_LENGTHLOG2,
                C9_SUM_LENGTH=>C9_LENGTHLOG2,
                VOTE_LENGTH=>VOTE_LENGTH,
                ID_LENGTH=>ID_LENGTH,
                ID=>2)
    port map (clock=>clock,
                reset=>reset,
                C0_sum=>vote1_C0_sum_out,
                C1_sum=>vote1_C1_sum_out,
                C2_sum=>vote1_C2_sum_out,
                C3_sum=>vote1_C3_sum_out,
                C4_sum=>vote1_C4_sum_out,
                C5_sum=>vote1_C5_sum_out,
                C6_sum=>vote1_C6_sum_out,
                C7_sum=>vote1_C7_sum_out,
                C8_sum=>vote1_C8_sum_out,
                C9_sum=>vote1_C9_sum_out,
                ID_in=>vote1_ID_out,
                vote_in=>vote1_vote_out,
                C0_sum_out=>vote2_C0_sum_out,
                C1_sum_out=>vote2_C1_sum_out,
                C2_sum_out=>vote2_C2_sum_out,
                C3_sum_out=>vote2_C3_sum_out,
                C4_sum_out=>vote2_C4_sum_out,
                C5_sum_out=>vote2_C5_sum_out,
                C6_sum_out=>vote2_C6_sum_out,
                C7_sum_out=>vote2_C7_sum_out,
                C8_sum_out=>vote2_C8_sum_out,
                C9_sum_out=>vote2_C9_sum_out,
                ID_out=>vote2_id_out,
                vote_out=>vote2_vote_out);

    -- Voter stage 3
    vote3 : VoterStage
    generic map (C0_SUM_LENGTH=>C0_LENGTHLOG2,
                C1_SUM_LENGTH=>C1_LENGTHLOG2,
                C2_SUM_LENGTH=>C2_LENGTHLOG2,
                C3_SUM_LENGTH=>C3_LENGTHLOG2,
                C4_SUM_LENGTH=>C4_LENGTHLOG2,
                C5_SUM_LENGTH=>C5_LENGTHLOG2,
                C6_SUM_LENGTH=>C6_LENGTHLOG2,
                C7_SUM_LENGTH=>C7_LENGTHLOG2,
                C8_SUM_LENGTH=>C8_LENGTHLOG2,
                C9_SUM_LENGTH=>C9_LENGTHLOG2,
                VOTE_LENGTH=>VOTE_LENGTH,
                ID_LENGTH=>ID_LENGTH,
                ID=>3)
    port map (clock=>clock,
                reset=>reset,
                C0_sum=>vote2_C0_sum_out,
                C1_sum=>vote2_C1_sum_out,
                C2_sum=>vote2_C2_sum_out,
                C3_sum=>vote2_C3_sum_out,
                C4_sum=>vote2_C4_sum_out,
                C5_sum=>vote2_C5_sum_out,
                C6_sum=>vote2_C6_sum_out,
                C7_sum=>vote2_C7_sum_out,
                C8_sum=>vote2_C8_sum_out,
                C9_sum=>vote2_C9_sum_out,
                ID_in=>vote2_ID_out,
                vote_in=>vote2_vote_out,
                C0_sum_out=>vote3_C0_sum_out,
                C1_sum_out=>vote3_C1_sum_out,
                C2_sum_out=>vote3_C2_sum_out,
                C3_sum_out=>vote3_C3_sum_out,
                C4_sum_out=>vote3_C4_sum_out,
                C5_sum_out=>vote3_C5_sum_out,
                C6_sum_out=>vote3_C6_sum_out,
                C7_sum_out=>vote3_C7_sum_out,
                C8_sum_out=>vote3_C8_sum_out,
                C9_sum_out=>vote3_C9_sum_out,
                ID_out=>vote3_id_out,
                vote_out=>vote3_vote_out);

    -- Voter stage 4
    vote4 : VoterStage
    generic map (C0_SUM_LENGTH=>C0_LENGTHLOG2,
                C1_SUM_LENGTH=>C1_LENGTHLOG2,
                C2_SUM_LENGTH=>C2_LENGTHLOG2,
                C3_SUM_LENGTH=>C3_LENGTHLOG2,
                C4_SUM_LENGTH=>C4_LENGTHLOG2,
                C5_SUM_LENGTH=>C5_LENGTHLOG2,
                C6_SUM_LENGTH=>C6_LENGTHLOG2,
                C7_SUM_LENGTH=>C7_LENGTHLOG2,
                C8_SUM_LENGTH=>C8_LENGTHLOG2,
                C9_SUM_LENGTH=>C9_LENGTHLOG2,
                VOTE_LENGTH=>VOTE_LENGTH,
                ID_LENGTH=>ID_LENGTH,
                ID=>4)
    port map (clock=>clock,
                reset=>reset,
                C0_sum=>vote3_C0_sum_out,
                C1_sum=>vote3_C1_sum_out,
                C2_sum=>vote3_C2_sum_out,
                C3_sum=>vote3_C3_sum_out,
                C4_sum=>vote3_C4_sum_out,
                C5_sum=>vote3_C5_sum_out,
                C6_sum=>vote3_C6_sum_out,
                C7_sum=>vote3_C7_sum_out,
                C8_sum=>vote3_C8_sum_out,
                C9_sum=>vote3_C9_sum_out,
                ID_in=>vote3_ID_out,
                vote_in=>vote3_vote_out,
                C0_sum_out=>vote4_C0_sum_out,
                C1_sum_out=>vote4_C1_sum_out,
                C2_sum_out=>vote4_C2_sum_out,
                C3_sum_out=>vote4_C3_sum_out,
                C4_sum_out=>vote4_C4_sum_out,
                C5_sum_out=>vote4_C5_sum_out,
                C6_sum_out=>vote4_C6_sum_out,
                C7_sum_out=>vote4_C7_sum_out,
                C8_sum_out=>vote4_C8_sum_out,
                C9_sum_out=>vote4_C9_sum_out,
                ID_out=>vote4_id_out,
                vote_out=>vote4_vote_out);

    -- Voter stage 5
    vote5 : VoterStage
    generic map (C0_SUM_LENGTH=>C0_LENGTHLOG2,
                C1_SUM_LENGTH=>C1_LENGTHLOG2,
                C2_SUM_LENGTH=>C2_LENGTHLOG2,
                C3_SUM_LENGTH=>C3_LENGTHLOG2,
                C4_SUM_LENGTH=>C4_LENGTHLOG2,
                C5_SUM_LENGTH=>C5_LENGTHLOG2,
                C6_SUM_LENGTH=>C6_LENGTHLOG2,
                C7_SUM_LENGTH=>C7_LENGTHLOG2,
                C8_SUM_LENGTH=>C8_LENGTHLOG2,
                C9_SUM_LENGTH=>C9_LENGTHLOG2,
                VOTE_LENGTH=>VOTE_LENGTH,
                ID_LENGTH=>ID_LENGTH,
                ID=>5)
    port map (clock=>clock,
                reset=>reset,
                C0_sum=>vote4_C0_sum_out,
                C1_sum=>vote4_C1_sum_out,
                C2_sum=>vote4_C2_sum_out,
                C3_sum=>vote4_C3_sum_out,
                C4_sum=>vote4_C4_sum_out,
                C5_sum=>vote4_C5_sum_out,
                C6_sum=>vote4_C6_sum_out,
                C7_sum=>vote4_C7_sum_out,
                C8_sum=>vote4_C8_sum_out,
                C9_sum=>vote4_C9_sum_out,
                ID_in=>vote4_ID_out,
                vote_in=>vote4_vote_out,
                C0_sum_out=>vote5_C0_sum_out,
                C1_sum_out=>vote5_C1_sum_out,
                C2_sum_out=>vote5_C2_sum_out,
                C3_sum_out=>vote5_C3_sum_out,
                C4_sum_out=>vote5_C4_sum_out,
                C5_sum_out=>vote5_C5_sum_out,
                C6_sum_out=>vote5_C6_sum_out,
                C7_sum_out=>vote5_C7_sum_out,
                C8_sum_out=>vote5_C8_sum_out,
                C9_sum_out=>vote5_C9_sum_out,
                ID_out=>vote5_id_out,
                vote_out=>vote5_vote_out);

    -- Voter stage 6
    vote6 : VoterStage
    generic map (C0_SUM_LENGTH=>C0_LENGTHLOG2,
                C1_SUM_LENGTH=>C1_LENGTHLOG2,
                C2_SUM_LENGTH=>C2_LENGTHLOG2,
                C3_SUM_LENGTH=>C3_LENGTHLOG2,
                C4_SUM_LENGTH=>C4_LENGTHLOG2,
                C5_SUM_LENGTH=>C5_LENGTHLOG2,
                C6_SUM_LENGTH=>C6_LENGTHLOG2,
                C7_SUM_LENGTH=>C7_LENGTHLOG2,
                C8_SUM_LENGTH=>C8_LENGTHLOG2,
                C9_SUM_LENGTH=>C9_LENGTHLOG2,
                VOTE_LENGTH=>VOTE_LENGTH,
                ID_LENGTH=>ID_LENGTH,
                ID=>6)
    port map (clock=>clock,
                reset=>reset,
                C0_sum=>vote5_C0_sum_out,
                C1_sum=>vote5_C1_sum_out,
                C2_sum=>vote5_C2_sum_out,
                C3_sum=>vote5_C3_sum_out,
                C4_sum=>vote5_C4_sum_out,
                C5_sum=>vote5_C5_sum_out,
                C6_sum=>vote5_C6_sum_out,
                C7_sum=>vote5_C7_sum_out,
                C8_sum=>vote5_C8_sum_out,
                C9_sum=>vote5_C9_sum_out,
                ID_in=>vote5_ID_out,
                vote_in=>vote5_vote_out,
                C0_sum_out=>vote6_C0_sum_out,
                C1_sum_out=>vote6_C1_sum_out,
                C2_sum_out=>vote6_C2_sum_out,
                C3_sum_out=>vote6_C3_sum_out,
                C4_sum_out=>vote6_C4_sum_out,
                C5_sum_out=>vote6_C5_sum_out,
                C6_sum_out=>vote6_C6_sum_out,
                C7_sum_out=>vote6_C7_sum_out,
                C8_sum_out=>vote6_C8_sum_out,
                C9_sum_out=>vote6_C9_sum_out,
                ID_out=>vote6_id_out,
                vote_out=>vote6_vote_out);

    -- Voter stage 7
    vote7 : VoterStage
    generic map (C0_SUM_LENGTH=>C0_LENGTHLOG2,
                C1_SUM_LENGTH=>C1_LENGTHLOG2,
                C2_SUM_LENGTH=>C2_LENGTHLOG2,
                C3_SUM_LENGTH=>C3_LENGTHLOG2,
                C4_SUM_LENGTH=>C4_LENGTHLOG2,
                C5_SUM_LENGTH=>C5_LENGTHLOG2,
                C6_SUM_LENGTH=>C6_LENGTHLOG2,
                C7_SUM_LENGTH=>C7_LENGTHLOG2,
                C8_SUM_LENGTH=>C8_LENGTHLOG2,
                C9_SUM_LENGTH=>C9_LENGTHLOG2,
                VOTE_LENGTH=>VOTE_LENGTH,
                ID_LENGTH=>ID_LENGTH,
                ID=>7)
    port map (clock=>clock,
                reset=>reset,
                C0_sum=>vote6_C0_sum_out,
                C1_sum=>vote6_C1_sum_out,
                C2_sum=>vote6_C2_sum_out,
                C3_sum=>vote6_C3_sum_out,
                C4_sum=>vote6_C4_sum_out,
                C5_sum=>vote6_C5_sum_out,
                C6_sum=>vote6_C6_sum_out,
                C7_sum=>vote6_C7_sum_out,
                C8_sum=>vote6_C8_sum_out,
                C9_sum=>vote6_C9_sum_out,
                ID_in=>vote6_ID_out,
                vote_in=>vote6_vote_out,
                C0_sum_out=>vote7_C0_sum_out,
                C1_sum_out=>vote7_C1_sum_out,
                C2_sum_out=>vote7_C2_sum_out,
                C3_sum_out=>vote7_C3_sum_out,
                C4_sum_out=>vote7_C4_sum_out,
                C5_sum_out=>vote7_C5_sum_out,
                C6_sum_out=>vote7_C6_sum_out,
                C7_sum_out=>vote7_C7_sum_out,
                C8_sum_out=>vote7_C8_sum_out,
                C9_sum_out=>vote7_C9_sum_out,
                ID_out=>vote7_id_out,
                vote_out=>vote7_vote_out);

    -- Voter stage 8
    vote8 : VoterStage
    generic map (C0_SUM_LENGTH=>C0_LENGTHLOG2,
                C1_SUM_LENGTH=>C1_LENGTHLOG2,
                C2_SUM_LENGTH=>C2_LENGTHLOG2,
                C3_SUM_LENGTH=>C3_LENGTHLOG2,
                C4_SUM_LENGTH=>C4_LENGTHLOG2,
                C5_SUM_LENGTH=>C5_LENGTHLOG2,
                C6_SUM_LENGTH=>C6_LENGTHLOG2,
                C7_SUM_LENGTH=>C7_LENGTHLOG2,
                C8_SUM_LENGTH=>C8_LENGTHLOG2,
                C9_SUM_LENGTH=>C9_LENGTHLOG2,
                VOTE_LENGTH=>VOTE_LENGTH,
                ID_LENGTH=>ID_LENGTH,
                ID=>8)
    port map (clock=>clock,
                reset=>reset,
                C0_sum=>vote7_C0_sum_out,
                C1_sum=>vote7_C1_sum_out,
                C2_sum=>vote7_C2_sum_out,
                C3_sum=>vote7_C3_sum_out,
                C4_sum=>vote7_C4_sum_out,
                C5_sum=>vote7_C5_sum_out,
                C6_sum=>vote7_C6_sum_out,
                C7_sum=>vote7_C7_sum_out,
                C8_sum=>vote7_C8_sum_out,
                C9_sum=>vote7_C9_sum_out,
                ID_in=>vote7_ID_out,
                vote_in=>vote7_vote_out,
                C0_sum_out=>vote8_C0_sum_out,
                C1_sum_out=>vote8_C1_sum_out,
                C2_sum_out=>vote8_C2_sum_out,
                C3_sum_out=>vote8_C3_sum_out,
                C4_sum_out=>vote8_C4_sum_out,
                C5_sum_out=>vote8_C5_sum_out,
                C6_sum_out=>vote8_C6_sum_out,
                C7_sum_out=>vote8_C7_sum_out,
                C8_sum_out=>vote8_C8_sum_out,
                C9_sum_out=>vote8_C9_sum_out,
                ID_out=>vote8_id_out,
                vote_out=>vote8_vote_out);

    -- Voter stage 9
    vote9 : VoterStage
    generic map (C0_SUM_LENGTH=>C0_LENGTHLOG2,
                C1_SUM_LENGTH=>C1_LENGTHLOG2,
                C2_SUM_LENGTH=>C2_LENGTHLOG2,
                C3_SUM_LENGTH=>C3_LENGTHLOG2,
                C4_SUM_LENGTH=>C4_LENGTHLOG2,
                C5_SUM_LENGTH=>C5_LENGTHLOG2,
                C6_SUM_LENGTH=>C6_LENGTHLOG2,
                C7_SUM_LENGTH=>C7_LENGTHLOG2,
                C8_SUM_LENGTH=>C8_LENGTHLOG2,
                C9_SUM_LENGTH=>C9_LENGTHLOG2,
                VOTE_LENGTH=>VOTE_LENGTH,
                ID_LENGTH=>ID_LENGTH,
                ID=>9)
    port map (clock=>clock,
                reset=>reset,
                C0_sum=>vote8_C0_sum_out,
                C1_sum=>vote8_C1_sum_out,
                C2_sum=>vote8_C2_sum_out,
                C3_sum=>vote8_C3_sum_out,
                C4_sum=>vote8_C4_sum_out,
                C5_sum=>vote8_C5_sum_out,
                C6_sum=>vote8_C6_sum_out,
                C7_sum=>vote8_C7_sum_out,
                C8_sum=>vote8_C8_sum_out,
                C9_sum=>vote8_C9_sum_out,
                ID_in=>vote8_ID_out,
                vote_in=>vote8_vote_out,
                C0_sum_out=>vote9_C0_sum_out,
                C1_sum_out=>vote9_C1_sum_out,
                C2_sum_out=>vote9_C2_sum_out,
                C3_sum_out=>vote9_C3_sum_out,
                C4_sum_out=>vote9_C4_sum_out,
                C5_sum_out=>vote9_C5_sum_out,
                C6_sum_out=>vote9_C6_sum_out,
                C7_sum_out=>vote9_C7_sum_out,
                C8_sum_out=>vote9_C8_sum_out,
                C9_sum_out=>vote9_C9_sum_out,
                ID_out=>vote9_id_out,
                vote_out=>vote9_vote_out);

    -- Final output result is the output from voter stage 9
    result <= vote9_ID_out;

end architecture;
