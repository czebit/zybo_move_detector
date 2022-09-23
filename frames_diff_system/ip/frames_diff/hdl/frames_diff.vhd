library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity frames_diff is
    generic (

        -- Parameters of Axi Slave Bus Interface S00_AXIS
        C_S00_AXIS_TDATA_WIDTH : integer := 8;
        C_S00_AXIS_TUSER_WIDTH : integer := 1;
        C_S00_AXIS_FIFO_DEPTH  : integer := 32;
        C_S00_AXIS_DEBUG       : boolean := TRUE;

        -- Parameters of Axi Slave Bus Interface S01_AXIS
        C_S01_AXIS_TDATA_WIDTH : integer := 8;
        C_S01_AXIS_TUSER_WIDTH : integer := 1;
        C_S01_AXIS_FIFO_DEPTH  : integer := 32;
        C_S01_AXIS_DEBUG       : boolean := TRUE;

        -- Parameters of Axi Master Bus Interface M00_AXIS
        C_M00_AXIS_TDATA_WIDTH : integer := 8;
        C_M00_AXIS_TUSER_WIDTH : integer := 1;
        C_M00_AXIS_FIFO_DEPTH  : integer := 32;
        C_M00_AXIS_DEBUG       : boolean := TRUE;
        
        C_PROC_DIFF_THRESHOLD  : integer := 3;
        C_PROC_FIFO_DEBUG      : boolean := TRUE;
        C_PROC_LOGIC_DEBUG     : boolean := TRUE
    );
    port (
        aclk : in std_logic;
        aresetn : in std_logic;
        -- Ports of Axi Slave Bus Interface S00_AXIS
        s00_axis_tready  : out std_logic;
        s00_axis_tdata   : in std_logic_vector(C_S00_AXIS_TDATA_WIDTH-1 downto 0);
        s00_axis_tuser   : in std_logic_vector(C_S00_AXIS_TUSER_WIDTH-1 downto 0);
        s00_axis_tstrb   : in std_logic_vector((C_S00_AXIS_TDATA_WIDTH/8)-1 downto 0);
        s00_axis_tlast   : in std_logic;
        s00_axis_tvalid  : in std_logic;

        -- Ports of Axi Slave Bus Interface S01_AXIS
        s01_axis_tready  : out std_logic;
        s01_axis_tdata   : in std_logic_vector(C_S01_AXIS_TDATA_WIDTH-1 downto 0);
        s01_axis_tuser   : in std_logic_vector(C_S01_AXIS_TUSER_WIDTH-1 downto 0);
        s01_axis_tstrb   : in std_logic_vector((C_S01_AXIS_TDATA_WIDTH/8)-1 downto 0);
        s01_axis_tlast   : in std_logic;
        s01_axis_tvalid  : in std_logic;

        -- Ports of Axi Master Bus Interface M00_AXIS
        m00_axis_tvalid  : out std_logic;
        m00_axis_tdata   : out std_logic_vector(C_M00_AXIS_TDATA_WIDTH-1 downto 0);
        m00_axis_tuser   : out std_logic_vector(C_M00_AXIS_TUSER_WIDTH-1 downto 0);
        m00_axis_tstrb   : out std_logic_vector((C_M00_AXIS_TDATA_WIDTH/8)-1 downto 0);
        m00_axis_tlast   : out std_logic;
        m00_axis_tready  : in std_logic
    );
end frames_diff;

architecture arch_imp of frames_diff is

    component frames_diff_S_AXIS is
        generic (
            C_S_AXIS_TDATA_WIDTH          : integer;
            C_S_AXIS_TUSER_WIDTH          : integer;
            C_S_AXIS_FIFO_DEPTH           : integer;
            C_S_AXIS_FIFO_ALMOST_FULL_TH  : integer;
            C_S_AXIS_FIFO_ALMOST_EMPTY_TH : integer;
            C_S_AXIS_DEBUG                : boolean
        );
        port (
            S_AXIS_ACLK         : in std_logic;
            S_AXIS_ARESETN      : in std_logic;
            S_AXIS_TREADY       : out std_logic;
            S_AXIS_TDATA        : in std_logic_vector;
            S_AXIS_TUSER        : in std_logic_vector;
            S_AXIS_TSTRB        : in std_logic_vector;
            S_AXIS_TLAST        : in std_logic;
            S_AXIS_TVALID       : in std_logic;
            S_FIFO_DATA_OUT     : out std_logic_vector;
            S_FIFO_TUSER        : out std_logic_vector;
            S_FIFO_READ_EN      : in std_logic;
            S_FIFO_TLAST        : out std_logic;
            S_FIFO_EMPTY        : out std_logic;
            S_FIFO_FULL         : out std_logic;
            S_FIFO_ALMOST_EMPTY : out std_logic;
            S_FIFO_ALMOST_FULL  : out std_logic
        );
    end component frames_diff_S_AXIS;

    component frames_diff_M_AXIS is
        generic (
            C_M_AXIS_TDATA_WIDTH : integer;
            C_M_AXIS_TUSER_WIDTH : integer;
            C_M_AXIS_FIFO_DEPTH  : integer;
            C_M_AXIS_DEBUG       : boolean
        );
        port (
            M_AXIS_ACLK         : in std_logic;
            M_AXIS_ARESETN      : in std_logic;
            M_AXIS_TVALID       : out std_logic;
            M_AXIS_TDATA        : out std_logic_vector;
            M_AXIS_TUSER        : out std_logic_vector;
            M_AXIS_TSTRB        : out std_logic_vector;
            M_AXIS_TLAST        : out std_logic;
            M_AXIS_TREADY       : in std_logic;
            M_FIFO_DATA_IN      : in std_logic_vector;
            M_FIFO_TUSER        : in std_logic_vector;
            M_FIFO_WRITE_EN     : in std_logic;
            M_FIFO_TLAST        : in std_logic;
            M_FIFO_EMPTY        : out std_logic;
            M_FIFO_FULL         : out std_logic;
            M_FIFO_ALMOST_EMPTY : out std_logic;
            M_FIFO_ALMOST_FULL  : out std_logic
        );
    end component frames_diff_M_AXIS;

    component video_subtractor is
        generic (
            C_DATA_WIDTH  : integer;
            C_THRESHOLD   : integer;
            C_FIFO_DEBUG  : boolean;
            C_LOGIC_DEBUG : boolean
        );
        port (
            CLK             : in STD_LOGIC;
            RESETN          : in STD_LOGIC;
            CH0_DATA_IN     : in STD_LOGIC_VECTOR;
            CH0_EOL         : in STD_LOGIC;
            CH0_SOF         : in STD_LOGIC;
            CH0_READY       : out STD_LOGIC;
            CH0_VALID       : in STD_LOGIC;
            CH1_DATA_IN     : in STD_LOGIC_VECTOR;
            CH1_EOL         : in STD_LOGIC;
            CH1_SOF         : in STD_LOGIC;
            CH1_READY       : out STD_LOGIC;
            CH1_VALID       : in STD_LOGIC;
            DATA_OUT        : out STD_LOGIC_VECTOR;
            DATA_OUT_EOL    : out STD_LOGIC;
            DATA_OUT_SOF    : out STD_LOGIC;
            DATA_OUT_READY  : in STD_LOGIC;
            DATA_OUT_VALID  : out STD_LOGIC
        );
    end component video_subtractor;

    signal s00_fifo_data_out : std_logic_vector(C_S00_AXIS_TDATA_WIDTH-1 downto 0);
    signal s01_fifo_data_out : std_logic_vector(C_S01_AXIS_TDATA_WIDTH-1 downto 0);
    signal m00_fifo_data_in  : std_logic_vector(C_M00_AXIS_TDATA_WIDTH-1 downto 0);

    signal s00_fifo_tuser    : std_logic_vector(C_S00_AXIS_TUSER_WIDTH-1 downto 0);
    signal s01_fifo_tuser    : std_logic_vector(C_S01_AXIS_TUSER_WIDTH-1 downto 0);
    signal m00_fifo_tuser    : std_logic_vector(C_M00_AXIS_TUSER_WIDTH-1 downto 0);

    signal s00_fifo_read_en,  s01_fifo_read_en, m00_fifo_write_en : std_logic;
    signal s00_fifo_tlast,    s01_fifo_tlast,   m00_fifo_tlast    : std_logic;
    signal s00_fifo_empty,    s01_fifo_empty,   m00_fifo_empty    : std_logic;
    signal s00_fifo_full,     s01_fifo_full,    m00_fifo_full     : std_logic;
    signal not_m00_fifo_full, not_s00_fifo_empty, not_s01_fifo_empty : std_logic;
    signal vid_sub_data_out_valid : std_logic;

    constant C_S00_AXIS_FIFO_ALMOST_FULL_TH  : integer := 1;
    constant C_S00_AXIS_FIFO_ALMOST_EMPTY_TH : integer := 1;
    constant C_S01_AXIS_FIFO_ALMOST_FULL_TH  : integer := 1;
    constant C_S01_AXIS_FIFO_ALMOST_EMPTY_TH : integer := 1;

    attribute KEEP: string;
    attribute KEEP of s00_fifo_tlast: signal is "TRUE";
    attribute KEEP of s01_fifo_tlast: signal is "TRUE";

begin

    frames_diff_S00_AXIS_inst : frames_diff_S_AXIS
        generic map (
            C_S_AXIS_TDATA_WIDTH  => C_S00_AXIS_TDATA_WIDTH,
            C_S_AXIS_TUSER_WIDTH  => C_S00_AXIS_TUSER_WIDTH,
            C_S_AXIS_FIFO_DEPTH   => C_S00_AXIS_FIFO_DEPTH,
            C_S_AXIS_FIFO_ALMOST_FULL_TH    => C_S00_AXIS_FIFO_ALMOST_FULL_TH,
            C_S_AXIS_FIFO_ALMOST_EMPTY_TH   => C_S00_AXIS_FIFO_ALMOST_EMPTY_TH,
            C_S_AXIS_DEBUG         => C_S00_AXIS_DEBUG
        )
        port map (
            S_AXIS_ACLK     => aclk,
            S_AXIS_ARESETN  => aresetn,
            S_AXIS_TREADY   => s00_axis_tready,
            S_AXIS_TDATA    => s00_axis_tdata,
            S_AXIS_TUSER    => s00_axis_tuser,
            S_AXIS_TSTRB    => s00_axis_tstrb,
            S_AXIS_TLAST    => s00_axis_tlast,
            S_AXIS_TVALID   => s00_axis_tvalid,
            S_FIFO_DATA_OUT => s00_fifo_data_out,
            S_FIFO_TUSER    => s00_fifo_tuser,
            S_FIFO_READ_EN  => s00_fifo_read_en,
            S_FIFO_TLAST    => s00_fifo_tlast,
            S_FIFO_ALMOST_EMPTY    => s00_fifo_empty,
            S_FIFO_ALMOST_FULL     => s00_fifo_full
        );

    frames_diff_S01_AXIS_inst : frames_diff_S_AXIS
        generic map (
            C_S_AXIS_TDATA_WIDTH => C_S01_AXIS_TDATA_WIDTH,
            C_S_AXIS_TUSER_WIDTH => C_S01_AXIS_TUSER_WIDTH,
            C_S_AXIS_FIFO_DEPTH  => C_S01_AXIS_FIFO_DEPTH,
            C_S_AXIS_FIFO_ALMOST_FULL_TH    => C_S01_AXIS_FIFO_ALMOST_FULL_TH,
            C_S_AXIS_FIFO_ALMOST_EMPTY_TH   => C_S01_AXIS_FIFO_ALMOST_EMPTY_TH,
            C_S_AXIS_DEBUG       => C_S01_AXIS_DEBUG
        )
        port map (
            S_AXIS_ACLK     => aclk,
            S_AXIS_ARESETN  => aresetn,
            S_AXIS_TREADY   => s01_axis_tready,
            S_AXIS_TDATA    => s01_axis_tdata,
            S_AXIS_TUSER    => s01_axis_tuser,
            S_AXIS_TSTRB    => s01_axis_tstrb,
            S_AXIS_TLAST    => s01_axis_tlast,
            S_AXIS_TVALID   => s01_axis_tvalid,
            S_FIFO_DATA_OUT => s01_fifo_data_out,
            S_FIFO_TUSER    => s01_fifo_tuser,
            S_FIFO_READ_EN  => s01_fifo_read_en,
            S_FIFO_TLAST    => s01_fifo_tlast,
            S_FIFO_ALMOST_EMPTY    => s01_fifo_empty,
            S_FIFO_ALMOST_FULL     => s01_fifo_full
        );

    frames_diff_M00_AXIS_inst : frames_diff_M_AXIS
        generic map (
            C_M_AXIS_TDATA_WIDTH => C_M00_AXIS_TDATA_WIDTH,
            C_M_AXIS_TUSER_WIDTH => C_M00_AXIS_TUSER_WIDTH,
            C_M_AXIS_FIFO_DEPTH  => C_M00_AXIS_FIFO_DEPTH,
            C_M_AXIS_DEBUG       => C_M00_AXIS_DEBUG
        )
        port map (
            M_AXIS_ACLK     => aclk,
            M_AXIS_ARESETN  => aresetn,
            M_AXIS_TVALID   => m00_axis_tvalid,
            M_AXIS_TDATA    => m00_axis_tdata,
            M_AXIS_TUSER    => m00_axis_tuser,
            M_AXIS_TSTRB    => m00_axis_tstrb,
            M_AXIS_TLAST    => m00_axis_tlast,
            M_AXIS_TREADY   => m00_axis_tready,
            M_FIFO_DATA_IN  => m00_fifo_data_in,
            M_FIFO_TUSER    => m00_fifo_tuser,
            M_FIFO_WRITE_EN => vid_sub_data_out_valid,
            M_FIFO_TLAST    => m00_fifo_tlast,
            M_FIFO_ALMOST_EMPTY => m00_fifo_empty,
            M_FIFO_ALMOST_FULL  => m00_fifo_full
        );

    video_subtractor_0 : video_subtractor
        generic map (
            C_DATA_WIDTH  => C_M00_AXIS_TDATA_WIDTH,
            C_THRESHOLD   => C_PROC_DIFF_THRESHOLD,
            C_FIFO_DEBUG  => C_PROC_FIFO_DEBUG,
            C_LOGIC_DEBUG => C_PROC_LOGIC_DEBUG
        )
        port map (
            CLK             => aclk,
            RESETN          => aresetn,
            CH0_DATA_IN     => s00_fifo_data_out,
            CH0_EOL         => s00_fifo_tlast,
            CH0_SOF         => s00_fifo_tuser(0),
            CH0_READY       => s00_fifo_read_en,
            CH0_VALID       => not_s00_fifo_empty,
            CH1_DATA_IN     => s01_fifo_data_out,
            CH1_EOL         => s01_fifo_tlast,
            CH1_SOF         => s01_fifo_tuser(0),
            CH1_READY       => s01_fifo_read_en,
            CH1_VALID       => not_s01_fifo_empty,
            DATA_OUT        => m00_fifo_data_in,
            DATA_OUT_EOL    => m00_fifo_tlast,
            DATA_OUT_SOF    => m00_fifo_tuser(0),
            DATA_OUT_READY  => not_m00_fifo_full,
            DATA_OUT_VALID  => vid_sub_data_out_valid
        );

    not_m00_fifo_full  <= '1' when (m00_fifo_full='0') else '0';
    not_s00_fifo_empty <= '1' when (s00_fifo_empty='0') else '0';
    not_s01_fifo_empty <= '1' when (s01_fifo_empty='0') else '0';

end arch_imp;