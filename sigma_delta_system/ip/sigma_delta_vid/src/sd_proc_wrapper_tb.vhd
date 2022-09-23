library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.ALL;

entity sd_proc_wrapper_tb is
end sd_proc_wrapper_tb;

architecture sim of sd_proc_wrapper_tb is
    component sd_proc_wrapper is
        Generic(
            C_DATA_WIDTH  : integer := 8
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
    end component;

    constant C_DATA_WIDTH : integer := 8;

    signal CLK             : STD_LOGIC;
    signal RESETN          : STD_LOGIC;

    signal FRAME_IN    : STD_LOGIC_VECTOR (C_DATA_WIDTH-1 downto 0);
    signal FRAME_SOF   : STD_LOGIC;
    signal FRAME_EOL   : STD_LOGIC;
    signal FRAME_READY : STD_LOGIC;
    signal FRAME_VALID : STD_LOGIC;

    signal VM_IN_IN     : STD_LOGIC_VECTOR (2*C_DATA_WIDTH-1 downto 0);
    signal VM_IN_READY  : STD_LOGIC;
    signal VM_IN_VALID  : STD_LOGIC;
    signal VM_IN_SOF    : STD_LOGIC;
    signal VM_IN_EOL    : STD_LOGIC;

    signal VM_OUT_OUT     :  STD_LOGIC_VECTOR (2*C_DATA_WIDTH-1 downto 0);
    signal VM_OUT_READY   :  STD_LOGIC;
    signal VM_OUT_VALID   :  STD_LOGIC;
    signal VM_OUT_SOF     :  STD_LOGIC;
    signal VM_OUT_EOL     :  STD_LOGIC;

    signal MASK_OUT    :  STD_LOGIC_VECTOR (C_DATA_WIDTH-1 downto 0);
    signal MASK_SOF    :  STD_LOGIC;
    signal MASK_EOL    :  STD_LOGIC;
    signal MASK_READY  :  STD_LOGIC;
    signal MASK_VALID  :  STD_LOGIC;

    signal VARIANCE_IN     : STD_LOGIC_VECTOR (C_DATA_WIDTH-1 downto 0);
    signal MEAN_IN         : STD_LOGIC_VECTOR (C_DATA_WIDTH-1 downto 0);
    signal MEAN_OUT        : STD_LOGIC_VECTOR (C_DATA_WIDTH-1 downto 0);
    signal VARIANCE_OUT    : STD_LOGIC_VECTOR (C_DATA_WIDTH-1 downto 0);

    signal v_run, f_run : std_logic;
    signal v_read, m_read : std_logic;

    signal vm_in_valid_i, frame_valid_i : std_logic;

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
        variable temp   : std_logic_vector(C_DATA_WIDTH-1 downto 0);
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
        variable ref   : std_logic_vector(C_DATA_WIDTH-1 downto 0);
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

    VM_IN_IN <= VARIANCE_IN & MEAN_IN;
    VARIANCE_OUT <= VM_OUT_OUT(2*C_DATA_WIDTH-1 downto C_DATA_WIDTH);
    MEAN_OUT <= VM_OUT_OUT(C_DATA_WIDTH-1 downto 0);

    dut: sd_proc_wrapper
        port map(
            CLK         => CLK         ,
            RESETN      => RESETN      ,
            FRAME_IN    => FRAME_IN    ,
            FRAME_SOF   => FRAME_SOF   ,
            FRAME_EOL   => FRAME_EOL   ,
            FRAME_READY => FRAME_READY ,
            FRAME_VALID => FRAME_VALID ,
            VM_IN_IN    => VM_IN_IN    ,
            VM_IN_READY => VM_IN_READY ,
            VM_IN_VALID => VM_IN_VALID ,
            VM_IN_SOF   => VM_IN_SOF   ,
            VM_IN_EOL   => VM_IN_EOL   ,
            VM_OUT_OUT  => VM_OUT_OUT  ,
            VM_OUT_READY=> VM_OUT_READY,
            VM_OUT_VALID=> VM_OUT_VALID,
            VM_OUT_SOF  => VM_OUT_SOF  ,
            VM_OUT_EOL  => VM_OUT_EOL  ,
            MASK_OUT    => MASK_OUT    ,
            MASK_SOF    => MASK_SOF    ,
            MASK_EOL    => MASK_EOL    ,
            MASK_READY  => MASK_READY  ,
            MASK_VALID  => MASK_VALID
        );

    clk_stimulus: process
    begin
        CLK <= '1';
        wait for 5ns;
        CLK <= '0';
        wait for 5ns;
    end process;

    MASK_READY_stimulus: process(CLK)
        variable cnt : integer := 0;
    begin
        if rising_edge(CLK) then
            if RESETN = '0' then
                cnt := 0;
            else
                cnt := cnt + 1;
            end if;
            if cnt mod 100 > 25 then
                MASK_READY <= '1';
            else
                MASK_READY <= '0';
            end if;
            if cnt mod 90 > 20 then
                VM_OUT_READY <= '1';
            else
                VM_OUT_READY <= '0';
            end if;
        end if;
    end process;

    in_valid_stimulus: process(CLK)
        variable cnt : integer := 0;
    begin
        if rising_edge(CLK) then
            if RESETN = '0' then
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

    reset_stimulus: process
    begin
        RESETN <= '0';
        wait for 100ns;
        RESETN <= '1';
        wait;
    end process;

    sof_eol_proc: process(CLK)
        variable cnt_vm, cnt_f : integer := 0;
    begin
        if rising_edge(CLK) then
            if RESETN = '0' then
                cnt_vm := 0;
                cnt_f  := 0;
            else

                --if VM_IN_READY='1' and vm_in_valid_i='1' then
                if v_run then
                    if cnt_vm = 100 then
                        cnt_vm := 0;
                    else
                        cnt_vm := cnt_vm + 1;
                    end if;
                else
                    cnt_vm := cnt_vm;
                end if;

                --if FRAME_READY='1' and frame_valid_i='1' then
                if f_run then
                    if cnt_f = 100 then
                        cnt_f := 0;
                    else
                        cnt_f := cnt_f + 1;
                    end if;
                else
                    cnt_f := cnt_f;
                end if;

            end if;

            if ((cnt_vm mod 10) = 9) then
                VM_IN_EOL <= '1';
            else
                VM_IN_EOL <= '0';
            end if;

            if ((cnt_f mod 10) = 9) then
                FRAME_EOL <= '1';
            else
                FRAME_EOL <= '0';
            end if;

            if (cnt_vm = 1) then
                VM_IN_SOF <= '1';
            else
                VM_IN_SOF <= '0';
            end if;

            if (cnt_f = 1) then
                FRAME_SOF <= '1';
            else
                FRAME_SOF <= '0';
            end if;

        end if;
    end process;

    valid: process(CLK)
    begin
        if rising_edge(CLK) then
            VM_IN_VALID <= vm_in_valid_i;
            FRAME_VALID <= frame_valid_i;
        end if;
    end process;

    v_run <= VM_IN_VALID and VM_IN_READY;
    f_run <= FRAME_VALID and FRAME_READY;

    read_frame: process(CLK)
    begin
        if rising_edge(CLK) then
            if RESETN = '0' then
                FRAME_IN    <= (others => '0');
                VARIANCE_IN <= (others => '0');
                MEAN_IN     <= (others => '0');
            else
                if v_run = '1' then
                    feed_dut_from_file(MEAN_IN, f_mean_in);
                    feed_dut_from_file(VARIANCE_IN, f_var_in);
                end if;
                if f_run = '1' then
                    feed_dut_from_file(FRAME_IN, f_frame);
                end if;
            end if;
        end if;
    end process;

    v_read <= VM_OUT_VALID and VM_OUT_READY;
    m_read <= MASK_VALID and MASK_READY;

    check_output: process (CLK)
    begin
        if rising_edge(CLK) then
            if v_read = '1'  then
                compare_dut_with_file(MEAN_OUT, f_mean_out);
                compare_dut_with_file(VARIANCE_OUT, f_var_out);
            end if;
            if m_read = '1' then
                compare_dut_with_file(MASK_OUT, f_mask);
            end if;
        end if;
    end process;
    
    check_sof_eol: process (CLK)
    variable cnt_m, cnt_v : integer := 0;
    variable eol_step : integer := 0;
    begin
        if rising_edge(CLK) then
            if v_read = '1'  then
                if VM_OUT_EOL='1' then
                    if eol_step = 0 then
                        eol_step := cnt_v;
                    else
                        assert (eol_step = cnt_v-1) report string'("eol fail") & to_string(eol_step) & to_string(cnt_v) severity ERROR;
                    end if;
                    cnt_v := 0;
                else
                    cnt_v := cnt_v + 1;
                end if;
            end if;
--            if m_read = '1' then
--                cnt_m := cnt_m + 1;
--            end if;
        end if;
    end process;
end sim;
