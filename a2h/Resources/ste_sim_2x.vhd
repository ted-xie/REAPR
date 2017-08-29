library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity ste_sim_2x is
	port
	(
	bitvector	:	in std_logic_vector(255 downto 0);
	bitvector2	:	in std_logic_vector(255 downto 0);
	char_in		:	in std_logic_vector(7 downto 0);
	char_in2	:	in std_logic_vector(7 downto 0);
	clock, reset, run		:	in std_logic;
	Enable	:	in std_logic;
	match		:	out std_logic
	);
end ste_sim_2x;

architecture Structure of ste_sim_2x is
	signal StateOut : std_logic;
	signal MemOut : std_logic;
begin
	-- D flip flop, holds State bit
	process (clock)
	begin
		if (rising_edge(clock)) then
			if (run = '1') then
				if (reset = '1') then
					StateOut <= '0';
				else
					StateOut <= Enable;
				end if;
			end if;
		end if;
	end process;

	MemOut <= bitvector(conv_integer(unsigned(char_in))) and bitvector2(conv_integer(unsigned(char_in2)));
	match <= MemOut and StateOut;
end Structure;
