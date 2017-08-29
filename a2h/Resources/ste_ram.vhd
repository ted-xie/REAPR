library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity ste_ram is
	generic (
		bitvector : std_logic_vector(255 downto 0)
	);
	port
	(
	char_in		:	in std_logic_vector(7 downto 0);
	clock, reset, run		:	in std_logic;
	Enable	:	in std_logic;
	match		:	out std_logic
	);
end ste_ram;

architecture Structure of ste_ram is
	component Altera_SymbolRAM is
		generic (
			bitvector : std_logic_vector(255 downto 0)
		);
		port (
			clock : in std_logic;
			addr : in std_logic_vector(7 downto 0);
			q : out std_logic
		);
	end component;

	signal StateOut : std_logic;
	signal MemOut : std_logic;
begin
	-- RAM cell holds symbol set
	ramblock : Altera_SymbolRAM
	generic map (bitvector=>bitvector)
	port map (clock=>clock,
			addr=>char_in,
			q=>MemOut);

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
	
	match <= MemOut and StateOut;
end Structure;
