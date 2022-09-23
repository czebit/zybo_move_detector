library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.ALL;

entity sd_proc_wrapper_tb_2 is
end sd_proc_wrapper_tb_2;

architecture Behavioral of sd_proc_wrapper_tb_2 is
    component sigma_delta_sd_proc_wrapper_0_0 is
        port (
            CLK : in STD_LOGIC;
            RESETN : in STD_LOGIC;
            FRAME_IN : in STD_LOGIC_VECTOR ( 7 downto 0 );
            FRAME_SOF : in STD_LOGIC;
            FRAME_EOL : in STD_LOGIC;
            FRAME_READY : out STD_LOGIC;
            FRAME_VALID : in STD_LOGIC;
            VM_IN_IN : in STD_LOGIC_VECTOR ( 15 downto 0 );
            VM_IN_READY : out STD_LOGIC;
            VM_IN_VALID : in STD_LOGIC;
            VM_IN_SOF : in STD_LOGIC;
            VM_IN_EOL : in STD_LOGIC;
            VM_OUT_OUT : out STD_LOGIC_VECTOR ( 15 downto 0 );
            VM_OUT_READY : in STD_LOGIC;
            VM_OUT_VALID : out STD_LOGIC;
            VM_OUT_SOF : out STD_LOGIC;
            VM_OUT_EOL : out STD_LOGIC;
            MASK_OUT : out STD_LOGIC_VECTOR ( 7 downto 0 );
            MASK_SOF : out STD_LOGIC;
            MASK_EOL : out STD_LOGIC;
            MASK_READY : in STD_LOGIC;
            MASK_VALID : out STD_LOGIC
        );
    end component sigma_delta_sd_proc_wrapper_0_0;

    component m_axis_int is
        generic (
            C_M_AXIS_FIFO_DEPTH  : integer := 16;
            C_M_AXIS_TDATA_WIDTH : integer := 16;
            C_M_AXIS_TUSER_WIDTH : integer := 1;
            C_M_AXIS_DEBUG       : boolean := FALSE
        );
        port (
            M_AXIS_ACLK : in STD_LOGIC;
            M_AXIS_ARESETN : in STD_LOGIC;
            M_AXIS_TVALID : out STD_LOGIC;
            M_AXIS_TDATA : out STD_LOGIC_VECTOR;
            M_AXIS_TUSER : out STD_LOGIC_VECTOR;
            M_AXIS_TLAST : out STD_LOGIC;
            M_AXIS_TREADY : in STD_LOGIC;
            M_FIFO_DATA_IN : in STD_LOGIC_VECTOR;
            M_FIFO_TUSER : in STD_LOGIC_VECTOR;
            M_FIFO_WRITE_EN : in STD_LOGIC;
            M_FIFO_TLAST : in STD_LOGIC;
            M_FIFO_NOT_ALMOST_FULL : out STD_LOGIC
        );
    end component m_axis_int;

    component s_axis_int is
        generic (
            C_S_AXIS_FIFO_DEPTH             : integer := 16;
            C_S_AXIS_TDATA_WIDTH            : integer := 32;
            C_S_AXIS_TUSER_WIDTH            : integer := 1;
            C_S_AXIS_FIFO_ALMOST_FULL_TH    : integer := 2;
            C_S_AXIS_FIFO_ALMOST_EMPTY_TH   : integer := 2;
            C_S_AXIS_DEBUG                  : boolean := FALSE
        );
        port (
            S_AXIS_ACLK : in STD_LOGIC;
            S_AXIS_ARESETN : in STD_LOGIC;
            S_AXIS_TREADY : out STD_LOGIC;
            S_AXIS_TDATA : in STD_LOGIC_VECTOR;
            S_AXIS_TUSER : in STD_LOGIC_VECTOR;
            S_AXIS_TLAST : in STD_LOGIC;
            S_AXIS_TVALID : in STD_LOGIC;
            S_FIFO_DATA_OUT : out STD_LOGIC_VECTOR;
            S_FIFO_READ_EN : in STD_LOGIC;
            S_FIFO_TLAST : out STD_LOGIC;
            S_FIFO_TUSER : out STD_LOGIC_VECTOR;
            S_FIFO_NOT_ALMOST_EMPTY : out STD_LOGIC;
            S_AXIS_TSTRB : in std_logic_vector
        );
    end component s_axis_int;

    component FIFO is
        generic (
            FIFO_DEPTH                  : integer := 2048;
            FIFO_WIDTH                  : integer := 2;
            FIFO_ALMOST_FULL_THRESHOLD  : integer := 2;
            FIFO_ALMOST_EMPTY_THRESHOLD : integer := 2;
            FIFO_DEBUG                  : boolean := FALSE
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

    signal clock_1 : STD_LOGIC;
    signal reset_n_1 : STD_LOGIC;

    signal s_axis_vm_S_FIFO_TUSER         : STD_LOGIC_VECTOR ( 0 to 0 );
    signal s_axis_vm_S_FIFO_DATA_OUT      : STD_LOGIC_VECTOR ( 15 downto 0 );
    signal s_axis_vm_S_FIFO_NOT_ALMOST_EMPTY : STD_LOGIC;
    signal s_axis_vm_S_FIFO_TLAST         : STD_LOGIC;
    signal s_axis_vm_S_AXIS_TLAST         : STD_LOGIC;
    signal s_axis_vm_S_AXIS_TREADY        : STD_LOGIC;
    signal s_axis_vm_S_AXIS_TUSER         : STD_LOGIC_VECTOR (0 downto 0);
    signal s_axis_vm_S_AXIS_TVALID        : STD_LOGIC;
    signal s_axis_vm_S_AXIS_TDATA         : STD_LOGIC_VECTOR ( 15 downto 0 );
    signal s_axis_vm_S_FIFO_READ_EN       : STD_LOGIC;

    signal s_axis_frame_S_FIFO_DATA_OUT : STD_LOGIC_VECTOR ( 7 downto 0 );
    signal s_axis_frame_S_FIFO_NOT_ALMOST_EMPTY : STD_LOGIC;
    signal s_axis_frame_S_AXIS_TDATA                : STD_LOGIC_VECTOR ( 7 downto 0 );
    signal s_axis_frame_S_AXIS_TLAST                : STD_LOGIC;
    signal s_axis_frame_S_AXIS_TREADY               : STD_LOGIC;
    signal s_axis_frame_S_AXIS_TUSER                : STD_LOGIC_VECTOR (0 downto 0);
    signal s_axis_frame_S_AXIS_TVALID               : STD_LOGIC;
    signal s_axis_frame_S_FIFO_READ_EN              : STD_LOGIC;
    signal s_axis_frame_S_FIFO_TLAST      : STD_LOGIC;
    signal s_axis_frame_S_FIFO_TUSER      : STD_LOGIC_VECTOR ( 0 to 0 );

    signal sd_proc_wrapper_FRAME_EOL   : STD_LOGIC;
    signal sd_proc_wrapper_FRAME_IN    : STD_LOGIC_VECTOR ( 7 downto 0 );
    signal sd_proc_wrapper_FRAME_READY : STD_LOGIC;
    signal sd_proc_wrapper_FRAME_SOF   : STD_LOGIC;
    signal sd_proc_wrapper_FRAME_VALID : STD_LOGIC;
    signal sd_proc_wrapper_MASK_EOL    : STD_LOGIC;
    signal sd_proc_wrapper_MASK_OUT    : STD_LOGIC_VECTOR ( 7 downto 0 );
    signal sd_proc_wrapper_MASK_READY  : STD_LOGIC;
    signal sd_proc_wrapper_MASK_SOF    : STD_LOGIC;
    signal sd_proc_wrapper_MASK_VALID  : STD_LOGIC;
    signal sd_proc_wrapper_VM_IN_EOL   : STD_LOGIC;
    signal sd_proc_wrapper_VM_IN_IN    : STD_LOGIC_VECTOR ( 15 downto 0 );
    signal sd_proc_wrapper_VM_IN_READY : STD_LOGIC;
    signal sd_proc_wrapper_VM_IN_SOF   : STD_LOGIC;
    signal sd_proc_wrapper_VM_IN_VALID : STD_LOGIC;
    signal sd_proc_wrapper_VM_OUT_EOL  : STD_LOGIC;
    signal sd_proc_wrapper_VM_OUT_OUT  : STD_LOGIC_VECTOR ( 15 downto 0 );
    signal sd_proc_wrapper_VM_OUT_READY : STD_LOGIC;
    signal sd_proc_wrapper_VM_OUT_SOF  : STD_LOGIC;
    signal sd_proc_wrapper_VM_OUT_VALID : STD_LOGIC;

    signal m_axis_vm_M_AXIS_TDATA : STD_LOGIC_VECTOR ( 15 downto 0 );
    signal m_axis_vm_M_AXIS_TLAST : STD_LOGIC;
    signal m_axis_vm_M_AXIS_TREADY : STD_LOGIC;
    signal m_axis_vm_M_AXIS_TUSER: STD_LOGIC_VECTOR ( 0 to 0 );
    signal m_axis_vm_M_AXIS_TVALID : STD_LOGIC;

    signal m_axis_mask_M_AXIS_TDATA : STD_LOGIC_VECTOR ( 7 downto 0 );
    signal m_axis_mask_M_AXIS_TLAST : STD_LOGIC;
    signal m_axis_mask_M_AXIS_TREADY : STD_LOGIC;
    signal m_axis_mask_M_AXIS_TUSER: STD_LOGIC_VECTOR ( 0 to 0 );
    signal m_axis_mask_M_AXIS_TVALID : STD_LOGIC;

    signal v_run, f_run : std_logic;
    signal v_read, m_read : std_logic;
    signal VARIANCE_IN  : STD_LOGIC_VECTOR ( 7 downto 0 );
    signal MEAN_IN  : STD_LOGIC_VECTOR ( 7 downto 0 );
    signal vm_in_valid_i, frame_valid_i : std_logic;
    signal MEAN_OUT        : STD_LOGIC_VECTOR (7 downto 0);
    signal VARIANCE_OUT    : STD_LOGIC_VECTOR (7 downto 0);
    signal MASK_OUT        : STD_LOGIC_VECTOR (7 downto 0);

    signal fifo_wr_en           : STD_LOGIC;
    signal fifo_in              : STD_LOGIC_VECTOR (1 downto 0);
    signal fifo_rd_en           : STD_LOGIC;
    signal fifo_out             : STD_LOGIC_VECTOR (1 downto 0);
    signal fifo_almost_full     : STD_LOGIC;
    signal fifo_almost_empty    : STD_LOGIC;
    signal sof_eol_vm_out       : STD_LOGIC_VECTOR (1 downto 0);
    signal cnt_vm, cnt_f        : integer := 0;

    file f_mean_out  : text open read_mode is "C:\Users\Czebity\Documents\MATLAB\mean_out.txt";
    file f_var_out   : text open read_mode is "C:\Users\Czebity\Documents\MATLAB\var_out.txt";
    file f_mean_in   : text open read_mode is "C:\Users\Czebity\Documents\MATLAB\mean_in.txt";
    file f_var_in    : text open read_mode is "C:\Users\Czebity\Documents\MATLAB\var_in.txt";
    file f_frame     : text open read_mode is "C:\Users\Czebity\Documents\MATLAB\frame.txt";
    file f_mask      : text open read_mode is "C:\Users\Czebity\Documents\MATLAB\mask.txt";

    procedure feed_dut_from_file(
        signal dut_input : out std_logic_vector;
        file vector_file : text) is
        variable rdline : line;
        variable temp   : std_logic_vector(7 downto 0);
    begin
        if not(endfile(vector_file)) then
            readline(vector_file, rdline);
            hex_read(rdline, temp);
            dut_input <= temp;
        end if;
    end procedure;

    procedure compare_dut_with_file(
        signal dut_output : in std_logic_vector;
        file vector_file : text) is
        variable rdline : line;
        variable ref   : std_logic_vector(7 downto 0);
        variable err_line: line;
    begin
        if not(endfile(vector_file)) then
            readline(vector_file, rdline);
            hex_read(rdline, ref);
            deallocate(err_line);
            write(err_line, string'("Vector: ") & to_hstring(ref) & string'("  DUT: ") & to_hstring(dut_output));
            assert (ref = dut_output) report err_line.all severity ERROR;
        end if;
    end procedure;

begin

    sof_eol_fifo : FIFO
        port map(
            FIFO_CLK          => clock_1,
            FIFO_RESET_N      => reset_n_1,
            FIFO_WRITE_EN     => fifo_wr_en,
            FIFO_DATA_IN      => fifo_in,
            FIFO_READ_EN      => fifo_rd_en,
            FIFO_DATA_OUT     => fifo_out,
            FIFO_ALMOST_FULL  => fifo_almost_full,
            FIFO_ALMOST_EMPTY => fifo_almost_empty,
            FIFO_FULL         => open,
            FIFO_EMPTY        => open
        );

    sd_proc_wrapper_0_0: sigma_delta_sd_proc_wrapper_0_0
        port map (
            CLK                   => clock_1,
            RESETN                => reset_n_1,
            FRAME_EOL             => sd_proc_wrapper_FRAME_EOL   ,
            FRAME_IN              => sd_proc_wrapper_FRAME_IN    ,
            FRAME_READY           => sd_proc_wrapper_FRAME_READY ,
            FRAME_SOF             => sd_proc_wrapper_FRAME_SOF   ,
            FRAME_VALID           => sd_proc_wrapper_FRAME_VALID ,
            MASK_EOL              => sd_proc_wrapper_MASK_EOL    ,
            MASK_OUT              => sd_proc_wrapper_MASK_OUT    ,
            MASK_READY            => sd_proc_wrapper_MASK_READY  ,
            MASK_SOF              => sd_proc_wrapper_MASK_SOF    ,
            MASK_VALID            => sd_proc_wrapper_MASK_VALID  ,
            VM_IN_EOL             => sd_proc_wrapper_VM_IN_EOL   ,
            VM_IN_IN              => sd_proc_wrapper_VM_IN_IN    ,
            VM_IN_READY           => sd_proc_wrapper_VM_IN_READY ,
            VM_IN_SOF             => sd_proc_wrapper_VM_IN_SOF   ,
            VM_IN_VALID           => sd_proc_wrapper_VM_IN_VALID ,
            VM_OUT_EOL            => sd_proc_wrapper_VM_OUT_EOL  ,
            VM_OUT_OUT            => sd_proc_wrapper_VM_OUT_OUT  ,
            VM_OUT_READY          => sd_proc_wrapper_VM_OUT_READY,
            VM_OUT_SOF            => sd_proc_wrapper_VM_OUT_SOF  ,
            VM_OUT_VALID          => sd_proc_wrapper_VM_OUT_VALID
        );

    sd_proc_wrapper_FRAME_EOL <= s_axis_frame_S_FIFO_TLAST;
    sd_proc_wrapper_FRAME_IN <= s_axis_frame_S_FIFO_DATA_OUT;
    sd_proc_wrapper_FRAME_SOF <= s_axis_frame_S_FIFO_TUSER(0);
    s_axis_frame_S_FIFO_READ_EN <= sd_proc_wrapper_FRAME_READY;
    sd_proc_wrapper_FRAME_VALID <= s_axis_frame_S_FIFO_NOT_ALMOST_EMPTY;
    sd_proc_wrapper_VM_IN_EOL <= s_axis_vm_S_FIFO_TLAST;
    sd_proc_wrapper_VM_IN_IN <= s_axis_vm_S_FIFO_DATA_OUT;
    sd_proc_wrapper_VM_IN_VALID <= s_axis_vm_S_FIFO_NOT_ALMOST_EMPTY;
    sd_proc_wrapper_VM_IN_SOF <= s_axis_vm_S_FIFO_TUSER(0);
    s_axis_vm_S_FIFO_READ_EN <= sd_proc_wrapper_VM_IN_READY;

    s_axis_int_frame: s_axis_int
        generic map (
            C_S_AXIS_TDATA_WIDTH => 8
        )
        port map (
            S_AXIS_ACLK               => clock_1,
            S_AXIS_ARESETN            => reset_n_1,
            S_AXIS_TSTRB => "0",
            S_AXIS_TDATA              => s_axis_frame_S_AXIS_TDATA           ,
            S_AXIS_TLAST              => s_axis_frame_S_AXIS_TLAST           ,
            S_AXIS_TREADY             => s_axis_frame_S_AXIS_TREADY          ,
            S_AXIS_TUSER              => s_axis_frame_S_AXIS_TUSER           ,
            S_AXIS_TVALID             => s_axis_frame_S_AXIS_TVALID          ,
            S_FIFO_DATA_OUT           => s_axis_frame_S_FIFO_DATA_OUT        ,
            S_FIFO_NOT_ALMOST_EMPTY   => s_axis_frame_S_FIFO_NOT_ALMOST_EMPTY,
            S_FIFO_READ_EN            => s_axis_frame_S_FIFO_READ_EN         ,
            S_FIFO_TLAST              => s_axis_frame_S_FIFO_TLAST           ,
            S_FIFO_TUSER              => s_axis_frame_S_FIFO_TUSER
        );

    s_axis_int_vm: s_axis_int
        generic map (
            C_S_AXIS_TDATA_WIDTH => 16
        )
        port map (
            S_AXIS_ACLK               => clock_1,
            S_AXIS_ARESETN            => reset_n_1,
            S_AXIS_TSTRB => "00",
            S_AXIS_TDATA              => s_axis_vm_S_AXIS_TDATA           ,
            S_AXIS_TLAST              => s_axis_vm_S_AXIS_TLAST           ,
            S_AXIS_TREADY             => s_axis_vm_S_AXIS_TREADY          ,
            S_AXIS_TUSER              => s_axis_vm_S_AXIS_TUSER           ,
            S_AXIS_TVALID             => s_axis_vm_S_AXIS_TVALID          ,
            S_FIFO_DATA_OUT           => s_axis_vm_S_FIFO_DATA_OUT        ,
            S_FIFO_NOT_ALMOST_EMPTY   => s_axis_vm_S_FIFO_NOT_ALMOST_EMPTY,
            S_FIFO_READ_EN            => s_axis_vm_S_FIFO_READ_EN         ,
            S_FIFO_TLAST              => s_axis_vm_S_FIFO_TLAST           ,
            S_FIFO_TUSER              => s_axis_vm_S_FIFO_TUSER
        );

    m_axis_int_vm: component m_axis_int
        generic map(
            C_M_AXIS_TDATA_WIDTH => 16
        )
        port map (
            M_AXIS_ACLK               => clock_1,
            M_AXIS_ARESETN            => reset_n_1,
            M_AXIS_TDATA              => m_axis_vm_M_AXIS_TDATA,
            M_AXIS_TLAST              => m_axis_vm_M_AXIS_TLAST,
            M_AXIS_TREADY             => m_axis_vm_M_AXIS_TREADY,
            M_AXIS_TUSER(0)           => m_axis_vm_M_AXIS_TUSER(0),
            M_AXIS_TVALID             => m_axis_vm_M_AXIS_TVALID,
            M_FIFO_NOT_ALMOST_FULL    => sd_proc_wrapper_VM_OUT_READY,
            M_FIFO_DATA_IN            => sd_proc_wrapper_VM_OUT_OUT,
            M_FIFO_TLAST              => sd_proc_wrapper_VM_OUT_EOL,
            M_FIFO_TUSER(0)           => sd_proc_wrapper_VM_OUT_SOF,
            M_FIFO_WRITE_EN           => sd_proc_wrapper_VM_OUT_VALID
        );

    m_axis_int_mask: component m_axis_int
        generic map(
            C_M_AXIS_TDATA_WIDTH => 8
        )
        port map (
            M_AXIS_ACLK                   => clock_1,
            M_AXIS_ARESETN                => reset_n_1,
            M_AXIS_TDATA                  => m_axis_mask_M_AXIS_TDATA,
            M_AXIS_TLAST                  => m_axis_mask_M_AXIS_TLAST,
            M_AXIS_TREADY                 => m_axis_mask_M_AXIS_TREADY,
            M_AXIS_TUSER(0)               => m_axis_mask_M_AXIS_TUSER(0),
            M_AXIS_TVALID                 => m_axis_mask_M_AXIS_TVALID,
            M_FIFO_NOT_ALMOST_FULL        => sd_proc_wrapper_MASK_READY,
            M_FIFO_DATA_IN                => sd_proc_wrapper_MASK_OUT,
            M_FIFO_TLAST                  => sd_proc_wrapper_MASK_EOL,
            M_FIFO_TUSER(0)               => sd_proc_wrapper_MASK_SOF,
            M_FIFO_WRITE_EN               => sd_proc_wrapper_MASK_VALID
        );

    fifo_rd_en <=  m_axis_vm_M_AXIS_TVALID and m_axis_vm_M_AXIS_TREADY;
    fifo_wr_en <= '1' when s_axis_vm_S_AXIS_TREADY='1' and s_axis_vm_S_AXIS_TVALID='1' else '0';
    fifo_in <= s_axis_vm_S_AXIS_TLAST & s_axis_vm_S_AXIS_TUSER(0);

    --    v_read <= sd_proc_wrapper_VM_OUT_VALID and sd_proc_wrapper_VM_OUT_READY;
    --    m_read <= sd_proc_wrapper_MASK_VALID and sd_proc_wrapper_MASK_READY;
    --    VARIANCE_OUT <= sd_proc_wrapper_VM_OUT_OUT(15 downto 8);
    --    MEAN_OUT <= sd_proc_wrapper_VM_OUT_OUT(7 downto 0);
    --    MASK_OUT <= sd_proc_wrapper_MASK_OUT;

    v_read <= m_axis_vm_M_AXIS_TVALID and m_axis_vm_M_AXIS_TREADY;
    m_read <= m_axis_mask_M_AXIS_TVALID and m_axis_mask_M_AXIS_TREADY;
    VARIANCE_OUT <= m_axis_vm_M_AXIS_TDATA(15 downto 8);
    MEAN_OUT <= m_axis_vm_M_AXIS_TDATA(7 downto 0);
    MASK_OUT <= m_axis_mask_M_AXIS_TDATA;
    s_axis_vm_S_AXIS_TDATA <= VARIANCE_IN & MEAN_IN;

    --    v_run <= s_axis_vm_S_AXIS_TVALID and s_axis_vm_S_AXIS_TREADY;
    --    f_run <= s_axis_frame_S_AXIS_TVALID and s_axis_frame_S_AXIS_TREADY;

    v_run <= vm_in_valid_i and s_axis_vm_S_AXIS_TREADY;
    f_run <= frame_valid_i and s_axis_frame_S_AXIS_TREADY;


    clk_stimulus: process
    begin
        clock_1 <= '1';
        wait for 5ns;
        clock_1 <= '0';
        wait for 5ns;
    end process;

    reset_stimulus: process
    begin
        reset_n_1 <= '0';
        wait for 100ns;
        reset_n_1 <= '1';
        wait;
    end process;

    in_tvalid: process(clock_1)
    begin
        if rising_edge(clock_1) then
            s_axis_vm_S_AXIS_TVALID <= vm_in_valid_i;
            s_axis_frame_S_AXIS_TVALID <= frame_valid_i;
        end if;
    end process;

    --    feed_mean_in: process(clock_1)
    --    variable rdline : line;
    --    variable temp   : std_logic_vector(7 downto 0);
    --    begin
    --        if rising_edge(clock_1) then
    --            if reset_n_1 = '0' then
    --                MEAN_IN <= (others => '0');
    --            else
    --                if v_run = '1' then
    --                    if not(endfile(f_mean_in)) then
    --                        readline(f_mean_in, rdline);
    --                        hex_read(rdline, temp);
    --                        MEAN_IN <= temp;
    --                    end if;
    --                else
    --                    MEAN_IN <= MEAN_IN;
    --                end if;
    --            end if;
    --        end if;
    --    end process;

    --    feed_var_in: process(clock_1)
    --    variable rdline : line;
    --    variable temp   : std_logic_vector(7 downto 0);
    --    begin
    --        if rising_edge(clock_1) then
    --            if reset_n_1 = '0' then
    --                VARIANCE_IN <= (others => '0');
    --            else
    --                if v_run = '1' then
    --                    if not(endfile(f_var_in)) then
    --                        readline(f_var_in, rdline);
    --                        hex_read(rdline, temp);
    --                        VARIANCE_IN <= temp;
    --                    end if;
    --                else
    --                    VARIANCE_IN <= VARIANCE_IN;
    --                end if;
    --            end if;
    --        end if;
    --    end process;

    --    feed_frame_in: process(clock_1)
    --    variable rdline : line;
    --    variable temp   : std_logic_vector(7 downto 0);
    --    begin
    --        if rising_edge(clock_1) then
    --            if reset_n_1 = '0' then
    --                s_axis_frame_S_AXIS_TDATA <= (others => '0');
    --            else
    --                if f_run = '1' then
    --                    if not(endfile(f_frame)) then
    --                        readline(f_frame, rdline);
    --                        hex_read(rdline, temp);
    --                        s_axis_frame_S_AXIS_TDATA <= temp;
    --                    end if;
    --                else
    --                    s_axis_frame_S_AXIS_TDATA <= s_axis_frame_S_AXIS_TDATA;
    --                end if;
    --            end if;
    --        end if;
    --    end process;

    read_frame: process(clock_1)
    begin
        if rising_edge(clock_1) then
            if reset_n_1 = '0' then
                s_axis_frame_S_AXIS_TDATA    <= (others => '0');
                VARIANCE_IN <= (others => '0');
                MEAN_IN     <= (others => '0');
            else
                if v_run = '1' then
                    feed_dut_from_file(MEAN_IN, f_mean_in);
                    feed_dut_from_file(VARIANCE_IN, f_var_in);
                end if;
                if f_run = '1' then
                    feed_dut_from_file(s_axis_frame_S_AXIS_TDATA, f_frame);
                end if;
            end if;
        end if;
    end process;

    process(clock_1)
    begin
        if rising_edge(clock_1) then
            sof_eol_vm_out <= m_axis_vm_M_AXIS_TLAST & m_axis_vm_M_AXIS_TUSER(0);
            assert (fifo_out = sof_eol_vm_out) report "eol sof not match" severity ERROR;
        end if;
    end process;



    in_valid_stimulus: process(clock_1)
        variable cnt : integer := 0;
    begin
        if rising_edge(clock_1) then
            if reset_n_1 = '0' then
                cnt := 0;
            else
                cnt := cnt + 1;
            end if;
            if cnt mod 47 > 15 then
                vm_in_valid_i <= '1';
            else
                vm_in_valid_i <= '0';
            end if;
            if cnt mod 55 > 19 then
                frame_valid_i <= '1';
            else
                frame_valid_i <= '0';
            end if;
        end if;
    end process;

    cnt_f_cnt_v: process(clock_1)
    begin
        if rising_edge(clock_1) then
            if reset_n_1 = '0' then
                cnt_vm <= 0;
                cnt_f  <= 0;
            else
                if s_axis_vm_S_AXIS_TREADY='1' and vm_in_valid_i='1' then
                    if cnt_vm = 25 then
                        cnt_vm <= 0;
                    else
                        cnt_vm <= cnt_vm + 1;
                    end if;
                else
                    cnt_vm <= cnt_vm;
                end if;
                if s_axis_frame_S_AXIS_TREADY='1' and frame_valid_i='1' then
                    if cnt_f = 25 then
                        cnt_f <= 0;
                    else
                        cnt_f <= cnt_f + 1;
                    end if;
                else
                    cnt_f <= cnt_f;
                end if;
            end if;
        end if;
    end process;

    sof_stimulus: process(clock_1)
    begin
        if rising_edge(clock_1) then
            if (cnt_vm = 0) then
                s_axis_vm_S_AXIS_TUSER(0) <= '1';
            else
                s_axis_vm_S_AXIS_TUSER(0) <= '0';
            end if;
            if (cnt_f = 0) then
                s_axis_frame_S_AXIS_TUSER(0) <= '1';
            else
                s_axis_frame_S_AXIS_TUSER(0) <= '0';
            end if;
        end if;
    end process;

    eol_stimulus: process(clock_1)
    begin
        if rising_edge(clock_1) then
            if cnt_vm = 10 then
                s_axis_vm_S_AXIS_TLAST <= '1';
            else
                s_axis_vm_S_AXIS_TLAST <= '0';
            end if;
            if cnt_f  = 10 then
                s_axis_frame_S_AXIS_TLAST <= '1';
            else
                s_axis_frame_S_AXIS_TLAST <= '0';
            end if;
        end if;
    end process;

    TREADY_stimulus: process(clock_1)
        variable cnt : integer := 0;
    begin
        if rising_edge(clock_1) then
            if reset_n_1 = '0' then
                cnt := 0;
            else
                cnt := cnt + 1;
            end if;
            if cnt mod 1000 > 990 then
                m_axis_mask_M_AXIS_TREADY <= '1';
            else
                m_axis_mask_M_AXIS_TREADY <= '0';
            end if;
            if cnt mod 90 > 20 then
                m_axis_vm_M_AXIS_TREADY <= '1';
            else
                m_axis_vm_M_AXIS_TREADY <= '0';
            end if;
        end if;
    end process;




    check_output: process (clock_1)
    begin
        if rising_edge(clock_1) then
            if v_read = '1'  then
                compare_dut_with_file(MEAN_OUT, f_mean_out);
                compare_dut_with_file(VARIANCE_OUT, f_var_out);
            end if;
            if m_read = '1' then
                compare_dut_with_file(MASK_OUT, f_mask);
            end if;
        end if;
    end process;
end Behavioral;