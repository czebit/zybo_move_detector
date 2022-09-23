library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity video_subtractor_tb is
    --  Port ( );
end video_subtractor_tb;

architecture sim of video_subtractor_tb is


    component video_subtractor is
        generic (
            DATA_WIDTH : integer := 8;
            THRESHOLD : integer := 3
        );
        port (
            CLK             : in STD_LOGIC;
            RESETN          : in STD_LOGIC;
            CH0_DATA_IN     : in STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
            CH0_EOF         : in STD_LOGIC;
            CH0_READY       : out STD_LOGIC;
            CH0_VALID       : in STD_LOGIC;
            CH1_DATA_IN     : in STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
            CH1_EOF         : in STD_LOGIC;
            CH1_READY       : out STD_LOGIC;
            CH1_VALID       : in STD_LOGIC;
            DATA_OUT        : out STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
            DATA_OUT_EOF    : out STD_LOGIC;
            DATA_OUT_READY  : in STD_LOGIC;
            DATA_OUT_VALID  : out STD_LOGIC
        );
    end component video_subtractor;
    
constant DATA_WIDTH : integer := 8;
constant THRESHOLD : integer := 3;

signal CLK             : STD_LOGIC;
signal RESETN          : STD_LOGIC;
signal CH0_DATA_IN     : STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
signal CH0_EOF         : STD_LOGIC;
signal CH0_READY       : STD_LOGIC;
signal CH0_VALID       : STD_LOGIC;
signal CH1_DATA_IN     : STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
signal CH1_EOF         : STD_LOGIC;
signal CH1_READY       : STD_LOGIC;
signal CH1_VALID       : STD_LOGIC;
signal DATA_OUT        : STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
signal DATA_OUT_EOF    : STD_LOGIC;
signal DATA_OUT_READY  : STD_LOGIC;
signal DATA_OUT_VALID  : STD_LOGIC;

begin

dut: video_subtractor
    generic map(
        DATA_WIDTH=>DATA_WIDTH,
        THRESHOLD=>THRESHOLD
    )
    port map(
    CLK            => CLK            ,
    RESETN         => RESETN         ,
    CH0_DATA_IN    => CH0_DATA_IN    ,
    CH0_EOF        => CH0_EOF        ,
    CH0_READY      => CH0_READY      ,
    CH0_VALID      => CH0_VALID      ,
    CH1_DATA_IN    => CH1_DATA_IN    ,
    CH1_EOF        => CH1_EOF        ,
    CH1_READY      => CH1_READY      ,
    CH1_VALID      => CH1_VALID      ,
    DATA_OUT       => DATA_OUT       ,
    DATA_OUT_EOF   => DATA_OUT_EOF   ,
    DATA_OUT_READY => DATA_OUT_READY ,
    DATA_OUT_VALID => DATA_OUT_VALID 
    );

    clk_stimulus: process
    begin
        CLK <= '1';
        wait for 5ns;
        CLK <= '0';
        wait for 5ns;
    end process;

    reset_stimulus: process
    begin
        RESETN <= '0';
        wait for 100ns;
        RESETN <= '1';
        wait;
    end process;

    data_generator_ch0: process(CLK)
        variable cnt : integer;
    begin
        if rising_edge(CLK) then
            if RESETN = '0' then
                cnt := 2;
            else
                if (CH0_READY='1' and CH0_VALID='1') then
                    cnt := cnt + 1;
                end if;
            end if;
            if ((cnt mod 10) = 0) then
                CH0_EOF <= '1';
            else
                CH0_EOF <= '0';
            end if;
            CH0_DATA_IN <= std_logic_vector(to_unsigned(cnt, DATA_WIDTH));
        end if;
    end process;
    
    data_generator_ch1: process(CLK)
        variable cnt : integer;
    begin
        if rising_edge(CLK) then
            if RESETN = '0' then
                cnt := 1;
            else
                if (CH1_READY='1' and CH1_VALID='1') then
                    cnt := cnt + 1;
                end if;
            end if;
            if ((cnt mod 10) = 0) then
                CH1_EOF <= '1';
            else
                CH1_EOF <= '0';
            end if;
            CH1_DATA_IN <= std_logic_vector(to_unsigned(cnt, DATA_WIDTH));
        end if;
    end process;

    ch0_valid_generator: process(CLK)
        variable cnt : integer;
    begin
        if rising_edge(CLK) then
            if RESETN = '0' then
                cnt := 0;
            else
                cnt := cnt + 1;
            end if;
            if RESETN='0' then
                CH0_VALID <= '0';
            else
                if (cnt mod 11 < 3) then
                    CH0_VALID <= '1';
                else
                    CH0_VALID <= '0';
                end if;
            end if;
        end if;
    end process;

    ch1_valid_generator: process(CLK)
        variable cnt : integer;
    begin
        if rising_edge(CLK) then
            if RESETN = '0' then
                cnt := 0;
            else
                cnt := cnt + 1;
            end if;
            if RESETN='0' then
                CH1_VALID <= '0';
            else
                if (cnt mod 11 < 8) then
                    CH1_VALID <= '1';
                else
                    CH1_VALID <= '0';
                end if;
            end if;
        end if;
    end process;

    data_out_ready_generator: process(CLK)
        variable cnt : integer;
    begin
        if rising_edge(CLK) then
            if RESETN = '0' then
                cnt := 0;
            else
                cnt := cnt + 1;
            end if;
            if RESETN='0' then
                DATA_OUT_READY <= '0';
            else
                if (cnt mod 21 <= 8) then
                    DATA_OUT_READY <= '1';
                else
                    DATA_OUT_READY <= '0';
                end if;
            end if;
        end if;
    end process;


end sim;
