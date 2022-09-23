library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity m_axis_tb is
    --  Port ( );
end m_axis_tb;

architecture sim of m_axis_tb is

    component frames_diff_v1_0_M00_AXIS is
        generic (
            C_M_AXIS_TDATA_WIDTH : integer := 32;
            C_M_AXIS_FIFO_DEEP   : integer := 32
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

    constant C_M_AXIS_TDATA_WIDTH   : integer := 32;
    constant C_M_AXIS_FIFO_DEEP     : integer := 32;

    signal M_AXIS_ACLK         : std_logic;
    signal M_AXIS_ARESETN      : std_logic;
    signal M_AXIS_TVALID       : std_logic;
    signal M_AXIS_TDATA        : std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
    signal M_AXIS_TSTRB        : std_logic_vector((C_M_AXIS_TDATA_WIDTH/8)-1 downto 0);
    signal M_AXIS_TLAST        : std_logic;
    signal M_AXIS_TREADY       : std_logic;
    signal M_FIFO_DATA_IN      : std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
    signal M_FIFO_WRITE_EN     : std_logic;
    signal M_FIFO_TLAST        : std_logic;
    signal M_FIFO_EMPTY        : std_logic;
    signal M_FIFO_FULL         : std_logic;
    signal M_FIFO_ALMOST_EMPTY : std_logic;
    signal M_FIFO_ALMOST_FULL  : std_logic;

    signal TDATA : std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
    signal index, cnt, mem_pointer_tdata_in, mem_pointer_tdata_out : integer := 0;

    constant TEST_LENGTH : integer := 2**16;
    type MEMORY is array (0 to (TEST_LENGTH-1)) of std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);

    signal data_sent, data_recivied : MEMORY;

    procedure increment_counter (signal counter       : inout integer;
                                 constant upper_limit : in integer) is
    begin
        if counter = upper_limit-1 then
            counter <= counter;
        else
            counter <= counter + 1;
        end if;
    end procedure;
    
begin
    dut : frames_diff_v1_0_M00_AXIS
        generic map (
            C_M_AXIS_TDATA_WIDTH  => C_M_AXIS_TDATA_WIDTH,
            C_M_AXIS_FIFO_DEEP    => C_M_AXIS_FIFO_DEEP
        )
        port map (
            M_AXIS_ACLK         => M_AXIS_ACLK          ,
            M_AXIS_ARESETN      => M_AXIS_ARESETN       ,
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

    clk_stimulus: process
    begin
        M_AXIS_ACLK <= '1';
        wait for 5ns;
        M_AXIS_ACLK <= '0';
        wait for 5ns;
    end process;

    reset_stimulus: process
    begin
        M_AXIS_ARESETN <= '0';
        wait for 100ns;
        M_AXIS_ARESETN <= '1';
        wait;
    end process;

    cnt_counter: process(M_AXIS_ACLK)
    begin
        if rising_edge(M_AXIS_ACLK) then
            if M_AXIS_ARESETN='0' then
                cnt <= 0;
            else
                cnt <= cnt + 1;
            end if;
        end if;
    end process;

    tready_stim: process(M_AXIS_ACLK)
        variable cnt : integer;
    begin
        if rising_edge(M_AXIS_ACLK) then
            if M_AXIS_ARESETN = '0' then
                M_AXIS_TREADY <= '0';
                cnt := 0;
            else
                cnt := cnt +1;
                if cnt mod 15 < 1 then
                    M_AXIS_TREADY <= '0';
                else
                    M_AXIS_TREADY <= '1';
                end if;
            end if;
        end if;
    end process;

    generate_tdata: process(M_AXIS_ACLK)
    begin
        if rising_edge(M_AXIS_ACLK) then
            if M_AXIS_ARESETN = '0' then
                TDATA <= (others=>'X');
            else
                TDATA <= std_logic_vector(to_signed(cnt, 32));
            end if;
        end if;
    end process;

    mem_pointer_input: process(M_AXIS_ACLK)
    begin
        if rising_edge(M_AXIS_ACLK) then
            if M_AXIS_ARESETN = '0' then
                mem_pointer_tdata_in <= 0;
            else
                if M_FIFO_WRITE_EN='1' then
                    increment_counter(mem_pointer_tdata_in, TEST_LENGTH);
                end if;
            end if;
        end if;
    end process;

    mem_pointer_output: process(M_AXIS_ACLK)
    begin
        if rising_edge(M_AXIS_ACLK) then
            if M_AXIS_ARESETN = '0' then
                mem_pointer_tdata_out <= 0;
            else
                if M_AXIS_TREADY='1' and M_AXIS_TVALID='1' then
                    increment_counter(mem_pointer_tdata_out, TEST_LENGTH);
                end if;
            end if;
        end if;
    end process;

    feed_fifo_with_tdata: process(M_AXIS_ACLK)
    begin
        if rising_edge(M_AXIS_ACLK) then
            M_FIFO_DATA_IN    <= TDATA;
            data_sent(mem_pointer_tdata_in)  <= M_FIFO_DATA_IN;
        end if;
    end process;
    
    save_received_data: process(M_AXIS_ACLK)
        variable cnt : integer;
    begin
        if rising_edge(M_AXIS_ACLK) then
            if M_AXIS_TREADY='1' and M_AXIS_TVALID='1' then
                data_recivied(mem_pointer_tdata_out) <= M_AXIS_TDATA;
            end if;
            if mem_pointer_tdata_out > 0 then
                assert data_recivied(mem_pointer_tdata_out-1) = data_sent(mem_pointer_tdata_out-1) report "damn" severity note;
            end if;
        end if;
    end process;

    wr_en_stim: process(M_AXIS_ACLK)
        variable cnt : integer;
    begin
        if rising_edge(M_AXIS_ACLK) then
            if M_AXIS_ARESETN = '0' then
                M_FIFO_WRITE_EN <= '0';
                cnt := 0;
            else
                cnt := cnt +1;
                if (cnt mod 12 < 5) or M_FIFO_ALMOST_FULL='1' then
                    M_FIFO_WRITE_EN <= '0';
                else
                    M_FIFO_WRITE_EN <= '1';
                end if;
            end if;
        end if;
    end process;

end sim;
