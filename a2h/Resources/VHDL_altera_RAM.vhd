library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Altera_SymbolRAM is

	generic 
	(
		DATA_WIDTH : natural := 1;
		ADDR_WIDTH : natural := 8;
		bitvector : std_logic_vector(255 downto 0)
	);

	port 
	(
		clock		: in std_logic;
		addr	: in natural range 0 to 2**ADDR_WIDTH - 1;
		q		: out std_logic_vector((DATA_WIDTH -1) downto 0)
	);

end entity;

architecture rtl of Altera_SymbolRAM is

	-- Build a 2-D array type for the RoM
	subtype word_t is std_logic_vector((DATA_WIDTH-1) downto 0);
	type memory_t is array(2**ADDR_WIDTH-1 downto 0) of word_t;

	function init_rom
		return memory_t is 
		variable tmp : memory_t := (others => (others => '0'));
	begin 
		for addr_pos in 0 to 2**ADDR_WIDTH - 1 loop 
			-- Initialize each address with bitvector
			--tmp(addr_pos) := std_logic_vector(to_unsigned(bitvector(addr_pos)), DATA_WIDTH);
			tmp(addr_pos) := (others=>bitvector(addr_pos));
		end loop;
		return tmp;
	end init_rom;	 

	-- Declare the ROM signal and specify a default value.	Quartus II
	-- will create a memory initialization file (.mif) based on the 
	-- default value.
	signal rom : memory_t := init_rom;

begin

	process(clock)
	begin
	if(rising_edge(clock)) then
		q <= rom(addr);
	end if;
	end process;

end rtl;
