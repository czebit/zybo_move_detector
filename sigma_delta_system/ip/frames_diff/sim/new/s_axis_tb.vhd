library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity s_axis_tb is
    --  Port ( );
end s_axis_tb;

architecture sim of s_axis_tb is


    component frames_diff_S_AXIS is
        generic (
            C_S_AXIS_TDATA_WIDTH          : integer;
            C_S_AXIS_TUSER_WIDTH          : integer;
            C_S_AXIS_FIFO_DEEP            : integer;
            C_S_AXIS_FIFO_ALMOST_FULL_TH  : integer;
            C_S_AXIS_FIFO_ALMOST_EMPTY_TH : integer
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
            S_FIFO_TUSER        : out std_logic_vector(C_S_AXIS_TUSER_WIDTH-1 downto 0);
            S_FIFO_READ_EN      : in std_logic;
            S_FIFO_TLAST        : out std_logic;
            S_FIFO_EMPTY        : out std_logic;
            S_FIFO_FULL         : out std_logic;
            S_FIFO_ALMOST_EMPTY : out std_logic;
            S_FIFO_ALMOST_FULL  : out std_logic
        );
    end component frames_diff_S_AXIS;

    constant C_S_AXIS_TDATA_WIDTH   : integer := 32;
    constant C_S_AXIS_FIFO_DEEP     : integer := 8;
    constant C_S_AXIS_TUSER_WIDTH          : integer := 1;
    constant C_S_AXIS_FIFO_ALMOST_FULL_TH  : integer := 1;
    constant C_S_AXIS_FIFO_ALMOST_EMPTY_TH : integer := 1;
    
    signal S_AXIS_ACLK         : std_logic;
    signal S_AXIS_ARESETN      : std_logic;
    signal S_AXIS_TREADY       : std_logic;
    signal S_AXIS_TDATA        : std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
    signal S_AXIS_TUSER        : std_logic_vector(C_S_AXIS_TUSER_WIDTH-1 downto 0);
    signal S_AXIS_TSTRB        : std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0);
    signal S_AXIS_TLAST        : std_logic;
    signal S_AXIS_TVALID       : std_logic;
    signal S_FIFO_DATA_OUT     : std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
    signal S_FIFO_READ_EN      : std_logic;
    signal S_FIFO_TLAST        : std_logic;
    signal S_FIFO_EMPTY        : std_logic;
    signal S_FIFO_FULL         : std_logic;
    signal S_FIFO_ALMOST_EMPTY : std_logic;
    signal S_FIFO_ALMOST_FULL  : std_logic;

    signal TDATA : std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
    signal S_FIFO_READ_EN_DELAY : std_logic;
    signal index, cnt, mem_pointer_tdata_in, mem_pointer_tdata_out : integer := 0;

    constant TEST_LENGTH : integer := 2**16;
    type MEMORY is array (0 to (TEST_LENGTH-1)) of std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);

    signal data_sent, data_recivied : MEMORY;

    procedure increment_counter (   signal counter : inout integer;
                                constant upper_limit : in integer) is
    begin
        if counter = upper_limit-1 then
            counter <= counter;
        else
            counter <= counter + 1;
        end if;
    end procedure;

begin
    dut : frames_diff_S_AXIS
        generic map (
            C_S_AXIS_TDATA_WIDTH  => C_S_AXIS_TDATA_WIDTH,
            C_S_AXIS_FIFO_DEEP    => C_S_AXIS_FIFO_DEEP,
            C_S_AXIS_TUSER_WIDTH => C_S_AXIS_TUSER_WIDTH,
            C_S_AXIS_FIFO_ALMOST_FULL_TH => C_S_AXIS_FIFO_ALMOST_FULL_TH,
            C_S_AXIS_FIFO_ALMOST_EMPTY_TH => C_S_AXIS_FIFO_ALMOST_EMPTY_TH
        )
        port map (
            S_AXIS_ACLK         => S_AXIS_ACLK          ,
            S_AXIS_ARESETN      => S_AXIS_ARESETN       ,
            S_AXIS_TREADY       => S_AXIS_TREADY        ,
            S_AXIS_TDATA        => S_AXIS_TDATA         ,
            S_AXIS_TUSER        => S_AXIS_TUSER         ,
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
        S_AXIS_ACLK <= '1';
        wait for 5ns;
        S_AXIS_ACLK <= '0';
        wait for 5ns;
    end process;

    reset_stimulus: process
    begin
        S_AXIS_ARESETN <= '0';
        wait for 100ns;
        S_AXIS_ARESETN <= '1';
        wait;
    end process;

    cnt_counter: process(S_AXIS_ACLK)
    begin
        if rising_edge(S_AXIS_ACLK) then
            if S_AXIS_ARESETN='0' then
                cnt <= 0;
            else
                cnt <= cnt + 1;
            end if;
        end if;
    end process;

    generate_tdata: process(S_AXIS_ACLK)
    begin
        if rising_edge(S_AXIS_ACLK) then
            if S_AXIS_ARESETN = '0' then
                TDATA <= (others=>'X');
            else
                TDATA <= std_logic_vector(to_signed(cnt, 32));
            end if;
        end if;
    end process;

    mem_pointer_input: process(S_AXIS_ACLK)
    begin
        if rising_edge(S_AXIS_ACLK) then
            if S_AXIS_ARESETN = '0' then
                mem_pointer_tdata_in <= 0;
            else
                if S_AXIS_TREADY='1' and S_AXIS_TVALID='1' then
                    increment_counter(mem_pointer_tdata_in, TEST_LENGTH);
                end if;
            end if;
        end if;
    end process;

    mem_pointer_output: process(S_AXIS_ACLK)
    begin
        if rising_edge(S_AXIS_ACLK) then
            if S_AXIS_ARESETN = '0' then
                mem_pointer_tdata_out <= 0;
            else
                if S_FIFO_READ_EN_DELAY='1' then
                    increment_counter(mem_pointer_tdata_out, TEST_LENGTH);
                end if;
            end if;
        end if;
    end process;
    
--check this 
    feed_axi_slave_with_tdata: process(S_AXIS_ACLK, S_AXIS_ARESETN, S_AXIS_TREADY, S_AXIS_TVALID)
    begin
        if rising_edge(S_AXIS_ACLK) then
            S_AXIS_TDATA    <= TDATA;
            data_sent(mem_pointer_tdata_in)  <= S_AXIS_TDATA;
        end if;
    end process;

    delay: process(S_AXIS_ACLK)
    begin
        if rising_edge(S_AXIS_ACLK) then
            S_FIFO_READ_EN_DELAY <= S_FIFO_READ_EN;
        end if;
    end process;

    save_received_data: process(S_AXIS_ACLK)
        variable cnt : integer;
    begin
        if rising_edge(S_AXIS_ACLK) then
            if S_FIFO_READ_EN_DELAY='1' then
                data_recivied(mem_pointer_tdata_out) <= S_FIFO_DATA_OUT;
            end if;
            if mem_pointer_tdata_out > 0 then
                assert data_recivied(mem_pointer_tdata_out-1) = data_sent(mem_pointer_tdata_out-1) report "damn" severity note;
            end if;
        end if;
    end process;

    rd_en_stim: process(S_AXIS_ACLK)
        variable cnt : integer;
    begin
        if rising_edge(S_AXIS_ACLK) then
            if S_AXIS_ARESETN = '0' then
                S_FIFO_READ_EN <= '0';
                cnt := 0;
            else
                cnt := cnt +1;
                if (cnt mod 12 < 1) or S_FIFO_ALMOST_EMPTY='1' then
                    S_FIFO_READ_EN <= '0';
                else
                    S_FIFO_READ_EN <= '1';
                end if;
            end if;
        end if;
    end process;

    tvalid_stim: process(S_AXIS_ACLK)
        variable cnt : integer;
    begin
        if rising_edge(S_AXIS_ACLK) then
            if S_AXIS_ARESETN = '0' then
                S_AXIS_TVALID <= '0';
                cnt := 0;
            else
                cnt := cnt +1;
                if cnt mod 15 < 1 then
                    S_AXIS_TVALID <= '0';
                else
                    S_AXIS_TVALID <= '1';
                end if;
            end if;
        end if;
    end process;

end sim;
