library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sd_proc_wrapper is
    Generic(
        C_DATA_WIDTH  : integer := 8;
        N             : integer := 2;
        T             : integer := 5
    );
    Port (
        CLK         : in STD_LOGIC;
        RESETN      : in STD_LOGIC;
        FRAME_IN    : in STD_LOGIC_VECTOR (C_DATA_WIDTH-1 downto 0);
        FRAME_SOF   : in STD_LOGIC;
        FRAME_EOL   : in STD_LOGIC;
        FRAME_READY : out STD_LOGIC;
        FRAME_VALID : in STD_LOGIC;

        VM_IN_IN     : in STD_LOGIC_VECTOR (2*C_DATA_WIDTH-1 downto 0);
        VM_IN_READY  : out STD_LOGIC;
        VM_IN_VALID  : in STD_LOGIC;
        VM_IN_SOF    : in STD_LOGIC;
        VM_IN_EOL    : in STD_LOGIC;

        VM_OUT_OUT     : out STD_LOGIC_VECTOR (2*C_DATA_WIDTH-1 downto 0);
        VM_OUT_READY   : in STD_LOGIC;
        VM_OUT_VALID   : out STD_LOGIC;
        VM_OUT_SOF     : out STD_LOGIC;
        VM_OUT_EOL     : out STD_LOGIC;

        MASK_OUT    : out STD_LOGIC_VECTOR (C_DATA_WIDTH-1 downto 0);
        MASK_SOF    : out STD_LOGIC;
        MASK_EOL    : out STD_LOGIC;
        MASK_READY  : in STD_LOGIC;
        MASK_VALID  : out STD_LOGIC
    );
end sd_proc_wrapper;

architecture Behavioral of sd_proc_wrapper is

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

    constant C_FIFO_DEPTH : integer := 32;
    constant C_FIFO_FRAME_WIDTH : integer := C_DATA_WIDTH + 2;
    constant C_FIFO_VM_WIDTH : integer := 2*C_DATA_WIDTH + 2;
    constant C_FIFO_DEBUG : boolean := FALSE;
    constant C_FIFO_ALMOST_FULL_THRESHOLD : integer := 2;
    constant C_FIFO_ALMOST_EMPTY_THRESHOLD : integer := 2;

    type state is (IDLE, SYNC, RUN);
    signal exec_state : state;

    signal mask_out_data_i  : STD_LOGIC;

    signal frame_in_synced : STD_LOGIC;
    signal frame_in_eol_i  : STD_LOGIC;
    signal frame_in_sof_i  : STD_LOGIC;

    signal vm_in_synced   : STD_LOGIC;
    signal vm_in_eol_i    : STD_LOGIC;
    signal vm_in_sof_i    : STD_LOGIC;

    signal frame_in_fifo_wr_en        : STD_LOGIC;
    signal frame_in_fifo_rd_en        : STD_LOGIC;
    signal frame_in_fifo_in           : std_logic_vector(C_FIFO_FRAME_WIDTH-1 downto 0);
    signal frame_in_fifo_out          : std_logic_vector(C_FIFO_FRAME_WIDTH-1 downto 0);
    signal frame_in_data_in_i         : std_logic_vector(C_DATA_WIDTH-1 downto 0);
    signal frame_in_fifo_almost_full  : STD_LOGIC;
    signal frame_in_fifo_almost_empty : STD_LOGIC;

    signal vm_in_fifo_wr_en        : STD_LOGIC;
    signal vm_in_fifo_rd_en        : STD_LOGIC;
    signal vm_in_fifo_in           : std_logic_vector(C_FIFO_VM_WIDTH-1 downto 0);
    signal vm_in_fifo_out          : std_logic_vector(C_FIFO_VM_WIDTH-1 downto 0);
    signal vm_in_data_in_i         : std_logic_vector(2*C_DATA_WIDTH-1 downto 0);
    signal vm_in_fifo_almost_full  : STD_LOGIC;
    signal vm_in_fifo_almost_empty : STD_LOGIC;

    signal vm_out_fifo_in            : std_logic_vector(C_FIFO_VM_WIDTH downto 0);
    signal vm_out_fifo_rd_en         : STD_LOGIC;
    signal vm_out_fifo_out           : std_logic_vector(C_FIFO_VM_WIDTH downto 0);
    signal vm_out_fifo_almost_full   : STD_LOGIC;
    signal vm_out_fifo_almost_empty  : STD_LOGIC;


    signal mean_in      : std_logic_vector(C_DATA_WIDTH-1 downto 0);
    signal variance_in  : std_logic_vector(C_DATA_WIDTH-1 downto 0);
    signal mean_out     : std_logic_vector(C_DATA_WIDTH-1 downto 0);
    signal variance_out : std_logic_vector(C_DATA_WIDTH-1 downto 0);
    signal proc_enable  : std_logic;
    signal proc_valid   : std_logic;

    signal out_eol_i  : std_logic;
    signal out_sof_i  : std_logic;
    signal out_valid : STD_LOGIC;

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

    component sd_proc_element is
        Generic(
            C_DATA_WIDTH  : integer := 8;
            N             : integer := 2;
            COMP_TH       : integer := 5
        );
        Port (
            CLK             : in STD_LOGIC;
            RESETN          : in STD_LOGIC;
            ENABLE          : in STD_LOGIC;
            VALID           : out STD_LOGIC;
            SOF_IN          : in STD_LOGIC;
            EOL_IN          : in STD_LOGIC;
            SOF_OUT         : out STD_LOGIC;
            EOL_OUT         : out STD_LOGIC;
            FRAME_IN        : in STD_LOGIC_VECTOR (C_DATA_WIDTH-1 downto 0);
            VARIANCE_IN     : in STD_LOGIC_VECTOR (C_DATA_WIDTH-1 downto 0);
            MEAN_IN         : in STD_LOGIC_VECTOR (C_DATA_WIDTH-1 downto 0);
            MASK_OUT        : out STD_LOGIC;
            MEAN_OUT        : out STD_LOGIC_VECTOR (C_DATA_WIDTH-1 downto 0);
            VARIANCE_OUT    : out STD_LOGIC_VECTOR (C_DATA_WIDTH-1 downto 0)
        );
    end component;

begin

    frame_fifo : FIFO
        generic map(
            FIFO_DEPTH                  => C_FIFO_DEPTH,
            FIFO_WIDTH                  => C_FIFO_FRAME_WIDTH,
            FIFO_ALMOST_FULL_THRESHOLD  => C_FIFO_ALMOST_FULL_THRESHOLD,
            FIFO_ALMOST_EMPTY_THRESHOLD => C_FIFO_ALMOST_EMPTY_THRESHOLD,
            FIFO_DEBUG                  => C_FIFO_DEBUG
        )
        port map(
            FIFO_CLK          => CLK,
            FIFO_RESET_N      => RESETN,
            FIFO_WRITE_EN     => frame_in_fifo_wr_en,
            FIFO_DATA_IN      => frame_in_fifo_in,
            FIFO_READ_EN      => frame_in_fifo_rd_en,
            FIFO_DATA_OUT     => frame_in_fifo_out,
            FIFO_ALMOST_FULL  => frame_in_fifo_almost_full,
            FIFO_ALMOST_EMPTY => frame_in_fifo_almost_empty,
            FIFO_FULL         => open,
            FIFO_EMPTY        => open
        );

    vm_in_fifo : FIFO
        generic map(
            FIFO_DEPTH                  => C_FIFO_DEPTH,
            FIFO_WIDTH                  => C_FIFO_VM_WIDTH,
            FIFO_ALMOST_FULL_THRESHOLD  => C_FIFO_ALMOST_FULL_THRESHOLD,
            FIFO_ALMOST_EMPTY_THRESHOLD => C_FIFO_ALMOST_EMPTY_THRESHOLD,
            FIFO_DEBUG                  => C_FIFO_DEBUG
        )
        port map(
            FIFO_CLK          => CLK,
            FIFO_RESET_N      => RESETN,
            FIFO_WRITE_EN     => vm_in_fifo_wr_en,
            FIFO_DATA_IN      => vm_in_fifo_in,
            FIFO_READ_EN      => vm_in_fifo_rd_en,
            FIFO_DATA_OUT     => vm_in_fifo_out,
            FIFO_ALMOST_FULL  => vm_in_fifo_almost_full,
            FIFO_ALMOST_EMPTY => vm_in_fifo_almost_empty,
            FIFO_EMPTY        => open,
            FIFO_FULL         => open
        );

    vm_mask_out_fifo : FIFO
        generic map(
            FIFO_DEPTH                  => C_FIFO_DEPTH,
            FIFO_WIDTH                  => C_FIFO_VM_WIDTH+1,
            FIFO_ALMOST_FULL_THRESHOLD  => C_FIFO_ALMOST_FULL_THRESHOLD,
            FIFO_ALMOST_EMPTY_THRESHOLD => C_FIFO_ALMOST_EMPTY_THRESHOLD,
            FIFO_DEBUG                  => C_FIFO_DEBUG
        )
        port map(
            FIFO_CLK          => CLK,
            FIFO_RESET_N      => RESETN,
            FIFO_WRITE_EN     => proc_valid,
            FIFO_DATA_IN      => vm_out_fifo_in,
            FIFO_READ_EN      => vm_out_fifo_rd_en,
            FIFO_DATA_OUT     => vm_out_fifo_out,
            FIFO_ALMOST_FULL  => vm_out_fifo_almost_full,
            FIFO_ALMOST_EMPTY => vm_out_fifo_almost_empty,
            FIFO_EMPTY        => open,
            FIFO_FULL         => open
        );

    sd_proc_element_inst : sd_proc_element
        generic map(
            C_DATA_WIDTH => C_DATA_WIDTH,
            N            => N,
            COMP_TH      => T
        )
        port map(
            CLK             => CLK,
            RESETN          => RESETN,
            ENABLE          => proc_enable,
            VALID           => proc_valid,
            SOF_IN          => frame_in_sof_i,
            EOL_IN          => frame_in_eol_i,
            SOF_OUT         => out_sof_i,
            EOL_OUT         => out_eol_i,
            FRAME_IN        => frame_in_data_in_i,
            VARIANCE_IN     => variance_in,
            MEAN_IN         => mean_in,
            MASK_OUT        => mask_out_data_i,
            MEAN_OUT        => mean_out,
            VARIANCE_OUT    => variance_out
        );


    frame_in_fifo_in <= FRAME_SOF & FRAME_EOL & FRAME_IN;
    vm_in_fifo_in <= VM_IN_SOF & VM_IN_EOL & VM_IN_IN;

    frame_in_data_in_i <= frame_in_fifo_out(C_DATA_WIDTH-1 downto 0);
    frame_in_eol_i     <= frame_in_fifo_out(C_DATA_WIDTH);
    frame_in_sof_i     <= frame_in_fifo_out(C_DATA_WIDTH+1);

    vm_in_data_in_i <= vm_in_fifo_out(2*C_DATA_WIDTH-1 downto 0);
    vm_in_eol_i     <= vm_in_fifo_out(2*C_DATA_WIDTH);
    vm_in_sof_i     <= vm_in_fifo_out(2*C_DATA_WIDTH+1);

    mean_in      <= vm_in_data_in_i(C_DATA_WIDTH-1 downto 0);
    variance_in  <= vm_in_data_in_i(2*C_DATA_WIDTH-1 downto C_DATA_WIDTH);

    FRAME_READY <= '1' when (FRAME_VALID='1' and frame_in_fifo_almost_full='0') else '0';
    VM_IN_READY <= '1' when (VM_IN_VALID='1' and vm_in_fifo_almost_full='0')    else '0';

    process(CLK)
    begin
        if rising_edge(CLK) then
            if FRAME_VALID='1' and frame_in_fifo_almost_full='0' then
                frame_in_fifo_wr_en <= '1';
            else
                frame_in_fifo_wr_en <= '0';
            end if;
            if VM_IN_VALID='1' and vm_in_fifo_almost_full='0' then

                vm_in_fifo_wr_en <= '1';
            else
                vm_in_fifo_wr_en <= '0';
            end if;
        end if;
    end process;

    state_machine_controll: process(CLK)
    begin
        if rising_edge(CLK) then
            if(RESETN = '0') then
                exec_state <= IDLE;
            else
                case exec_state is
                    when IDLE =>
                        if (frame_in_fifo_almost_empty = '0' or vm_in_fifo_almost_empty = '0') then
                            exec_state <= SYNC;
                        else
                            exec_state <= IDLE;
                        end if;
                    when SYNC =>
                        if (frame_in_synced = '1' and  vm_in_synced= '1') then
                            exec_state <= RUN;
                        else
                            exec_state <= SYNC;
                        end if;
                    when RUN =>
                        if (frame_in_eol_i /= vm_in_eol_i) then
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
                    frame_in_fifo_rd_en <= '0';
                    vm_in_fifo_rd_en    <= '0';
                    frame_in_synced     <= '0';
                    vm_in_synced        <= '0';
                    proc_enable         <= '0';
                when SYNC =>
                    proc_enable         <= '0';

                    synchronize_video_channel(frame_in_sof_i,
                                              frame_in_fifo_almost_empty,
                                              frame_in_synced,
                                              frame_in_fifo_rd_en);

                    synchronize_video_channel(vm_in_sof_i,
                                              vm_in_fifo_almost_empty,
                                              vm_in_synced,
                                              vm_in_fifo_rd_en);
                when RUN =>
                    frame_in_synced <= '0';
                    vm_in_synced    <= '0';
                    if (vm_out_fifo_almost_full='0') then
                        if (frame_in_fifo_almost_empty='0' and vm_in_fifo_almost_empty='0') then
                            frame_in_fifo_rd_en <= '1';
                            vm_in_fifo_rd_en    <= '1';
                            proc_enable <= '1';
                        else
                            frame_in_fifo_rd_en <= '0';
                            vm_in_fifo_rd_en    <= '0';
                            proc_enable <= '0';
                        end if;
                    else
                        frame_in_fifo_rd_en <= '0';
                        vm_in_fifo_rd_en    <= '0';
                        proc_enable         <= '0';
                    end if;
            end case;
        end if;
    end process;

    output_valid: process(CLK)
    begin
        if rising_edge(CLK) then
            if VM_OUT_READY = '1' and MASK_READY = '1' then
                if vm_out_fifo_almost_empty = '0' then
                    vm_out_fifo_rd_en <= '1';
                    out_valid <= '1';
                else
                    vm_out_fifo_rd_en <= '0';
                    out_valid <= '0';
                end if;
            else
                vm_out_fifo_rd_en <= '0';
                out_valid <= '0';
            end if;
        end if;
    end process;

    vm_out_fifo_in    <= mask_out_data_i & out_sof_i & out_eol_i & variance_out & mean_out;

    VM_OUT_OUT <= vm_out_fifo_out(C_FIFO_VM_WIDTH-3 downto 0);
    MASK_OUT <= (others=>'1') when vm_out_fifo_out(C_FIFO_VM_WIDTH) = '1' else (others=>'0');

    VM_OUT_EOL <= vm_out_fifo_out(C_FIFO_VM_WIDTH-2);
    MASK_EOL   <= vm_out_fifo_out(C_FIFO_VM_WIDTH-2);

    VM_OUT_SOF <= vm_out_fifo_out(C_FIFO_VM_WIDTH-1);
    MASK_SOF   <= vm_out_fifo_out(C_FIFO_VM_WIDTH-1);

    output_valid_d: process(CLK)
    begin
        if rising_edge(CLK) then
            MASK_VALID <= out_valid;
            VM_OUT_VALID <= out_valid;
        end if;
    end process;

end Behavioral;