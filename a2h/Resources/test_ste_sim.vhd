library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ste_tb is
end ste_tb;

architecture Test of ste_tb is
	constant all_zero256 : std_logic_vector(255 downto 0) := (others=>'0');
	constant all_one256 : std_logic_vector(255 downto 0) := (others=>'1');
	signal bv1 : std_logic_vector(255 downto 0) := all_zero256;
	signal bv2 : std_logic_vector(255 downto 0) := all_zero256(255 downto 3) & "101";
	signal bv3 : std_logic_vector(255 downto 0) := all_one256;
	signal bv4 : std_logic_vector(255 downto 0) := all_one256(255 downto 3) & "010";
	signal bv : std_logic_vector(255 downto 0);

	signal data : std_logic_vector(7 downto 0) := (others=>'0');
	signal Enables : std_logic_vector(15 downto 0) := x"8000";
	signal matchOut : std_logic := '0';
	signal clock : std_logic := '0';

	component ste_sim
		port
		(
		bitvector	:	in std_logic_vector(255 downto 0);
		char_in		:	in std_logic_vector(7 downto 0);
		clock		:	in std_logic;
		OtherSTEs	:	in std_logic_vector(15 downto 0);
		match		:	out std_logic		
		);
	end component;
begin
	dut: ste_sim
	port map 
	(
		bitvector=>bv,
		clock=>clock,
		char_in=>data,
		OtherSTEs=>Enables,
		match=>matchOut
	);

	-- Process that controls the dataflow
	process
	begin
		bv <= bv1; -- First test bitvector
		data <= x"00";

		clock <= '1';
		wait for 50 ns;
		clock <= '0';
		wait for 50 ns;

		assert matchOut = '0'
			report "BV1, data=0x00 failed." severity error;

		data <= x"FF";
		
		clock <= '1';
		wait for 50 ns;
		clock <= '0';
		wait for 50 ns;

		assert matchOut = '0'
			report "BV1, data=0xFF failed." severity error;

		bv <= bv2;
		data <= x"00";
		
		clock <= '1';
		wait for 50 ns;
		clock <= '0';
		wait for 50 ns;
		
		assert matchOut = '1'
			report "BV2, data=0x00 failed." severity error;

		data <= x"02";
		
		clock <= '1';
		wait for 50 ns;
		clock <= '0';
		wait for 50 ns;

		assert matchOut = '1'
			report "BV2, data=0x02 failed." severity error;

		data <= x"04";

		clock <= '1';
		wait for 50 ns;
		clock <= '0';
		wait for 50 ns;

		assert matchOut = '0'
			report "BV2, data=0x04 failed." severity error;
				
		bv <= bv3;
		data <= x"00";

		clock <= '1';
		wait for 50 ns;
		clock <= '0';
		wait for 50 ns;
		
		assert matchOut = '1'
			report "BV3, data=0x00 failed." severity error;

		data <= x"FF";
		
		clock <= '1';
		wait for 50 ns;
		clock <= '0';
		wait for 50 ns;

		assert matchOut = '1'
			report "BV3, data=0xFF failed." severity error;

		data <= x"A5";

		clock <= '1';
		wait for 50 ns;
		clock <= '0';
		wait for 50 ns;
	
		assert matchOut = '1'
			report "BV3, data=0xA5 failed." severity error;

		bv <= bv4;
		data <= x"00";

		clock <= '1';
		wait for 50 ns;
		clock <= '0';
		wait for 50 ns;
	
		assert matchOut = '0'
			report "BV4, data=0x00 failed." severity error;

		data <= x"02";

		clock <= '1';
		wait for 50 ns;
		clock <= '0';
		wait for 50 ns;
	
		assert matchOut = '0'
			report "BV4, data=0x02 failed." severity error;

		data <= x"01";
		
		clock <= '1';
		wait for 50 ns;
		clock <= '0';
		wait for 50 ns;

		assert matchOut = '1'
			report "BV4, data=0x01 failed." severity error;

		-- If the simulation still runs here, then it was a success
		assert false
			report "Simulation successful!" severity note;	
		wait;	
	end process;
end Test;
