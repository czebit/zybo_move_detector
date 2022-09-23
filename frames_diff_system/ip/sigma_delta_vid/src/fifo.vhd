----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.05.2022 14:41:37
-- Design Name: 
-- Module Name: fifo - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

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
    constant FIFO_DEPTH_LOG2 : natural := clog2(FIFO_DEPTH);
    signal fifo_wr_en, fifo_rd_en : std_logic;
    signal fifo_full_i, fifo_almost_full_i : std_logic;
    signal fifo_empty_i, fifo_almost_empty_i : std_logic;
    --signal write_pointer, read_pointer : integer range 0 to FIFO_DEPTH-1;
    signal write_pointer, read_pointer : unsigned(FIFO_DEPTH_LOG2-1 downto 0);

    type FIFO_TYPE is array (0 to FIFO_DEPTH-1) of std_logic_vector(FIFO_WIDTH-1 downto 0);
    signal data_fifo : FIFO_TYPE;

    type boolean_str_attr is array(boolean) of string(1 to 5);                            
    constant c_boolean_str_attr : boolean_str_attr := (false => "false", true => "true ");
    attribute KEEP : string;
    attribute KEEP of write_pointer : signal is c_boolean_str_attr(FIFO_DEBUG);
    attribute KEEP of read_pointer  : signal is c_boolean_str_attr(FIFO_DEBUG);

begin

    fifo_rd_en          <= '1' when FIFO_READ_EN = '1'          else '0';
    fifo_wr_en          <= '1' when FIFO_WRITE_EN = '1'         else '0';
    FIFO_EMPTY          <= '1' when fifo_empty_i = '1'          else '0'; 
    FIFO_ALMOST_EMPTY   <= '1' when fifo_almost_empty_i = '1'   else '0'; 
    FIFO_ALMOST_FULL    <= '1' when fifo_almost_full_i = '1'    else '0'; 
    FIFO_FULL           <= '1' when fifo_full_i = '1'           else '0'; 

    fifo_controll_pointers: process(FIFO_CLK)
        variable fifo_counter : integer range 0 to FIFO_DEPTH-1;
    begin
        if (rising_edge (FIFO_CLK)) then
            if(FIFO_RESET_N = '0') then
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
                data_fifo(to_integer(write_pointer)) <= FIFO_DATA_IN;
            end if;
            if (fifo_rd_en = '1') then
                FIFO_DATA_OUT <= data_fifo(to_integer(read_pointer));
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
                    transaction_counter_fifo(to_integer(write_pointer)) <= transaction_counter_in;
                end if;
                if (fifo_rd_en = '1') then
                    transaction_counter_out <= transaction_counter_fifo(to_integer(read_pointer));
                end if;
            end if;
        end process;
    end generate debug_logic;

end Behavioral;
