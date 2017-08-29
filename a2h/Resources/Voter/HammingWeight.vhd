library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity HammingWeight is
	generic (INPUT_LENGTH : INTEGER := 20;
			WEIGHT_LENGTH : INTEGER := 20);
			
	port (din : in std_logic_vector(INPUT_LENGTH-1 downto 0);
			weight : out std_logic_vector(WEIGHT_LENGTH-1 downto 0));
end HammingWeight;

architecture Structure of HammingWeight is
	function hweight(a : std_logic_vector(INPUT_LENGTH-1 downto 0)) return std_logic_vector is
		variable ret : std_logic_vector(WEIGHT_LENGTH-1 downto 0) := (others => '0');
	begin
		for i in a'range loop
			ret := ret + a(i);
		end loop;

		return ret;
	end function hweight;
begin
	weight <= hweight(din);
end Structure;