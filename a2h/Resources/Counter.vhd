-- Counter.vhd
-- A single 12-bit counter element for use in the Micron Automata Processor.
-- Author: Ted Xie
-- Email: tyx3gu@virginia.edu
-- University of Virginia
-- High Performance Low Power Research Group
-- Creation Date: 2 Jun 2015

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Counter IS
	GENERIC	(target : INTEGER := 8;
			at_target : INTEGER := 0);
	PORT	(clock : IN std_logic;
			Enable, Reset, run : IN std_logic;
			q : OUT std_logic_vector(11 DOWNTO 0);
			match : OUT std_logic);
END Counter;

ARCHITECTURE Behavior OF Counter IS
	function or_reduce(a : std_logic_vector) return std_logic is
		variable ret : std_logic := '0';
	begin
		for i in a'range loop
			ret := ret or a(i);
		end loop;

		return ret;
	end function or_reduce;
	
	SIGNAL count : INTEGER := 0;
	SIGNAL pulse_var : std_logic := '1';
BEGIN
	PROCESS (clock)
	BEGIN
		IF rising_edge(clock) THEN
			IF run='1' THEN
				IF Reset='1' THEN
					count <= 0; -- Reset has priority
				ELSIF Enable = '1' THEN
					IF at_target = 0 THEN -- Pulse
						IF count = target THEN
							pulse_var <= '0';
						ELSE
							count <= count + 1;
						END IF;
					END IF;
					
					IF at_target = 1 THEN -- Latch
						IF count = target THEN
							pulse_var <= '1';
						ELSE
							count <= count+1;
						END IF;
					END IF;
					
					IF at_target = 1 THEN -- Roll
						IF count = target THEN
							pulse_var <= '0';
							count <= 0;
						ELSE
							count <= count+1;
						END IF;
					END IF;
				END IF;
			END IF;
		END IF;
	END PROCESS;

	q <= std_logic_vector(to_unsigned(count+1, 12)) WHEN Enable='1' ELSE std_logic_vector(to_unsigned(count, 12));
	match <= '1' WHEN (target = count) AND (pulse_var = '1') else '0';
END Behavior;