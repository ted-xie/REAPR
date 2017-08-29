library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

Library xpm;
use xpm.vcomponents.all;

entity xilinx_bram is
    generic (MemInitFile : STRING := "");
    Port ( clock : in STD_LOGIC;
           en : in STD_LOGIC;
           addr : in STD_LOGIC_VECTOR(7 downto 0);
           data : out STD_LOGIC_VECTOR(71 downto 0));
end xilinx_bram;

architecture Behavioral of xilinx_bram is
begin
    xpm_memory_sprom_inst : xpm_memory_sprom
      generic map (
    
        -- Common module generics
        MEMORY_SIZE        => 18*1024,        --positive integer
        MEMORY_PRIMITIVE   => "block",      --string; "auto", "distributed", "block" or "ultra" ;
        MEMORY_INIT_FILE   => MemInitFile,      --string; "none" or "<filename>.mem" 
        MEMORY_INIT_PARAM  => "",          --string;
        USE_MEM_INIT       => 1,           --integer; 0,1
        WAKEUP_TIME        => "disable_sleep",--string; "disable_sleep" or "use_sleep_pin" 
        MESSAGE_CONTROL    => 0,           --integer; 0,1
    
        -- Port A module generics
        READ_DATA_WIDTH_A  => 72,          --positive integer
        ADDR_WIDTH_A       => 8,           --positive integer
        READ_RESET_VALUE_A => "0",         --string
        READ_LATENCY_A     => 2            --non-negative integer
      )
      port map (
    
        -- Common module ports
        sleep          => '0',
    
        -- Port A module ports
        clka           => clock,
        rsta           => '0',
        ena            => en,
        regcea         => '1',
        addra          => addr,
        injectsbiterra => '0',   --do not change
        injectdbiterra => '0',   --do not change
        douta          => data,
        sbiterra       => open,  --do not change
        dbiterra       => open   --do not change
      );
end Behavioral;
