library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Voter is
	generic (DATA_LENGTH : INTEGER := 20;
			WEIGHT_LENGTH : INTEGER := 20;
			ID_LENGTH : INTEGER := 8);
	port (clock : in std_logic;
			reset : in std_logic;
			C0, C1, C2, C3, C4, C5, C6, C7, C8, C9 : in std_logic_vector(DATA_LENGTH-1 downto 0);
			Vote : out std_logic_vector(ID_LENGTH-1 downto 0));		
end Voter;

architecture Structure of Voter is
	component VoterStage is
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
	end component;
	
	signal v0_WT : std_logic_vector(WEIGHT_LENGTH-1 downto 0);
	signal v0_ID : std_logic_vector(ID_LENGTH-1 downto 0);
	signal v0_C0 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v0_C1 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v0_C2 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v0_C3 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v0_C4 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v0_C5 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v0_C6 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v0_C7 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v0_C8 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v0_C9 : std_logic_vector(DATA_LENGTH-1 downto 0);
	
	signal v1_WT : std_logic_vector(WEIGHT_LENGTH-1 downto 0);
	signal v1_ID : std_logic_vector(ID_LENGTH-1 downto 0);
	signal v1_C0 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v1_C1 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v1_C2 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v1_C3 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v1_C4 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v1_C5 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v1_C6 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v1_C7 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v1_C8 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v1_C9 : std_logic_vector(DATA_LENGTH-1 downto 0);
	
	signal v2_WT : std_logic_vector(WEIGHT_LENGTH-1 downto 0);
	signal v2_ID : std_logic_vector(ID_LENGTH-1 downto 0);
	signal v2_C0 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v2_C1 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v2_C2 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v2_C3 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v2_C4 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v2_C5 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v2_C6 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v2_C7 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v2_C8 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v2_C9 : std_logic_vector(DATA_LENGTH-1 downto 0);

	signal v3_WT : std_logic_vector(WEIGHT_LENGTH-1 downto 0);
	signal v3_ID : std_logic_vector(ID_LENGTH-1 downto 0);
	signal v3_C0 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v3_C1 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v3_C2 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v3_C3 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v3_C4 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v3_C5 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v3_C6 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v3_C7 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v3_C8 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v3_C9 : std_logic_vector(DATA_LENGTH-1 downto 0);	
	
	signal v4_WT : std_logic_vector(WEIGHT_LENGTH-1 downto 0);
	signal v4_ID : std_logic_vector(ID_LENGTH-1 downto 0);
	signal v4_C0 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v4_C1 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v4_C2 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v4_C3 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v4_C4 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v4_C5 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v4_C6 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v4_C7 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v4_C8 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v4_C9 : std_logic_vector(DATA_LENGTH-1 downto 0);
	
	signal v5_WT : std_logic_vector(WEIGHT_LENGTH-1 downto 0);
	signal v5_ID : std_logic_vector(ID_LENGTH-1 downto 0);
	signal v5_C0 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v5_C1 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v5_C2 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v5_C3 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v5_C4 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v5_C5 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v5_C6 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v5_C7 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v5_C8 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v5_C9 : std_logic_vector(DATA_LENGTH-1 downto 0);
	
	signal v6_WT : std_logic_vector(WEIGHT_LENGTH-1 downto 0);
	signal v6_ID : std_logic_vector(ID_LENGTH-1 downto 0);
	signal v6_C0 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v6_C1 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v6_C2 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v6_C3 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v6_C4 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v6_C5 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v6_C6 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v6_C7 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v6_C8 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v6_C9 : std_logic_vector(DATA_LENGTH-1 downto 0);
	
	signal v7_WT : std_logic_vector(WEIGHT_LENGTH-1 downto 0);
	signal v7_ID : std_logic_vector(ID_LENGTH-1 downto 0);
	signal v7_C0 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v7_C1 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v7_C2 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v7_C3 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v7_C4 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v7_C5 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v7_C6 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v7_C7 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v7_C8 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v7_C9 : std_logic_vector(DATA_LENGTH-1 downto 0);

	signal v8_WT : std_logic_vector(WEIGHT_LENGTH-1 downto 0);
	signal v8_ID : std_logic_vector(ID_LENGTH-1 downto 0);
	signal v8_C0 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v8_C1 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v8_C2 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v8_C3 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v8_C4 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v8_C5 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v8_C6 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v8_C7 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v8_C8 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v8_C9 : std_logic_vector(DATA_LENGTH-1 downto 0);	
	
	signal v9_WT : std_logic_vector(WEIGHT_LENGTH-1 downto 0);
	signal v9_ID : std_logic_vector(ID_LENGTH-1 downto 0);
	signal v9_C0 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v9_C1 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v9_C2 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v9_C3 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v9_C4 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v9_C5 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v9_C6 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v9_C7 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v9_C8 : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal v9_C9 : std_logic_vector(DATA_LENGTH-1 downto 0);	
begin
	v0 : VoterStage
	generic map(DATA_LENGTH=>DATA_LENGTH,
				WEIGHT_LENGTH=>WEIGHT_LENGTH,
				ID_LENGTH=>ID_LENGTH,
				ID=>0)
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
				WT_in=>(others=>'0'),
				ID_in=>(others=>'0'),
				WT_out=>v0_WT,
				ID_out=>v0_ID,
				CO0=>v0_C0,
				CO1=>v0_C1,
				CO2=>v0_C2,
				CO3=>v0_C3,
				CO4=>v0_C4,
				CO5=>v0_C5,
				CO6=>v0_C6,
				CO7=>v0_C7,
				CO8=>v0_C8,
				CO9=>v0_C9);			

	v1 : VoterStage
	generic map(DATA_LENGTH=>DATA_LENGTH,
				WEIGHT_LENGTH=>WEIGHT_LENGTH,
				ID_LENGTH=>ID_LENGTH,
				ID=>1)
	port map (clock=>clock,
				reset=>reset,
				C0=>v0_C0,
				C1=>v0_C1,
				C2=>v0_C2,
				C3=>v0_C3,
				C4=>v0_C4,
				C5=>v0_C5,
				C6=>v0_C6,
				C7=>v0_C7,
				C8=>v0_C8,
				C9=>v0_C9,
				WT_in=>v0_WT,
				ID_in=>v0_ID,
				WT_out=>v1_WT,
				ID_out=>v1_ID,
				CO0=>v1_C0,
				CO1=>v1_C1,
				CO2=>v1_C2,
				CO3=>v1_C3,
				CO4=>v1_C4,
				CO5=>v1_C5,
				CO6=>v1_C6,
				CO7=>v1_C7,
				CO8=>v1_C8,
				CO9=>v1_C9);
				
	v2 : VoterStage
	generic map(DATA_LENGTH=>DATA_LENGTH,
				WEIGHT_LENGTH=>WEIGHT_LENGTH,
				ID_LENGTH=>ID_LENGTH,
				ID=>2)
	port map (clock=>clock,
				reset=>reset,
				C0=>v1_C0,
				C1=>v1_C1,
				C2=>v1_C2,
				C3=>v1_C3,
				C4=>v1_C4,
				C5=>v1_C5,
				C6=>v1_C6,
				C7=>v1_C7,
				C8=>v1_C8,
				C9=>v1_C9,
				WT_in=>v1_WT,
				ID_in=>v1_ID,
				WT_out=>v2_WT,
				ID_out=>v2_ID,
				CO0=>v2_C0,
				CO1=>v2_C1,
				CO2=>v2_C2,
				CO3=>v2_C3,
				CO4=>v2_C4,
				CO5=>v2_C5,
				CO6=>v2_C6,
				CO7=>v2_C7,
				CO8=>v2_C8,
				CO9=>v2_C9);		

	v3 : VoterStage
	generic map(DATA_LENGTH=>DATA_LENGTH,
				WEIGHT_LENGTH=>WEIGHT_LENGTH,
				ID_LENGTH=>ID_LENGTH,
				ID=>3)
	port map (clock=>clock,
				reset=>reset,
				C0=>v2_C0,
				C1=>v2_C1,
				C2=>v2_C2,
				C3=>v2_C3,
				C4=>v2_C4,
				C5=>v2_C5,
				C6=>v2_C6,
				C7=>v2_C7,
				C8=>v2_C8,
				C9=>v2_C9,
				WT_in=>v2_WT,
				ID_in=>v2_ID,
				WT_out=>v3_WT,
				ID_out=>v3_ID,
				CO0=>v3_C0,
				CO1=>v3_C1,
				CO2=>v3_C2,
				CO3=>v3_C3,
				CO4=>v3_C4,
				CO5=>v3_C5,
				CO6=>v3_C6,
				CO7=>v3_C7,
				CO8=>v3_C8,
				CO9=>v3_C9);

	v4 : VoterStage
	generic map(DATA_LENGTH=>DATA_LENGTH,
				WEIGHT_LENGTH=>WEIGHT_LENGTH,
				ID_LENGTH=>ID_LENGTH,
				ID=>4)
	port map (clock=>clock,
				reset=>reset,
				C0=>v3_C0,
				C1=>v3_C1,
				C2=>v3_C2,
				C3=>v3_C3,
				C4=>v3_C4,
				C5=>v3_C5,
				C6=>v3_C6,
				C7=>v3_C7,
				C8=>v3_C8,
				C9=>v3_C9,
				WT_in=>v3_WT,
				ID_in=>v3_ID,
				WT_out=>v4_WT,
				ID_out=>v4_ID,
				CO0=>v4_C0,
				CO1=>v4_C1,
				CO2=>v4_C2,
				CO3=>v4_C3,
				CO4=>v4_C4,
				CO5=>v4_C5,
				CO6=>v4_C6,
				CO7=>v4_C7,
				CO8=>v4_C8,
				CO9=>v4_C9);	

	v5 : VoterStage
	generic map(DATA_LENGTH=>DATA_LENGTH,
				WEIGHT_LENGTH=>WEIGHT_LENGTH,
				ID_LENGTH=>ID_LENGTH,
				ID=>5)
	port map (clock=>clock,
				reset=>reset,
				C0=>v4_C0,
				C1=>v4_C1,
				C2=>v4_C2,
				C3=>v4_C3,
				C4=>v4_C4,
				C5=>v4_C5,
				C6=>v4_C6,
				C7=>v4_C7,
				C8=>v4_C8,
				C9=>v4_C9,
				WT_in=>v4_WT,
				ID_in=>v4_ID,
				WT_out=>v5_WT,
				ID_out=>v5_ID,
				CO0=>v5_C0,
				CO1=>v5_C1,
				CO2=>v5_C2,
				CO3=>v5_C3,
				CO4=>v5_C4,
				CO5=>v5_C5,
				CO6=>v5_C6,
				CO7=>v5_C7,
				CO8=>v5_C8,
				CO9=>v5_C9);					
				
	v6 : VoterStage
	generic map(DATA_LENGTH=>DATA_LENGTH,
				WEIGHT_LENGTH=>WEIGHT_LENGTH,
				ID_LENGTH=>ID_LENGTH,
				ID=>6)
	port map (clock=>clock,
				reset=>reset,
				C0=>v5_C0,
				C1=>v5_C1,
				C2=>v5_C2,
				C3=>v5_C3,
				C4=>v5_C4,
				C5=>v5_C5,
				C6=>v5_C6,
				C7=>v5_C7,
				C8=>v5_C8,
				C9=>v5_C9,
				WT_in=>v5_WT,
				ID_in=>v5_ID,
				WT_out=>v6_WT,
				ID_out=>v6_ID,
				CO0=>v6_C0,
				CO1=>v6_C1,
				CO2=>v6_C2,
				CO3=>v6_C3,
				CO4=>v6_C4,
				CO5=>v6_C5,
				CO6=>v6_C6,
				CO7=>v6_C7,
				CO8=>v6_C8,
				CO9=>v6_C9);			

	v7 : VoterStage
	generic map(DATA_LENGTH=>DATA_LENGTH,
				WEIGHT_LENGTH=>WEIGHT_LENGTH,
				ID_LENGTH=>ID_LENGTH,
				ID=>7)
	port map (clock=>clock,
				reset=>reset,
				C0=>v6_C0,
				C1=>v6_C1,
				C2=>v6_C2,
				C3=>v6_C3,
				C4=>v6_C4,
				C5=>v6_C5,
				C6=>v6_C6,
				C7=>v6_C7,
				C8=>v6_C8,
				C9=>v6_C9,
				WT_in=>v6_WT,
				ID_in=>v6_ID,
				WT_out=>v7_WT,
				ID_out=>v7_ID,
				CO0=>v7_C0,
				CO1=>v7_C1,
				CO2=>v7_C2,
				CO3=>v7_C3,
				CO4=>v7_C4,
				CO5=>v7_C5,
				CO6=>v7_C6,
				CO7=>v7_C7,
				CO8=>v7_C8,
				CO9=>v7_C9);	
				
	v8 : VoterStage
	generic map(DATA_LENGTH=>DATA_LENGTH,
				WEIGHT_LENGTH=>WEIGHT_LENGTH,
				ID_LENGTH=>ID_LENGTH,
				ID=>8)
	port map (clock=>clock,
				reset=>reset,
				C0=>v7_C0,
				C1=>v7_C1,
				C2=>v7_C2,
				C3=>v7_C3,
				C4=>v7_C4,
				C5=>v7_C5,
				C6=>v7_C6,
				C7=>v7_C7,
				C8=>v7_C8,
				C9=>v7_C9,
				WT_in=>v7_WT,
				ID_in=>v7_ID,
				WT_out=>v8_WT,
				ID_out=>v8_ID,
				CO0=>v8_C0,
				CO1=>v8_C1,
				CO2=>v8_C2,
				CO3=>v8_C3,
				CO4=>v8_C4,
				CO5=>v8_C5,
				CO6=>v8_C6,
				CO7=>v8_C7,
				CO8=>v8_C8,
				CO9=>v8_C9);	

	v9 : VoterStage
	generic map(DATA_LENGTH=>DATA_LENGTH,
				WEIGHT_LENGTH=>WEIGHT_LENGTH,
				ID_LENGTH=>ID_LENGTH,
				ID=>9)
	port map (clock=>clock,
				reset=>reset,
				C0=>v8_C0,
				C1=>v8_C1,
				C2=>v8_C2,
				C3=>v8_C3,
				C4=>v8_C4,
				C5=>v8_C5,
				C6=>v8_C6,
				C7=>v8_C7,
				C8=>v8_C8,
				C9=>v8_C9,
				WT_in=>v8_WT,
				ID_in=>v8_ID,
				WT_out=>v9_WT,
				ID_out=>v9_ID,
				CO0=>v9_C0,
				CO1=>v9_C1,
				CO2=>v9_C2,
				CO3=>v9_C3,
				CO4=>v9_C4,
				CO5=>v9_C5,
				CO6=>v9_C6,
				CO7=>v9_C7,
				CO8=>v9_C8,
				CO9=>v9_C9);	
				
	Vote <= v9_ID;
end Structure;
