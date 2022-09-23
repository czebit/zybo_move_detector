library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity m_s_axi_tb is
    --  Port ( );
end m_s_axi_tb;

architecture sim of m_s_axi_tb is

    component frames_diff_v1_0_S00_AXIS is
        generic (
            C_S_AXIS_TDATA_WIDTH : integer := 32;
            C_S_AXIS_FIFO_DEEP   : integer := 32
        );
        port (
            S_AXIS_ACLK         : in std_logic;
            S_AXIS_ARESETN      : in std_logic;
            S_AXIS_TREADY       : out std_logic;
            S_AXIS_TDATA        : in std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
            S_AXIS_TSTRB        : in std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0);
            S_AXIS_TLAST        : in std_logic;
            S_AXIS_TVALID       : in std_logic;
            S_FIFO_DATA_OUT     : out std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
            S_FIFO_READ_EN      : in std_logic;
            S_FIFO_TLAST        : out std_logic;
            S_FIFO_EMPTY        : out std_logic;
            S_FIFO_FULL         : out std_logic;
            S_FIFO_ALMOST_EMPTY : out std_logic;
            S_FIFO_ALMOST_FULL  : out std_logic
        );
    end component frames_diff_v1_0_S00_AXIS;

    component frames_diff_v1_0_M00_AXIS is
        generic (
            C_M_AXIS_TDATA_WIDTH : integer := 32;
            C_M_AXIS_FIFO_DEEP   : integer := 8
        );
        port (
            M_AXIS_ACLK         : in std_logic;
            M_AXIS_ARESETN      : in std_logic;
            M_AXIS_TVALID       : out std_logic;
            M_AXIS_TDATA        : out std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
            M_AXIS_TSTRB        : out std_logic_vector((C_M_AXIS_TDATA_WIDTH/8)-1 downto 0);
            M_AXIS_TLAST        : out std_logic;
            M_AXIS_TREADY       : in std_logic;
            M_FIFO_DATA_IN      : in std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
            M_FIFO_WRITE_EN     : in std_logic;
            M_FIFO_TLAST        : in std_logic;
            M_FIFO_EMPTY        : out std_logic;
            M_FIFO_FULL         : out std_logic;
            M_FIFO_ALMOST_EMPTY : out std_logic;
            M_FIFO_ALMOST_FULL  : out std_logic
        );
    end component frames_diff_v1_0_M00_AXIS;

    signal ACLK         : std_logic;
    signal ARESETN      : std_logic;
    constant TDATA_WIDTH   : integer := 32;
    constant FIFO_DEEP     : integer := 32;

    signal M_AXIS_TVALID       : std_logic;
    signal M_AXIS_TDATA        : std_logic_vector(TDATA_WIDTH-1 downto 0);
    signal M_AXIS_TSTRB        : std_logic_vector((TDATA_WIDTH/8)-1 downto 0);
    signal M_AXIS_TLAST        : std_logic;
    signal M_AXIS_TREADY       : std_logic;
    signal M_FIFO_DATA_IN      : std_logic_vector(TDATA_WIDTH-1 downto 0);
    signal M_FIFO_WRITE_EN     : std_logic;
    signal M_FIFO_TLAST        : std_logic;
    signal M_FIFO_EMPTY        : std_logic;
    signal M_FIFO_FULL         : std_logic;
    signal M_FIFO_ALMOST_EMPTY : std_logic;
    signal M_FIFO_ALMOST_FULL  : std_logic;



    signal S_AXIS_TREADY       : std_logic;
    signal S_AXIS_TDATA        : std_logic_vector(TDATA_WIDTH-1 downto 0);
    signal S_AXIS_TSTRB        : std_logic_vector((TDATA_WIDTH/8)-1 downto 0);
    signal S_AXIS_TLAST        : std_logic;
    signal S_AXIS_TVALID       : std_logic;
    signal S_FIFO_DATA_OUT     : std_logic_vector(TDATA_WIDTH-1 downto 0);
    signal S_FIFO_READ_EN      : std_logic;
    signal S_FIFO_TLAST        : std_logic;
    signal S_FIFO_EMPTY        : std_logic;
    signal S_FIFO_FULL         : std_logic;
    signal S_FIFO_ALMOST_EMPTY : std_logic;
    signal S_FIFO_ALMOST_FULL  : std_logic;

begin

    dut_master : frames_diff_v1_0_M00_AXIS
        generic map (
            C_M_AXIS_TDATA_WIDTH  => TDATA_WIDTH,
            C_M_AXIS_FIFO_DEEP    => FIFO_DEEP
        )
        port map (
            M_AXIS_ACLK         => ACLK          ,
            M_AXIS_ARESETN      => ARESETN       ,
            M_AXIS_TREADY       => M_AXIS_TREADY        ,
            M_AXIS_TDATA        => M_AXIS_TDATA         ,
            M_AXIS_TSTRB        => M_AXIS_TSTRB         ,
            M_AXIS_TLAST        => M_AXIS_TLAST         ,
            M_AXIS_TVALID       => M_AXIS_TVALID        ,
            M_FIFO_DATA_IN      => M_FIFO_DATA_IN       ,
            M_FIFO_WRITE_EN     => M_FIFO_WRITE_EN      ,
            M_FIFO_TLAST        => M_FIFO_TLAST         ,
            M_FIFO_EMPTY        => M_FIFO_EMPTY         ,
            M_FIFO_FULL         => M_FIFO_FULL          ,
            M_FIFO_ALMOST_EMPTY => M_FIFO_ALMOST_EMPTY  ,
            M_FIFO_ALMOST_FULL  => M_FIFO_ALMOST_FULL
        );

    dut_slave : frames_diff_v1_0_S00_AXIS
        generic map (
            C_S_AXIS_TDATA_WIDTH  =>TDATA_WIDTH,
            C_S_AXIS_FIFO_DEEP    => FIFO_DEEP
        )
        port map (
            S_AXIS_ACLK         => ACLK          ,
            S_AXIS_ARESETN      => ARESETN       ,
            S_AXIS_TREADY       => S_AXIS_TREADY        ,
            S_AXIS_TDATA        => S_AXIS_TDATA         ,
            S_AXIS_TSTRB        => S_AXIS_TSTRB         ,
            S_AXIS_TLAST        => S_AXIS_TLAST         ,
            S_AXIS_TVALID       => S_AXIS_TVALID        ,
            S_FIFO_DATA_OUT     => S_FIFO_DATA_OUT      ,
            S_FIFO_READ_EN      => S_FIFO_READ_EN       ,
            S_FIFO_TLAST        => S_FIFO_TLAST         ,
            S_FIFO_EMPTY        => S_FIFO_EMPTY         ,
            S_FIFO_FULL         => S_FIFO_FULL          ,
            S_FIFO_ALMOST_EMPTY => S_FIFO_ALMOST_EMPTY  ,
            S_FIFO_ALMOST_FULL  => S_FIFO_ALMOST_FULL
        );

    clk_stimulus: process
    begin
        ACLK <= '1';
        wait for 5ns;
        ACLK <= '0';
        wait for 5ns;
    end process;

    reset_stimulus: process
    begin
        ARESETN <= '0';
        wait for 100ns;
        ARESETN <= '1';
        wait;
    end process;

    data_generator: process(ACLK)
        variable cnt : integer;
    begin
        if rising_edge(ACLK) then
            if ARESETN = '0' then
                cnt := 0;
            else
                if M_FIFO_WRITE_EN='1' then
                    cnt := cnt + 1;
                end if;
            end if;
            if ((cnt mod 10) = 0) then
                M_FIFO_TLAST <= '1';
            else
                M_FIFO_TLAST <= '0';
            end if;
            M_FIFO_DATA_IN <= std_logic_vector(to_unsigned(cnt, TDATA_WIDTH));
        end if;
    end process;

    write_en_generator: process(ACLK)
        variable cnt : integer;
    begin
        if rising_edge(ACLK) then
            if ARESETN = '0' then
                cnt := 0;
            else
                cnt := cnt + 1;
            end if;
            if ARESETN='0' then
                M_FIFO_WRITE_EN <= '0';
            else
                if ((cnt mod 11 < 8) and M_FIFO_FULL = '0') then
                    M_FIFO_WRITE_EN <= '1';
                else
                    M_FIFO_WRITE_EN <= '0';
                end if;
            end if;
        end if;
    end process;

    read_en_generator: process(ACLK)
        variable cnt : integer;
    begin
        if rising_edge(ACLK) then
            if ARESETN = '0' then
                cnt := 0;
            else
                cnt := cnt + 1;
            end if;
            if ARESETN='0' then
                S_FIFO_READ_EN <= '0';
            else
                if ((cnt mod 13 <= 8) and S_FIFO_EMPTY = '0') then
                    S_FIFO_READ_EN <= '1';
                else
                    S_FIFO_READ_EN <= '0';
                end if;
            end if;
        end if;
    end process;

    S_AXIS_TDATA <= M_AXIS_TDATA;
    S_AXIS_TLAST <= M_AXIS_TLAST;
    M_AXIS_TREADY <= S_AXIS_TREADY;
    S_AXIS_TSTRB <= M_AXIS_TSTRB;
    S_AXIS_TVALID <= M_AXIS_TVALID;

    assert not(S_FIFO_READ_EN='1' and S_FIFO_EMPTY='1')
    report "S_FIFO_READ_EN and S_FIFO_EMPTY"
    severity ERROR;

    assert not(M_FIFO_WRITE_EN='1' and M_FIFO_FULL='1')
    report "S_FIFO_READ_EN and S_FIFO_EMPTY"
    severity ERROR;
    
end sim;
