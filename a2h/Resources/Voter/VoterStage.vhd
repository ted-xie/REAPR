library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity VoterStage is
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
end VoterStage;

architecture Structure of VoterStage is
    signal ID_slv : std_logic_vector(VOTE_LENGTH-1 downto 0);
begin
    -- Signal assignment for std_logic_vector version of ID generic
    ID_slv <= std_logic_vector(to_unsigned(ID, VOTE_LENGTH));

    process(clock)
    begin
        if (rising_edge(clock)) then
            if (reset = '1') then
                C0_sum_out <= (others=>'0');
                C1_sum_out <= (others=>'0');
                C2_sum_out <= (others=>'0');
                C3_sum_out <= (others=>'0');
                C4_sum_out <= (others=>'0');
                C5_sum_out <= (others=>'0');
                C6_sum_out <= (others=>'0');
                C7_sum_out <= (others=>'0');
                C8_sum_out <= (others=>'0');
                C9_sum_out <= (others=>'0');
                vote_out <= (others=>'0');
                ID_out <= (others=>'0');
            else
                C0_sum_out <= C0_sum;
                C1_sum_out <= C1_sum;
                C2_sum_out <= C2_sum;
                C3_sum_out <= C3_sum;
                C4_sum_out <= C4_sum;
                C5_sum_out <= C5_sum;
                C6_sum_out <= C6_sum;
                C7_sum_out <= C7_sum;
                C8_sum_out <= C8_sum;
                C9_sum_out <= C9_sum;
                if (ID = 0) then
                    if (C0_sum > vote_in) then
                        vote_out <= (vote_out'length -1 downto C0_sum'length => '0') & C0_sum;
                        ID_out <= ID_slv;
                    else
                        vote_out <= vote_in;
                        ID_out <= ID_in;
                    end if;
                elsif (ID = 1) then
                    if (C1_sum > vote_in) then
                        vote_out <= (vote_out'length -1 downto C1_sum'length => '0') & C1_sum;
                        ID_out <= ID_slv;
                    else
                        vote_out <= vote_in;
                        ID_out <= ID_in;
                    end if;
                elsif (ID = 2) then
                    if (C2_sum > vote_in) then
                        vote_out <= (vote_out'length -1 downto C2_sum'length => '0') & C2_sum;
                        ID_out <= ID_slv;
                    else
                        vote_out <= vote_in;
                        ID_out <= ID_in;
                    end if;
                elsif (ID = 3) then
                    if (C3_sum > vote_in) then
                        vote_out <= (vote_out'length -1 downto C3_sum'length => '0') & C3_sum;
                        ID_out <= ID_slv;
                    else
                        vote_out <= vote_in;
                        ID_out <= ID_in;
                    end if;
                elsif (ID = 4) then
                    if (C4_sum > vote_in) then
                        vote_out <= (vote_out'length -1 downto C4_sum'length => '0') & C4_sum;
                        ID_out <= ID_slv;
                    else
                        vote_out <= vote_in;
                        ID_out <= ID_in;
                    end if;
                elsif (ID = 5) then
                    if (C5_sum > vote_in) then
                        vote_out <= (vote_out'length -1 downto C5_sum'length => '0') & C5_sum;
                        ID_out <= ID_slv;
                    else
                        vote_out <= vote_in;
                        ID_out <= ID_in;
                    end if;
                elsif (ID = 6) then
                    if (C6_sum > vote_in) then
                        vote_out <= (vote_out'length -1 downto C6_sum'length => '0') & C6_sum;
                        ID_out <= ID_slv;
                    else
                        vote_out <= vote_in;
                        ID_out <= ID_in;
                    end if;
                elsif (ID = 7) then
                    if (C7_sum > vote_in) then
                        vote_out <= (vote_out'length -1 downto C7_sum'length => '0') & C7_sum;
                        ID_out <= ID_slv;
                    else
                        vote_out <= vote_in;
                        ID_out <= ID_in;
                    end if;
                elsif (ID = 8) then
                    if (C8_sum > vote_in) then
                        vote_out <= (vote_out'length -1 downto C8_sum'length => '0') & C8_sum;
                        ID_out <= ID_slv;
                    else
                        vote_out <= vote_in;
                        ID_out <= ID_in;
                    end if;
                elsif (ID = 9) then
                    if (C9_sum > vote_in) then
                        vote_out <= (vote_out'length -1 downto C9_sum'length => '0') & C9_sum;
                        ID_out <= ID_slv;
                    else
                        vote_out <= vote_in;
                        ID_out <= ID_in;
                    end if;
                else -- improper generic assgnment condition
                    vote_out <= (others=>'1');
                    ID_out <= (others=>'1');
                end if;
            end if;
        end if;
    end process;
end Structure;
