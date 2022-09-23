library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity m_axis_int is
    generic (
        C_M_AXIS_FIFO_DEPTH  : integer := 32;
        C_M_AXIS_TDATA_WIDTH : integer := 32;
        C_M_AXIS_TUSER_WIDTH : integer := 8;
        C_M_AXIS_DEBUG       : boolean := FALSE
    );
    port (
        M_AXIS_ACLK         : in std_logic;
        M_AXIS_ARESETN      : in std_logic;
        M_AXIS_TVALID       : out std_logic;
        M_AXIS_TDATA        : out std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
        M_AXIS_TUSER        : out std_logic_vector(C_M_AXIS_TUSER_WIDTH-1 downto 0);
        M_AXIS_TSTRB        : out std_logic_vector((C_M_AXIS_TDATA_WIDTH/8)-1 downto 0);
        M_AXIS_TLAST        : out std_logic;
        M_AXIS_TREADY       : in std_logic;

        M_FIFO_DATA_IN      : in std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
        M_FIFO_TUSER        : in std_logic_vector(C_M_AXIS_TUSER_WIDTH-1 downto 0);
        M_FIFO_WRITE_EN     : in std_logic;
        M_FIFO_TLAST        : in std_logic;
        M_FIFO_EMPTY        : out std_logic;
        M_FIFO_FULL         : out std_logic;
        M_FIFO_ALMOST_EMPTY : out std_logic;
        M_FIFO_ALMOST_FULL  : out std_logic;
        M_FIFO_NOT_EMPTY        : out std_logic;
        M_FIFO_NOT_FULL         : out std_logic;
        M_FIFO_NOT_ALMOST_EMPTY : out std_logic;
        M_FIFO_NOT_ALMOST_FULL  : out std_logic
    );
end m_axis_int;

architecture implementation of m_axis_int is

    function clog2(x : positive) return natural is
        variable r  : natural := 0;
        variable rp : natural := 1; -- rp tracks the value 2**r
    begin
        while rp < x loop -- Termination condition T: x <= 2**r
        -- Loop invariant L: 2**(r-1) < x
            r := r + 1;
            if rp > integer'high - rp then exit; end if;  -- If doubling rp overflows
            -- the integer range, the doubled value would exceed x, so safe to exit.
            rp := rp + rp;
        end loop;
        -- L and T  <->  2**(r-1) < x <= 2**r  <->  (r-1) < log2(x) <= r
        return r; --
    end clog2;
    
    constant FIFO_DEPTH_LOG2 : natural := clog2(C_M_AXIS_FIFO_DEPTH);
    type state is (IDLE, SEND_STREAM);
    signal  mst_exec_state : state;

    signal axis_tvalid          : std_logic;
    signal axis_tvalid_delay    : std_logic;
    signal axis_tlast           : std_logic;
    signal axis_tuser           : std_logic_vector(C_M_AXIS_TUSER_WIDTH-1 downto 0);
    signal axis_tlast_delay     : std_logic;
    signal axis_tdata           : std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);

    -- FIFO implementation signals
    type TDATA_FIFO_TYPE is array (0 to (C_M_AXIS_FIFO_DEPTH-1)) of std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
    type TUSER_FIFO_TYPE is array (0 to (C_M_AXIS_FIFO_DEPTH-1)) of std_logic_vector(C_M_AXIS_TUSER_WIDTH-1 downto 0);
    type BIT_FIFO_TYPE   is array (0 to (C_M_AXIS_FIFO_DEPTH-1)) of std_logic;

    signal fifo_wr_en,      fifo_rd_en          : std_logic;
    signal fifo_full_i,     fifo_almost_full_i  : std_logic;
    signal fifo_empty_i,    fifo_almost_empty_i : std_logic;
    signal write_pointer, read_pointer : unsigned(FIFO_DEPTH_LOG2-1 downto 0);

    signal fifo_tlast : BIT_FIFO_TYPE;
    signal fifo_tuser : TUSER_FIFO_TYPE;
    signal fifo_tdata : TDATA_FIFO_TYPE;

    type boolean_str_attr is array(boolean) of string(1 to 5);
    constant c_boolean_str_attr : boolean_str_attr := (false => "false", true => "true ");
    attribute KEEP : string;
    attribute KEEP of fifo_wr_en            : signal is c_boolean_str_attr(C_M_AXIS_DEBUG);
    attribute KEEP of fifo_rd_en            : signal is c_boolean_str_attr(C_M_AXIS_DEBUG);
    attribute KEEP of fifo_full_i           : signal is c_boolean_str_attr(C_M_AXIS_DEBUG);
    attribute KEEP of fifo_almost_full_i    : signal is c_boolean_str_attr(C_M_AXIS_DEBUG);
    attribute KEEP of fifo_empty_i          : signal is c_boolean_str_attr(C_M_AXIS_DEBUG);
    attribute KEEP of fifo_almost_empty_i   : signal is c_boolean_str_attr(C_M_AXIS_DEBUG);
    attribute KEEP of write_pointer         : signal is c_boolean_str_attr(C_M_AXIS_DEBUG);
    attribute KEEP of read_pointer          : signal is c_boolean_str_attr(C_M_AXIS_DEBUG);
    attribute KEEP of axis_tvalid           : signal is c_boolean_str_attr(C_M_AXIS_DEBUG);
    attribute KEEP of axis_tvalid_delay     : signal is c_boolean_str_attr(C_M_AXIS_DEBUG);
    attribute KEEP of axis_tlast            : signal is c_boolean_str_attr(C_M_AXIS_DEBUG);
    attribute KEEP of axis_tuser            : signal is c_boolean_str_attr(C_M_AXIS_DEBUG);
    attribute KEEP of axis_tlast_delay      : signal is c_boolean_str_attr(C_M_AXIS_DEBUG);
    attribute KEEP of axis_tdata            : signal is c_boolean_str_attr(C_M_AXIS_DEBUG);

begin
    -- I/O Connections assignments

    M_AXIS_TVALID <= axis_tvalid;
    --M_AXIS_TVALID <= axis_tvalid_delay;
    M_AXIS_TDATA <= axis_tdata;
    M_AXIS_TLAST <= axis_tlast;
    M_AXIS_TUSER <= axis_tuser;
    M_AXIS_TSTRB <= (others => '1');

    M_FIFO_EMPTY        <= fifo_empty_i;
    M_FIFO_ALMOST_EMPTY <= fifo_almost_empty_i;
    M_FIFO_ALMOST_FULL  <= fifo_almost_full_i;
    M_FIFO_FULL         <= fifo_full_i;

    M_FIFO_NOT_EMPTY        <= not fifo_empty_i;
    M_FIFO_NOT_ALMOST_EMPTY <= not fifo_almost_empty_i;
    M_FIFO_NOT_ALMOST_FULL  <= not fifo_almost_full_i;
    M_FIFO_NOT_FULL         <= not fifo_full_i;

    fifo_rd_en <= '1' when (M_AXIS_TREADY='1' and axis_tvalid='1') else '0';
    fifo_wr_en <= '1' when M_FIFO_WRITE_EN='1' else '0';

    -- Control state machine implementation
    process(M_AXIS_ACLK)
    begin
        if (rising_edge (M_AXIS_ACLK)) then
            if(M_AXIS_ARESETN = '0') then
                mst_exec_state <= IDLE;
            else
                case (mst_exec_state) is
                    when IDLE =>
                        if (fifo_almost_empty_i = '0')then
                            mst_exec_state <= SEND_STREAM;
                        else
                            mst_exec_state <= IDLE;
                        end if;
                    when SEND_STREAM =>
                        if (fifo_almost_empty_i = '1') then
                            mst_exec_state <= IDLE;
                        else
                            mst_exec_state <= SEND_STREAM;
                        end if;
                    when others =>
                        mst_exec_state <= IDLE;
                end case;
            end if;
        end if;
    end process;

    axis_tvalid <= '1' when (mst_exec_state = SEND_STREAM) else '0';

    -- Delay the axis_tvalid and axis_tlast signal by one clock cycle
    -- to match the latency of M_AXIS_TDATA
    process(M_AXIS_ACLK)
    begin
        if (rising_edge (M_AXIS_ACLK)) then
            if(M_AXIS_ARESETN = '0') then
                axis_tvalid_delay <= '0';
            else
                axis_tvalid_delay <= axis_tvalid;
            end if;
        end if;
    end process;

    fifo_controll_pointers: process(M_AXIS_ACLK)
        variable fifo_counter : integer range 0 to C_M_AXIS_FIFO_DEPTH-1;
    begin
        if (rising_edge (M_AXIS_ACLK)) then
            if(M_AXIS_ARESETN = '0') then
                fifo_full_i         <= '0';
                fifo_almost_full_i  <= '0';
                fifo_empty_i        <= '1';
                fifo_almost_empty_i <= '1';
                write_pointer       <= (others=>'0');
                read_pointer        <= (others=>'0');
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
                if (fifo_counter = C_M_AXIS_FIFO_DEPTH - 1) then
                    fifo_empty_i <= '0';
                    fifo_almost_empty_i <= '0';
                    fifo_almost_full_i <= '1';
                    fifo_full_i <= '1';
                elsif (fifo_counter >= C_M_AXIS_FIFO_DEPTH - 1 - 2) then
                    fifo_empty_i <= '0';
                    fifo_almost_empty_i <= '0';
                    fifo_almost_full_i <= '1';
                    fifo_full_i <= '0';
                elsif (fifo_counter = 0) then
                    fifo_empty_i <= '1';
                    fifo_almost_empty_i <= '1';
                    fifo_almost_full_i <= '0';
                    fifo_full_i <= '0';
                elsif (fifo_counter <= 2) then
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

    process(M_AXIS_ACLK)
    begin
        if (rising_edge (M_AXIS_ACLK)) then
            if (fifo_wr_en = '1') then
                fifo_tdata(to_integer(write_pointer)) <= M_FIFO_DATA_IN;
                fifo_tlast(to_integer(write_pointer)) <= M_FIFO_TLAST;
                fifo_tuser(to_integer(write_pointer)) <= M_FIFO_TUSER;
            end if;
            if (fifo_rd_en = '1') then
                axis_tlast <= fifo_tlast(to_integer(read_pointer));
                axis_tuser <= fifo_tuser(to_integer(read_pointer));
                axis_tdata <= fifo_tdata(to_integer(read_pointer));
            end if;
        end  if;
    end process;

    --    debug_logic: if C_M_AXIS_DEBUG = TRUE generate
    --        type FIFO_11BIT_T is array (0 to C_M_AXIS_FIFO_DEPTH-1) of integer range 0 to 2047;
    --        signal transaction_counter_in, transaction_counter_out : integer range 0 to 2047;
    --        signal transaction_counter_fifo : FIFO_11BIT_T;
    --        attribute KEEP: string;
    --        attribute KEEP of transaction_counter_in    : signal is "TRUE";
    --        attribute KEEP of transaction_counter_out   : signal is "TRUE";
    --    begin
    --        increment_counter: process(M_AXIS_ACLK)
    --        begin
    --            if rising_edge(M_AXIS_ACLK) then
    --                if M_AXIS_ARESETN = '0' then
    --                    transaction_counter_in <= 0;
    --                else
    --                    if axis_tlast = '1' then
    --                        transaction_counter_in <= 0;
    --                    else
    --                        if fifo_wr_en = '1' then
    --                            transaction_counter_in <= transaction_counter_in + 1;
    --                        else
    --                            transaction_counter_in <= transaction_counter_in;
    --                        end if;
    --                    end if;
    --                end if;
    --            end if;
    --        end process;

    --        process(M_AXIS_ACLK)
    --        begin
    --            if (rising_edge (M_AXIS_ACLK)) then
    --                if (fifo_wr_en = '1') then
    --                    transaction_counter_fifo(write_pointer) <= transaction_counter_in;
    --                end if;
    --                if (fifo_rd_en = '1') then
    --                    transaction_counter_out <= transaction_counter_fifo(read_pointer);
    --                end if;
    --            end if;
    --        end process;

    --    end generate debug_logic;
end implementation;