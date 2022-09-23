library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FIFO is
    generic
(
        FIFO_DEPTH                  : integer := 32;
        FIFO_WIDTH                  : integer := 8;
        FIFO_ALMOST_FULL_THRESHOLD  : integer := 1;
        FIFO_ALMOST_EMPTY_THRESHOLD : integer := 1;
        FIFO_DEBUG                  : boolean := FALSE
    );
    Port (
        FIFO_CLK         : in STD_LOGIC;
        FIFO_RESET_N     : in STD_LOGIC;
        FIFO_WRITE_EN    : in STD_LOGIC;
        FIFO_DATA_IN     : in STD_LOGIC_VECTOR (FIFO_WIDTH-1 downto 0);
        FIFO_READ_EN     : in STD_LOGIC;
        FIFO_DATA_OUT    : out STD_LOGIC_VECTOR (FIFO_WIDTH-1 downto 0);
        FIFO_FULL        : out STD_LOGIC;
        FIFO_ALMOST_FULL : out STD_LOGIC;
        FIFO_EMPTY       : out STD_LOGIC;
        FIFO_ALMOST_EMPTY : out STD_LOGIC);
end FIFO;

architecture Behavioral of FIFO is

    signal fifo_wr_en, fifo_rd_en : std_logic;
    signal fifo_full_i, fifo_almost_full_i : std_logic;
    signal fifo_empty_i, fifo_almost_empty_i : std_logic;
    signal write_pointer, read_pointer : integer range 0 to FIFO_DEPTH-1;

    type FIFO_TYPE is array (0 to FIFO_DEPTH-1) of std_logic_vector(FIFO_WIDTH-1 downto 0);
    signal data_fifo : FIFO_TYPE;

    type boolean_str_attr is array(boolean) of string(0 to 4);                            
    constant c_boolean_str_attr : boolean_str_attr := (false => "false", true => "true ");
    attribute KEEP : string;
    attribute KEEP of write_pointer : signal is c_boolean_str_attr(FIFO_DEBUG);
    attribute KEEP of read_pointer  : signal is c_boolean_str_attr(FIFO_DEBUG);

begin

    fifo_rd_en          <= FIFO_READ_EN;
    fifo_wr_en          <= FIFO_WRITE_EN;
    FIFO_EMPTY          <= fifo_empty_i;
    FIFO_ALMOST_EMPTY   <= fifo_almost_empty_i;
    FIFO_ALMOST_FULL    <= fifo_almost_full_i;
    FIFO_FULL           <= fifo_full_i;

    fifo_controll_pointers: process(FIFO_CLK)
        variable fifo_counter : integer range 0 to FIFO_DEPTH-1;
    begin
        if (rising_edge (FIFO_CLK)) then
            if(FIFO_RESET_N = '0') then
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
                if (fifo_counter = FIFO_DEPTH - 1) then
                    fifo_empty_i <= '0';
                    fifo_almost_empty_i <= '0';
                    fifo_almost_full_i <= '1';
                    fifo_full_i <= '1';
                elsif (fifo_counter >= FIFO_DEPTH - 1 - FIFO_ALMOST_FULL_THRESHOLD) then
                    fifo_empty_i <= '0';
                    fifo_almost_empty_i <= '0';
                    fifo_almost_full_i <= '1';
                    fifo_full_i <= '0';
                elsif (fifo_counter = 0) then
                    fifo_empty_i <= '1';
                    fifo_almost_empty_i <= '1';
                    fifo_almost_full_i <= '0';
                    fifo_full_i <= '0';
                elsif (fifo_counter <= FIFO_ALMOST_EMPTY_THRESHOLD) then
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

    process(FIFO_CLK)
    begin
        if (rising_edge (FIFO_CLK)) then
            if (fifo_wr_en = '1') then
                data_fifo(write_pointer) <= FIFO_DATA_IN;
            end if;
            if (fifo_rd_en = '1') then
                FIFO_DATA_OUT <= data_fifo(read_pointer);
            end if;
        end  if;
    end process;

    debug_logic: if FIFO_DEBUG = TRUE generate
        type FIFO_11BIT_T is array (0 to FIFO_DEPTH-1) of integer range 0 to 2047;
        signal transaction_counter_in, transaction_counter_out : integer range 0 to 2047;
        signal transaction_counter_fifo : FIFO_11BIT_T;
        attribute KEEP of transaction_counter_in: signal is "TRUE";
        attribute KEEP of transaction_counter_out: signal is "TRUE";
    begin
        increment_counter_debug: process(FIFO_CLK)
        begin
            if rising_edge(FIFO_CLK) then
                if FIFO_RESET_N = '0' then
                    transaction_counter_in <= 0;
                else
                    if FIFO_DATA_IN(FIFO_WIDTH-2) = '1' then
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

        process(FIFO_CLK)
        begin
            if (rising_edge (FIFO_CLK)) then
                if (fifo_wr_en = '1') then
                    transaction_counter_fifo(write_pointer) <= transaction_counter_in;
                end if;
                if (fifo_rd_en = '1') then
                    transaction_counter_out <= transaction_counter_fifo(read_pointer);
                end if;
            end if;
        end process;
    end generate debug_logic;

end Behavioral;
