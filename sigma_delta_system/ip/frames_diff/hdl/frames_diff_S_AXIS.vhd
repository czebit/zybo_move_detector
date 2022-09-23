library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity frames_diff_S_AXIS is
    generic (
        C_S_AXIS_FIFO_DEPTH             : integer := 32;
        C_S_AXIS_TDATA_WIDTH            : integer := 32;
        C_S_AXIS_TUSER_WIDTH            : integer := 8;
        C_S_AXIS_FIFO_ALMOST_FULL_TH    : integer := 1;
        C_S_AXIS_FIFO_ALMOST_EMPTY_TH   : integer := 1;
        C_S_AXIS_DEBUG                  : boolean := FALSE
    );
    port (
        S_AXIS_ACLK         : in std_logic;
        S_AXIS_ARESETN      : in std_logic;
        S_AXIS_TREADY       : out std_logic;
        S_AXIS_TDATA        : in std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
        S_AXIS_TUSER        : in std_logic_vector(C_S_AXIS_TUSER_WIDTH-1 downto 0);
        S_AXIS_TSTRB        : in std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0);
        S_AXIS_TLAST        : in std_logic;
        S_AXIS_TVALID       : in std_logic;
        S_FIFO_DATA_OUT     : out std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
        S_FIFO_READ_EN      : in std_logic;
        S_FIFO_TLAST        : out std_logic;
        S_FIFO_TUSER        : out std_logic_vector(C_S_AXIS_TUSER_WIDTH-1 downto 0);
        S_FIFO_EMPTY        : out std_logic;
        S_FIFO_FULL         : out std_logic;
        S_FIFO_ALMOST_EMPTY : out std_logic;
        S_FIFO_ALMOST_FULL  : out std_logic
    );
end frames_diff_S_AXIS;

architecture arch_imp of frames_diff_S_AXIS is

    type state is (IDLE, WRITE_FIFO);
    signal mst_exec_state   : state;
    signal axis_tready      : std_logic;

    -- FIFO implementation signals
    signal fifo_wr_en,      fifo_rd_en          : std_logic;
    signal fifo_full_i,     fifo_almost_full_i  : std_logic;
    signal fifo_empty_i,    fifo_almost_empty_i : std_logic;
    signal write_pointer,   read_pointer        : integer range 0 to C_S_AXIS_FIFO_DEPTH-1;

    type FIFO_TDATA_T is array (0 to C_S_AXIS_FIFO_DEPTH-1) of std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
    type FIFO_TUSER_T is array (0 to C_S_AXIS_FIFO_DEPTH-1) of std_logic_vector(C_S_AXIS_TUSER_WIDTH-1 downto 0);
    type FIFO_BIT_T   is array (0 to C_S_AXIS_FIFO_DEPTH-1) of std_logic;

    signal tdata_fifo  : FIFO_TDATA_T;
    signal tuser_fifo  : FIFO_TUSER_T;
    signal tlast_fifo  : FIFO_BIT_T;

begin

    S_FIFO_EMPTY        <= fifo_empty_i;
    S_FIFO_ALMOST_EMPTY <= fifo_almost_empty_i;
    S_FIFO_ALMOST_FULL  <= fifo_almost_full_i;
    S_FIFO_FULL         <= fifo_full_i;
    S_AXIS_TREADY       <= axis_tready;

    axis_tready <= '1' when fifo_almost_full_i='0' else '0';
    fifo_wr_en <= S_AXIS_TVALID and axis_tready;
    fifo_rd_en <= S_FIFO_READ_EN;

    fifo_controll_pointers: process(S_AXIS_ACLK)
        variable fifo_counter : integer range 0 to C_S_AXIS_FIFO_DEPTH-1;
    begin
        if (rising_edge(S_AXIS_ACLK)) then
            if S_AXIS_ARESETN = '0' then
                fifo_full_i         <= '0';
                fifo_almost_full_i  <= '0';
                fifo_empty_i        <= '1';
                fifo_almost_empty_i <= '1';
                write_pointer       <= 0;
                read_pointer        <= 0;
                fifo_counter        := 0;
            else
                if (fifo_wr_en='1' and fifo_rd_en='0') then
                    write_pointer <= write_pointer + 1;
                    read_pointer  <= read_pointer;
                    fifo_counter  := fifo_counter + 1;
                elsif (fifo_wr_en='0' and fifo_rd_en='1') then
                    write_pointer <= write_pointer;
                    read_pointer  <= read_pointer + 1;
                    fifo_counter  := fifo_counter - 1;
                elsif (fifo_wr_en='1' and fifo_rd_en='1') then
                    write_pointer <= write_pointer + 1;
                    read_pointer  <= read_pointer + 1;
                    fifo_counter  := fifo_counter;
                elsif (fifo_wr_en='0' and fifo_rd_en='0') then
                    write_pointer <= write_pointer;
                    read_pointer  <= read_pointer;
                    fifo_counter  := fifo_counter;
                end if;
                if (fifo_counter = C_S_AXIS_FIFO_DEPTH - 1) then
                    fifo_empty_i <= '0';
                    fifo_almost_empty_i <= '0';
                    fifo_almost_full_i <= '1';
                    fifo_full_i <= '1';
                elsif (fifo_counter >= C_S_AXIS_FIFO_DEPTH - 1 - C_S_AXIS_FIFO_ALMOST_FULL_TH) then
                    fifo_empty_i <= '0';
                    fifo_almost_empty_i <= '0';
                    fifo_almost_full_i <= '1';
                    fifo_full_i <= '0';
                elsif (fifo_counter = 0) then
                    fifo_empty_i <= '1';
                    fifo_almost_empty_i <= '1';
                    fifo_almost_full_i <= '0';
                    fifo_full_i <= '0';
                elsif (fifo_counter <= C_S_AXIS_FIFO_ALMOST_EMPTY_TH) then
                    fifo_empty_i <= '0';
                    fifo_almost_empty_i <= '1';
                    fifo_almost_full_i <= '0';
                    fifo_full_i <= '0';
                else
                    fifo_empty_i <= '0';
                    fifo_almost_empty_i <= '0';
                    fifo_almost_full_i <= '0';
                    fifo_full_i <= '0';
                end if;
            end if;
        end if;
    end process;

    process(S_AXIS_ACLK)
    begin
        if (rising_edge (S_AXIS_ACLK)) then
            if (fifo_wr_en = '1') then
                tdata_fifo(write_pointer) <= S_AXIS_TDATA;
                tlast_fifo(write_pointer) <= S_AXIS_TLAST;
                tuser_fifo(write_pointer) <= S_AXIS_TUSER;
            end if;
            if (fifo_rd_en = '1') then
                S_FIFO_DATA_OUT <= tdata_fifo(read_pointer);
                S_FIFO_TLAST    <= tlast_fifo(read_pointer);
                S_FIFO_TUSER    <= tuser_fifo(read_pointer);
            end if;
        end if;
    end process;

    debug_logic: if C_S_AXIS_DEBUG = TRUE generate
        type FIFO_11BIT_T is array (0 to C_S_AXIS_FIFO_DEPTH-1) of integer range 0 to 2047;
        signal transaction_counter_in, transaction_counter_out : integer range 0 to 2047;
        signal transaction_counter_fifo : FIFO_11BIT_T;
        attribute KEEP: string;
        attribute KEEP of transaction_counter_in: signal is "TRUE";
        attribute KEEP of transaction_counter_out: signal is "TRUE";
    begin
        increment_counter: process(S_AXIS_ACLK)
        begin
            if rising_edge(S_AXIS_ACLK) then
                if S_AXIS_ARESETN = '0' then
                    transaction_counter_in <= 0;
                else
                    if S_AXIS_TLAST = '1' then
                        transaction_counter_in <= 0;
                    else
                        if fifo_wr_en = '1' then
                            transaction_counter_in <= transaction_counter_in + 1;
                        else
                            transaction_counter_in <= transaction_counter_in;
                        end if;
                    end if;
                end if;
            end if;
        end process;

        process(S_AXIS_ACLK)
        begin
            if (rising_edge (S_AXIS_ACLK)) then
                if (fifo_wr_en = '1') then
                    transaction_counter_fifo(write_pointer) <= transaction_counter_in;
                end if;
                if (fifo_rd_en = '1') then
                    transaction_counter_out <= transaction_counter_fifo(read_pointer);
                end if;
            end if;
        end process;

    end generate debug_logic;

end arch_imp;