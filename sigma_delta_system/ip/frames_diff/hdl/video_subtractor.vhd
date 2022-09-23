library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity video_subtractor is
    Generic(
        C_DATA_WIDTH  : integer := 8;
        C_THRESHOLD   : integer := 3;
        C_FIFO_DEBUG  : boolean := FALSE;
        C_LOGIC_DEBUG : boolean := FALSE
    );
    Port (
        CLK             : in STD_LOGIC;
        RESETN          : in STD_LOGIC;
        CH0_DATA_IN     : in STD_LOGIC_VECTOR (C_DATA_WIDTH-1 downto 0);
        CH0_SOF         : in STD_LOGIC;
        CH0_EOL         : in STD_LOGIC;
        CH0_READY       : out STD_LOGIC;
        CH0_VALID       : in STD_LOGIC;
        CH1_DATA_IN     : in STD_LOGIC_VECTOR (C_DATA_WIDTH-1 downto 0);
        CH1_SOF         : in STD_LOGIC;
        CH1_EOL         : in STD_LOGIC;
        CH1_READY       : out STD_LOGIC;
        CH1_VALID       : in STD_LOGIC;
        DATA_OUT        : out STD_LOGIC_VECTOR (C_DATA_WIDTH-1 downto 0);
        DATA_OUT_SOF    : out STD_LOGIC;
        DATA_OUT_EOL    : out STD_LOGIC;
        DATA_OUT_READY  : in STD_LOGIC;
        DATA_OUT_VALID  : out STD_LOGIC
    );
end video_subtractor;

architecture Behavioral of video_subtractor is

    component FIFO is
        generic (
            FIFO_DEPTH                  : integer;
            FIFO_WIDTH                  : integer;
            FIFO_ALMOST_FULL_THRESHOLD  : integer;
            FIFO_ALMOST_EMPTY_THRESHOLD : integer;
            FIFO_DEBUG                  : boolean
        );
        Port (
            FIFO_CLK         : in STD_LOGIC;
            FIFO_RESET_N     : in STD_LOGIC;
            FIFO_WRITE_EN    : in STD_LOGIC;
            FIFO_DATA_IN     : in STD_LOGIC_VECTOR;
            FIFO_READ_EN     : in STD_LOGIC;
            FIFO_DATA_OUT    : out STD_LOGIC_VECTOR;
            FIFO_FULL        : out STD_LOGIC;
            FIFO_ALMOST_FULL : out STD_LOGIC;
            FIFO_EMPTY       : out STD_LOGIC;
            FIFO_ALMOST_EMPTY : out STD_LOGIC);
    end component FIFO;

    constant C_FIFO_DEPTH : integer := 64;
    constant C_FIFO_WIDTH : integer := C_DATA_WIDTH + 2;
    constant C_FIFO_ALMOST_FULL_THRESHOLD : integer := 2;
    constant C_FIFO_ALMOST_EMPTY_THRESHOLD : integer := 2;

    type state is (IDLE, SYNC, RUN);
    signal exec_state : state;

    signal data_out_i : STD_LOGIC_VECTOR (C_DATA_WIDTH-1 downto 0);

    signal data_out_eol_i,   data_out_sof_i   : STD_LOGIC;
    signal data_out_ready_i, data_out_valid_i : STD_LOGIC;

    signal ch0_debug, ch1_debug : STD_LOGIC_VECTOR(C_DATA_WIDTH-1 downto 0);

    signal ch0_synced,              ch1_synced      : STD_LOGIC;
    signal ch0_eol_i,               ch1_eol_i       : STD_LOGIC;
    signal ch0_sof_i,               ch1_sof_i       : STD_LOGIC;

    signal ch0_fifo_wr_en,          ch1_fifo_wr_en  : STD_LOGIC;
    signal ch0_fifo_full,           ch1_fifo_full   : STD_LOGIC;
    signal ch0_fifo_empty,          ch1_fifo_empty  : STD_LOGIC;
    signal ch0_fifo_rd_en,          ch1_fifo_rd_en  : STD_LOGIC;
    signal ch0_fifo_in,             ch1_fifo_in     : std_logic_vector(C_FIFO_WIDTH-1 downto 0);
    signal ch0_fifo_out,            ch1_fifo_out    : std_logic_vector(C_FIFO_WIDTH-1 downto 0);
    signal ch0_data_in_i,           ch1_data_in_i   : std_logic_vector(C_DATA_WIDTH-1 downto 0);
    signal ch0_fifo_almost_full,    ch1_fifo_almost_full    : STD_LOGIC;
    signal ch0_fifo_almost_empty,   ch1_fifo_almost_empty   : STD_LOGIC;

    type boolean_str_attr is array(boolean) of string(0 to 4);
    constant c_boolean_str_attr : boolean_str_attr := (false => "false", true => "true ");
    attribute KEEP : string;
    attribute KEEP of ch0_eol_i             : signal is c_boolean_str_attr(C_LOGIC_DEBUG);
    attribute KEEP of ch1_eol_i             : signal is c_boolean_str_attr(C_LOGIC_DEBUG);
    attribute KEEP of ch0_sof_i             : signal is c_boolean_str_attr(C_LOGIC_DEBUG);
    attribute KEEP of ch1_debug             : signal is c_boolean_str_attr(C_LOGIC_DEBUG);
    attribute KEEP of ch0_debug             : signal is c_boolean_str_attr(C_LOGIC_DEBUG);
    attribute KEEP of data_out_i            : signal is c_boolean_str_attr(C_LOGIC_DEBUG);
    attribute KEEP of ch1_sof_i             : signal is c_boolean_str_attr(C_LOGIC_DEBUG);
    attribute KEEP of ch0_fifo_rd_en        : signal is c_boolean_str_attr(C_LOGIC_DEBUG);
    attribute KEEP of ch1_fifo_rd_en        : signal is c_boolean_str_attr(C_LOGIC_DEBUG);
    attribute KEEP of ch0_fifo_wr_en        : signal is c_boolean_str_attr(C_LOGIC_DEBUG);
    attribute KEEP of ch1_fifo_wr_en        : signal is c_boolean_str_attr(C_LOGIC_DEBUG);
    attribute KEEP of ch0_fifo_full         : signal is c_boolean_str_attr(C_LOGIC_DEBUG);
    attribute KEEP of ch1_fifo_full         : signal is c_boolean_str_attr(C_LOGIC_DEBUG);
    attribute KEEP of ch0_fifo_empty        : signal is c_boolean_str_attr(C_LOGIC_DEBUG);
    attribute KEEP of ch1_fifo_empty        : signal is c_boolean_str_attr(C_LOGIC_DEBUG);
    attribute KEEP of ch0_fifo_almost_full  : signal is c_boolean_str_attr(C_LOGIC_DEBUG);
    attribute KEEP of ch1_fifo_almost_full  : signal is c_boolean_str_attr(C_LOGIC_DEBUG);
    attribute KEEP of ch0_fifo_almost_empty : signal is c_boolean_str_attr(C_LOGIC_DEBUG);
    attribute KEEP of ch1_fifo_almost_empty : signal is c_boolean_str_attr(C_LOGIC_DEBUG);

    procedure fifo_read_if_not_empty(
        signal fifo_empty : in std_logic;
        signal fifo_rd_en : out std_logic) is
    begin
        if fifo_empty = '0' then
            fifo_rd_en <= '1';
        else
            fifo_rd_en <= '0';
        end if;
    end procedure fifo_read_if_not_empty;

    procedure synchronize_video_channel(
        signal end_of_line      : in std_logic;
        signal start_of_frame   : in std_logic;
        signal fifo_empty       : in std_logic;
        signal synchronized     : inout std_logic;
        signal fifo_read_enable : out std_logic) is
    begin
        if synchronized = '0' then
            if start_of_frame = '1' then
                fifo_read_enable <= '0';
                synchronized <= '1';
            else
                fifo_read_if_not_empty(fifo_empty, fifo_read_enable);
            end if;
        else
            fifo_read_enable <= '0';
        end if;
    end procedure synchronize_video_channel;

begin

    ch0_fifo_in     <= CH0_SOF & CH0_EOL & CH0_DATA_IN;
    ch1_fifo_in     <= CH1_SOF & CH1_EOL & CH1_DATA_IN;

    ch0_data_in_i   <= ch0_fifo_out(C_DATA_WIDTH-1 downto 0);
    ch0_eol_i       <= ch0_fifo_out(C_DATA_WIDTH);
    ch0_sof_i       <= ch0_fifo_out(C_DATA_WIDTH+1);

    ch1_data_in_i   <= ch1_fifo_out(C_DATA_WIDTH-1 downto 0);
    ch1_eol_i       <= ch1_fifo_out(C_DATA_WIDTH);
    ch1_sof_i       <= ch1_fifo_out(C_DATA_WIDTH+1);

    ch0_fifo : FIFO
        generic map(
            FIFO_DEPTH                  => C_FIFO_DEPTH,
            FIFO_WIDTH                  => C_FIFO_WIDTH,
            FIFO_ALMOST_FULL_THRESHOLD  => C_FIFO_ALMOST_FULL_THRESHOLD,
            FIFO_ALMOST_EMPTY_THRESHOLD => C_FIFO_ALMOST_EMPTY_THRESHOLD,
            FIFO_DEBUG                  => C_FIFO_DEBUG
        )
        port map(
            FIFO_CLK          => CLK,
            FIFO_RESET_N      => RESETN,
            FIFO_WRITE_EN     => ch0_fifo_wr_en,
            FIFO_DATA_IN      => ch0_fifo_in,
            FIFO_READ_EN      => ch0_fifo_rd_en,
            FIFO_DATA_OUT     => ch0_fifo_out,
            FIFO_FULL         => ch0_fifo_full,
            FIFO_ALMOST_FULL  => ch0_fifo_almost_full,
            FIFO_EMPTY        => ch0_fifo_empty,
            FIFO_ALMOST_EMPTY => ch0_fifo_almost_empty
        );

    ch1_fifo : FIFO
        generic map(
            FIFO_DEPTH                  => C_FIFO_DEPTH,
            FIFO_WIDTH                  => C_FIFO_WIDTH,
            FIFO_ALMOST_FULL_THRESHOLD  => C_FIFO_ALMOST_FULL_THRESHOLD,
            FIFO_ALMOST_EMPTY_THRESHOLD => C_FIFO_ALMOST_EMPTY_THRESHOLD,
            FIFO_DEBUG                  => C_FIFO_DEBUG
        )
        port map(
            FIFO_CLK          => CLK,
            FIFO_RESET_N      => RESETN,
            FIFO_WRITE_EN     => ch1_fifo_wr_en,
            FIFO_DATA_IN      => ch1_fifo_in,
            FIFO_READ_EN      => ch1_fifo_rd_en,
            FIFO_DATA_OUT     => ch1_fifo_out,
            FIFO_FULL         => ch1_fifo_full,
            FIFO_ALMOST_FULL  => ch1_fifo_almost_full,
            FIFO_EMPTY        => ch1_fifo_empty,
            FIFO_ALMOST_EMPTY => ch1_fifo_almost_empty
        );

    CH0_READY       <= '1' when (CH0_VALID='1' and ch0_fifo_almost_full='0') else '0';
    CH1_READY       <= '1' when (CH1_VALID='1' and ch1_fifo_almost_full='0') else '0';

    ch0_fifo_wr_en  <= '1' when (CH0_VALID='1' and ch0_fifo_almost_full='0') else '0';
    ch1_fifo_wr_en  <= '1' when (CH1_VALID='1' and ch1_fifo_almost_full='0') else '0';

    data_out_ready_i <= DATA_OUT_READY;
    DATA_OUT_VALID  <= data_out_valid_i;
    DATA_OUT_EOL    <= data_out_eol_i;
    DATA_OUT_SOF    <= data_out_sof_i;
    DATA_OUT        <= data_out_i;

    state_machine_controll: process(CLK)
    begin
        if rising_edge(CLK) then
            if(RESETN = '0') then
                exec_state <= IDLE;
            else
                case exec_state is
                    when IDLE =>
                        if (ch0_fifo_almost_empty = '0' or ch1_fifo_almost_empty = '0') then
                            exec_state <= SYNC;
                        else
                            exec_state <= IDLE;
                        end if;
                    when SYNC =>
                        if (ch0_synced = '1' and ch1_synced = '1') then
                            exec_state <= RUN;
                        else
                            exec_state <= SYNC;
                        end if;
                    when RUN =>
                        if ch0_eol_i /= ch1_eol_i then
                            exec_state <= SYNC;
                        else
                            exec_state <= RUN;
                        end if;
                end case;
            end if;
        end if;
    end process;

    signalization_controll: process(CLK)
    begin
        if rising_edge(CLK) then
            case exec_state is
                when IDLE =>
                    ch0_fifo_rd_en   <= '0';
                    ch1_fifo_rd_en   <= '0';
                    ch0_synced  <= '0';
                    ch1_synced  <= '0';
                when SYNC =>
                    synchronize_video_channel(ch0_eol_i,
                                              ch0_sof_i,
                                              ch0_fifo_almost_empty,
                                              ch0_synced,
                                              ch0_fifo_rd_en);

                    synchronize_video_channel(ch1_eol_i,
                                              ch1_sof_i,
                                              ch1_fifo_almost_empty,
                                              ch1_synced,
                                              ch1_fifo_rd_en);
                when RUN =>
                    ch0_synced <= '0';
                    ch1_synced <= '0';
                    if data_out_ready_i = '1' then
                        if ch0_fifo_almost_empty = '0' and ch1_fifo_almost_empty = '0' then
                            ch0_fifo_rd_en   <= '1';
                            ch1_fifo_rd_en   <= '1';
                            data_out_valid_i <= '1';
                        else
                            ch0_fifo_rd_en   <= '0';
                            ch1_fifo_rd_en   <= '0';
                            data_out_valid_i <= '0';
                        end if;
                    else
                        ch0_fifo_rd_en   <= '0';
                        ch1_fifo_rd_en   <= '0';
                        data_out_valid_i <= '0';
                    end if;
            end case;
        end if;
    end process;

    output_eol_sof_generator: process(CLK)
    begin
        if rising_edge(CLK) then
            case exec_state is
                when RUN =>
                    data_out_eol_i <= (ch0_eol_i and ch1_eol_i);
                    data_out_sof_i <= (ch0_sof_i and ch1_sof_i);
                when others =>
                    data_out_eol_i <= '0';
                    data_out_sof_i <= '0';
            end case;
        end if;
    end process;

    output_frame_generator: process(CLK)
        variable ch0, ch1, diff : unsigned(C_DATA_WIDTH-1 downto 0);
    begin
        if rising_edge(CLK) then
            ch0 := unsigned(ch0_data_in_i);
            ch1 := unsigned(ch1_data_in_i);
            if ch0 > ch1 then
                diff := ch0 - ch1;
            else
                diff := ch1 - ch0;
            end if;
            if diff <= C_THRESHOLD then
                data_out_i <= (others=>'0');
            else
                data_out_i <= (others=>'1');
            end if;
        end if;
    end process;

end Behavioral;