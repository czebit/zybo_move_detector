library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sd_proc_element_tb is
    --  Port ( );
end sd_proc_element_tb;

architecture sim of sd_proc_element_tb is

    component sd_proc_element is
        Generic(
            C_DATA_WIDTH  : integer := 8
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

    constant C_DATA_WIDTH : integer := 8;

    signal CLK             : STD_LOGIC;
    signal RESETN          : STD_LOGIC;
    signal ENABLE          : STD_LOGIC;
    signal VALID           : STD_LOGIC;
    signal ENABLE_D        : STD_LOGIC;
    signal FRAME_IN        : STD_LOGIC_VECTOR (C_DATA_WIDTH-1 downto 0);
    signal VARIANCE_IN     : STD_LOGIC_VECTOR (C_DATA_WIDTH-1 downto 0);
    signal MEAN_IN         : STD_LOGIC_VECTOR (C_DATA_WIDTH-1 downto 0);
    signal MASK_OUT        : STD_LOGIC;
    signal MASK_OUT_VECTOR : STD_LOGIC_VECTOR (C_DATA_WIDTH-1 downto 0);
    signal MEAN_OUT        : STD_LOGIC_VECTOR (C_DATA_WIDTH-1 downto 0);
    signal VARIANCE_OUT    : STD_LOGIC_VECTOR (C_DATA_WIDTH-1 downto 0);
    signal SOF_IN  : STD_LOGIC;
    signal EOL_IN  : STD_LOGIC;
    signal SOF_OUT : STD_LOGIC;
    signal EOL_OUT : STD_LOGIC;

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

    dut: sd_proc_element
        port map(
            CLK            => CLK         ,
            RESETN         => RESETN      ,
            ENABLE         => ENABLE_D      ,
            VALID          => VALID       ,
            SOF_IN         => SOF_IN      ,
            EOL_IN         => EOL_IN      ,
            SOF_OUT        => SOF_OUT     ,
            EOL_OUT        => EOL_OUT     ,
            FRAME_IN       => FRAME_IN    ,
            VARIANCE_IN    => VARIANCE_IN ,
            MEAN_IN        => MEAN_IN     ,
            MASK_OUT       => MASK_OUT    ,
            MEAN_OUT       => MEAN_OUT    ,
            VARIANCE_OUT   => VARIANCE_OUT
        );

    clk_stimulus: process
    begin
        CLK <= '1';
        wait for 5ns;
        CLK <= '0';
        wait for 5ns;
    end process;

    reset_stimulus: process
    begin
        RESETN <= '0';
        wait for 100ns;
        RESETN <= '1';
        wait;
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
            if cnt mod 100 > 40 then
                ENABLE <= '1';
            else
                ENABLE <= '0';
            end if;
        end if;
    end process;

    ENABLE_delay: process(CLK)
    begin
        if rising_edge(CLK) then
            ENABLE_D <= ENABLE;
        end if;
    end process;

    read_frame: process(CLK)
    begin
        if rising_edge(CLK) then
            if RESETN = '0' then
                FRAME_IN    <= (others => '0');
                VARIANCE_IN <= (others => '0');
                MEAN_IN     <= (others => '0');
            else
                if ENABLE = '1' then
                    feed_dut_from_file(FRAME_IN, f_frame);
                    feed_dut_from_file(MEAN_IN, f_mean_in);
                    feed_dut_from_file(VARIANCE_IN, f_var_in);
                end if;
            end if;
        end if;
    end process;

    MASK_OUT_VECTOR <= (others=> '1') when '1' else (others=>'0');

    check_output: process (CLK)
    begin
        if rising_edge(CLK) then
            if VALID = '1' then
                compare_dut_with_file(MEAN_OUT, f_mean_out);
                compare_dut_with_file(VARIANCE_OUT, f_var_out);
                compare_dut_with_file(MASK_OUT_VECTOR, f_mask);
            end if;
        end if;
    end process;

end sim;
