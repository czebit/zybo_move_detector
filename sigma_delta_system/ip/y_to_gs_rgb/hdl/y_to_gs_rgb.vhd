library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity y_to_gs_rgb is
    Port (
        y_data_in   : in STD_LOGIC_VECTOR (7 downto 0);
        y_hsync_in  : in STD_LOGIC;
        y_vsync_in  : in STD_LOGIC;
        y_vde_in    : in STD_LOGIC;

        y_data_out  : out STD_LOGIC_VECTOR (23 downto 0);
        y_hsync_out : out STD_LOGIC;
        y_vsync_out : out STD_LOGIC;
        y_vde_out   : out STD_LOGIC;

        pixel_clk : in STD_LOGIC;
        reset_n : in STD_LOGIC
    );
end y_to_gs_rgb;

architecture Behavioral of y_to_gs_rgb is

    signal bw_pixel : std_logic_vector(7 downto 0);
    signal hsync_i, vsync_i, de_i : std_logic;

begin

    input_reg: process(pixel_clk)
    begin
        if rising_edge(pixel_clk) then
            if reset_n = '0' then
                hsync_i  <= '0';
                vsync_i  <= '0';
                de_i     <= '0';
                bw_pixel <= (others=>'0');
            else
                hsync_i  <= y_hsync_in;
                vsync_i  <= y_vsync_in;
                de_i     <= y_vde_in;
                bw_pixel <= y_data_in;
            end if;
        end if;
    end process;

    output_reg: process(pixel_clk)
    begin
        if rising_edge(pixel_clk) then
        y_data_out  <= bw_pixel & bw_pixel & bw_pixel;
        y_hsync_out <= hsync_i;
        y_vsync_out <= vsync_i;
        y_vde_out   <= de_i;
        end if;
    end process;

end Behavioral;
