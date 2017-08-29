library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ste_xilinx is
	port
	(
	rom_q : in std_logic;
	clock, reset, run		:	in std_logic;
	Enable	:	in std_logic;
	match		:	out std_logic
	);
end ste_xilinx;

architecture Structure of ste_xilinx is
	signal StateOut : std_logic;
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

	match <= StateOut and rom_q;
end Structure;
