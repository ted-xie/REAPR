library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity VoterStage is
	generic (DATA_LENGTH : INTEGER := 20;
			WEIGHT_LENGTH : INTEGER := 20;
			ID_LENGTH : INTEGER := 8;
			ID : INTEGER := 0);
			
	port (clock : in std_logic;
			reset : in std_logic;
			C0, C1, C2, C3, C4, C5, C6, C7, C8, C9 : in std_logic_vector(DATA_LENGTH-1 downto 0);
			WT_in : in std_logic_vector(WEIGHT_LENGTH-1 downto 0);
			ID_in : in std_logic_vector(ID_LENGTH-1 downto 0);
			WT_out : out std_logic_vector(WEIGHT_LENGTH-1 downto 0);
			ID_out : out std_logic_vector(ID_LENGTH-1 downto 0);
			CO0, CO1, CO2, CO3, CO4, CO5, CO6, CO7, CO8, CO9 : out std_logic_vector(DATA_LENGTH-1 downto 0));
end VoterStage;

architecture Structure of VoterStage is
	component HammingWeight is
		generic (INPUT_LENGTH : INTEGER := 20;
				WEIGHT_LENGTH : INTEGER := 20);
				
		port (din : in std_logic_vector(INPUT_LENGTH-1 downto 0);
				weight : out std_logic_vector(WEIGHT_LENGTH-1 downto 0));
	end component;

	signal this_weight : std_logic_vector(WEIGHT_LENGTH-1 downto 0);
	signal this_data : std_logic_vector(DATA_LENGTH-1 downto 0);
begin
	with ID select
		this_data <= C0 when 0,
					C1 when 1,
					C2 when 2,
					C3 when 3,
					C4 when 4,
					C5 when 5,
					C6 when 6,
					C7 when 7,
					C8 when 8,
					C9 when 9,
					(others=>'0') when others;

	hweight : HammingWeight
	generic map (INPUT_LENGTH=>DATA_LENGTH,
				WEIGHT_LENGTH=>WEIGHT_LENGTH)
	port map (din=>this_data,
				weight=>this_weight);				
				
	process(clock)
	begin
		if (reset = '1') then
			CO0 <= (others=>'0');
			CO1 <= (others=>'0');
			CO2 <= (others=>'0');
			CO3 <= (others=>'0');
			CO4 <= (others=>'0');
			CO5 <= (others=>'0');
			CO6 <= (others=>'0');
			CO7 <= (others=>'0');
			CO8 <= (others=>'0');
			CO9 <= (others=>'0');
		else
			CO0 <= C0;
			CO1 <= C1;
			CO2 <= C2;
			CO3 <= C3;
			CO4 <= C4;
			CO5 <= C5;
			CO6 <= C6;
			CO7 <= C7;
			CO8 <= C8;
			CO9 <= C9;
		end if;
	end process;
	
	process(clock)
	begin
		if (reset = '1') then
			ID_out <= (others=>'0');
			WT_out <= (others=>'0');
		else
			if (this_weight > WT_in) then
				WT_out <= this_weight;
				ID_out <= std_logic_vector(to_unsigned(ID, ID_LENGTH));
			else
				WT_out <= WT_in;
				ID_out <= ID_in;
			end if;
		end if;
	end process;
end Structure;