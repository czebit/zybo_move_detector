library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sd_proc_element is
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
end sd_proc_element;

architecture Behavioral of sd_proc_element is

    signal frame_i, frame_ii  : integer range 0 to (2**C_DATA_WIDTH)-1;
    signal mean_i,  mean_ii, mean_out_i : integer range 0 to (2**C_DATA_WIDTH)-1;
    signal var_i,   var_ii,  var_out_i  : integer range 0 to (2**C_DATA_WIDTH)-1;
    signal delta : integer range 0 to (2**C_DATA_WIDTH)-1;

    signal enable_i, enable_ii, enable_iii : STD_LOGIC;
    signal en1, en2, en3 : STD_LOGIC;
    signal sof_i, sof_ii, sof_out_i : STD_LOGIC;
    signal eol_i, eol_ii, eol_out_i : STD_LOGIC;

    pure function signum(value : integer) return integer is
    begin
        if value > 0 then
            return 1;
        elsif value = 0 then
            return 0;
        else
            return -1;
        end if;
    end function;

    type state is (START, RUN);
    signal exec_state : state;
    
begin

    state_machine_controll: process(CLK)
    begin
        if rising_edge(CLK) then
            if RESETN = '0' then
                exec_state <= START;
            else
                case exec_state is
                    when START =>
                        if (ENABLE='1' and enable_i='1' and enable_ii='1') then
                            exec_state <= RUN;
                        else
                            exec_state <= START;
                        end if;
                    when RUN =>
                        exec_state <= RUN;
                end case;
            end if;
        end if;
    end process;
    
    controll: process(ENABLE, enable_i, enable_ii,enable_iii)
    begin
            case exec_state is
                when START =>
                    en1 <= enable_i;
                    en2 <= enable_ii;
                    en3 <= enable_iii;
                when RUN =>
                    en1 <= ENABLE;
                    en2 <= ENABLE;
                    en3 <= ENABLE;
            end case;
    end process;
    
    run_register: process(CLK)
    begin
        if rising_edge(CLK) then
            enable_i <= ENABLE;
            enable_ii <= enable_i;
            enable_iii <= enable_ii;
        end if;
    end process;

    --step 1
    input_registers: process(CLK)
    begin
        if rising_edge(CLK) then
        if ENABLE = '1' then
            mean_i  <= to_integer(unsigned(MEAN_IN));
            frame_i <= to_integer(unsigned(FRAME_IN));
            var_i   <= to_integer(unsigned(VARIANCE_IN));
            sof_i   <= SOF_IN;
            eol_i   <= EOL_IN;
            end if;
        end if;
    end process;

    --step 2
    mean_calc: process(CLK)
        variable sign : integer range -1 to 1;
    begin
        if rising_edge(CLK) then
            if en1 = '1' then

                frame_ii <= frame_i;
                var_ii   <= var_i;
                sof_ii   <= sof_i;
                eol_ii   <= eol_i;

                sign := signum(frame_i - mean_i);

                if mean_i = 0 and sign = -1 then
                    mean_ii <= 0;
                elsif mean_i = 255 and sign = 1 then
                    mean_ii <= 255;
                else
                    mean_ii <= mean_i + sign;
                end if;

            end if;
        end if;
    end process;

    --step 3
    sigma_delta: process(CLK)
        variable delta_mul : integer range -(2**C_DATA_WIDTH*N-1) to 2**C_DATA_WIDTH*N-1;
        variable sign : integer range -1 to 1;
    begin
        if rising_edge(CLK) then
            if en2 = '1' then

                mean_out_i <= mean_ii;
                sof_out_i  <= sof_ii;
                eol_out_i  <= eol_ii;

                delta <= abs(mean_ii - frame_ii);
                delta_mul := N*abs(mean_ii - frame_ii);

                sign := signum(delta_mul-var_ii);

                if abs(mean_ii - frame_ii) = 0 then
                    var_out_i <= var_ii;
                else
                    if var_ii = 0 and sign = -1 then
                        var_out_i <= 0;
                    elsif var_ii = 255 and sign = 1 then
                        var_out_i <= 255;
                    else
                        var_out_i <= var_ii + sign;
                    end if;
                end if;

            end if;
        end if;
    end process;

    --step 4
    output_pipeline: process(CLK)
    begin
        if rising_edge(CLK) then
            if en3 = '1' then
                if delta >= (var_out_i+COMP_TH) then
                    MASK_OUT <= '1';
                else
                    MASK_OUT <= '0';
                end if;
                VARIANCE_OUT <= std_logic_vector(to_unsigned(var_out_i, 8));
                MEAN_OUT     <= std_logic_vector(to_unsigned(mean_out_i, 8));
                SOF_OUT      <= sof_out_i;
                EOL_OUT      <= eol_out_i;
            end if;
        end if;
    end process;

    valid_proc: process(CLK)
    begin
        if rising_edge(CLK) then
            VALID <= en3;
        end if;
    end process;
end Behavioral;
