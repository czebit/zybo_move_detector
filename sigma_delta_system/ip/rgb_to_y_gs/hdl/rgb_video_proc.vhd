----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 23.02.2022 00:08:20
-- Design Name:
-- Module Name: rgb_video_proc - Behavioral
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

entity rgb_video_proc is
    port (
        rgb_Data_in    : in STD_LOGIC_VECTOR (23 downto 0);
        rgb_VDE_in     : in std_logic;
        rgb_HSync_in   : in std_logic;
        rgb_VSync_in   : in std_logic;

        Rst_n         : in std_logic;
        PixelClk    : in std_logic;

        y_Data_out   : out STD_LOGIC_VECTOR (7 downto 0);
        y_VDE_out    : out std_logic;
        y_HSync_out  : out std_logic;
        y_VSync_out  : out std_logic
    );
end rgb_video_proc;

architecture Behavioral of rgb_video_proc is

    subtype bw_pixel_t is unsigned(7 downto 0);
    subtype rgb_pixel_t is std_logic_vector(23 downto 0);

    signal rgb_pixel_i : rgb_pixel_t;
    signal bw_pixel : bw_pixel_t;

    signal hsync_i, vsync_i, de_i : std_logic;

begin

    input_registers: process(PixelClk)
    begin
        if rising_edge(PixelClk) then
            if (Rst_n = '0') then
                rgb_pixel_i <= (others=>'0');
                hsync_i <= '0';
                vsync_i <= '0';
                de_i <= '0';
            else
                rgb_pixel_i <= rgb_Data_in;
                hsync_i <= rgb_HSync_in;
                vsync_i <= rgb_VSync_in;
                de_i <= rgb_VDE_in;
            end if;
        end if;
    end process;

    to_grayscale: process(PixelClk)
        variable red_subpx, green_subpx, blue_subpx, sum : unsigned(15 downto 0);
    begin
        if rising_edge(PixelClk) then
            if (Rst_n = '0') then
                bw_pixel <= (others=>'0');
            else
                red_subpx    := "01001100" * unsigned(rgb_pixel_i(23 downto 16)); --(0.3 * R)
                green_subpx  := "10010111" * unsigned(rgb_pixel_i(7 downto 0));   --(0.59 * G)
                blue_subpx   := "00011100" * unsigned(rgb_pixel_i(15 downto 8));  --(0.11 * B)
                sum := red_subpx + green_subpx + blue_subpx;
                bw_pixel <= sum(15 downto 8) + ("0000000" & sum(7));
            end if;
        end if;
    end process;

    rgb_output: process(PixelClk)
    begin
        if rising_edge(PixelClk) then
            y_Data_out <= std_logic_vector(bw_pixel);
        end if;
    end process;

    pipeline: process(PixelClk)
    begin
        if rising_edge(PixelClk) then
            if (Rst_n = '0') then
                y_VDE_out <= '0';
                y_HSync_out <= '0';
                y_VSync_out <= '0';
            else
                y_VDE_out <= de_i;
                y_HSync_out <= hsync_i;
                y_VSync_out <= vsync_i;
            end if;
        end if;
    end process;

end Behavioral; 