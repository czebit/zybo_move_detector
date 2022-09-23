----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.05.2022 19:37:27
-- Design Name: 
-- Module Name: frames_diff_tb - sim
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

entity frames_diff_tb is
    --  Port ( );
end frames_diff_tb;

architecture sim of frames_diff_tb is

    component frames_diff_v1_0 is
        generic (

            C_S00_AXIS_TDATA_WIDTH : integer := 8;
            C_S00_AXIS_FIFO_DEEP   : integer := 32;
            C_S01_AXIS_TDATA_WIDTH : integer := 8;
            C_S01_AXIS_FIFO_DEEP   : integer := 32;
            C_M00_AXIS_TDATA_WIDTH : integer := 8;
            C_M00_AXIS_FIFO_DEEP   : integer := 32
        );
        port (
            aclk             : in std_logic;
            aresetn          : in std_logic;
            s00_axis_tready  : out std_logic;
            s00_axis_tdata   : in std_logic_vector(C_S00_AXIS_TDATA_WIDTH-1 downto 0);
            s00_axis_tstrb   : in std_logic_vector((C_S00_AXIS_TDATA_WIDTH/8)-1 downto 0);
            s00_axis_tlast   : in std_logic;
            s00_axis_tvalid  : in std_logic;
            s01_axis_tready  : out std_logic;
            s01_axis_tdata   : in std_logic_vector(C_S01_AXIS_TDATA_WIDTH-1 downto 0);
            s01_axis_tstrb   : in std_logic_vector((C_S01_AXIS_TDATA_WIDTH/8)-1 downto 0);
            s01_axis_tlast   : in std_logic;
            s01_axis_tvalid  : in std_logic;
            m00_axis_tvalid  : out std_logic;
            m00_axis_tdata   : out std_logic_vector(C_M00_AXIS_TDATA_WIDTH-1 downto 0);
            m00_axis_tstrb   : out std_logic_vector((C_M00_AXIS_TDATA_WIDTH/8)-1 downto 0);
            m00_axis_tlast   : out std_logic;
            m00_axis_tready  : in std_logic
        );
    end component frames_diff_v1_0;
    constant C_S00_AXIS_TDATA_WIDTH : integer := 8;
    constant C_S01_AXIS_TDATA_WIDTH : integer := 8;
    constant C_M00_AXIS_TDATA_WIDTH : integer := 8;

    signal aclk             : std_logic;
    signal aresetn          : std_logic;
    signal s00_axis_tready  : std_logic;
    signal s00_axis_tdata   : std_logic_vector(C_S00_AXIS_TDATA_WIDTH-1 downto 0);
    signal s00_axis_tstrb   : std_logic_vector((C_S00_AXIS_TDATA_WIDTH/8)-1 downto 0);
    signal s00_axis_tlast   : std_logic;
    signal s00_axis_tvalid  : std_logic;
    signal s01_axis_tready  : std_logic;
    signal s01_axis_tdata   : std_logic_vector(C_S01_AXIS_TDATA_WIDTH-1 downto 0);
    signal s01_axis_tstrb   : std_logic_vector((C_S01_AXIS_TDATA_WIDTH/8)-1 downto 0);
    signal s01_axis_tlast   : std_logic;
    signal s01_axis_tvalid  : std_logic;
    signal m00_axis_tvalid  : std_logic;
    signal m00_axis_tdata   : std_logic_vector(C_M00_AXIS_TDATA_WIDTH-1 downto 0);
    signal m00_axis_tstrb   : std_logic_vector((C_M00_AXIS_TDATA_WIDTH/8)-1 downto 0);
    signal m00_axis_tlast   : std_logic;
    signal m00_axis_tready  : std_logic;

begin

    dut: frames_diff_v1_0
        port map(
            aclk                => aclk            ,
            aresetn             => aresetn         ,
            s00_axis_tready     => s00_axis_tready ,
            s00_axis_tdata      => s00_axis_tdata  ,
            s00_axis_tstrb      => s00_axis_tstrb  ,
            s00_axis_tlast      => s00_axis_tlast  ,
            s00_axis_tvalid     => s00_axis_tvalid ,
            s01_axis_tready     => s01_axis_tready ,
            s01_axis_tdata      => s01_axis_tdata  ,
            s01_axis_tstrb      => s01_axis_tstrb  ,
            s01_axis_tlast      => s01_axis_tlast  ,
            s01_axis_tvalid     => s01_axis_tvalid ,
            m00_axis_tvalid     => m00_axis_tvalid ,
            m00_axis_tdata      => m00_axis_tdata  ,
            m00_axis_tstrb      => m00_axis_tstrb  ,
            m00_axis_tlast      => m00_axis_tlast  ,
            m00_axis_tready     => m00_axis_tready
        );

    clk_stimulus: process
    begin
        aclk <= '1';
        wait for 5ns;
        aclk <= '0';
        wait for 5ns;
    end process;

    reset_stimulus: process
    begin
        aresetn <= '0';
        wait for 100ns;
        aresetn <= '1';
        wait;
    end process;

    tvalid_stim: process
    begin
        wait for 150ns;
        s00_axis_tvalid <= '1';
        s01_axis_tvalid <= '1';
        wait;
    end process;

    data_in_stim: process(aclk)
    begin
        if rising_edge(aclk) then
            if aresetn = '0' then
                s00_axis_tdata <= (others=>'0');
                s01_axis_tdata <= (others=>'0');
            else
                s00_axis_tdata <= std_logic_vector(unsigned(s00_axis_tdata) + 1);
                s01_axis_tdata <= std_logic_vector(unsigned(s01_axis_tdata) + 2);
                --                if (s00_axis_tdata = s01_axis_tdata) then
                --                    s00_axis_tdata <= std_logic_vector(unsigned(s00_axis_tdata) + 1);
                --                else
                --                    s01_axis_tdata <= std_logic_vector(unsigned(s01_axis_tdata) + 1);
                --                end if;
            end if;
        end if;
    end process;

    tlast_in_stim: process(aclk)
        variable cnt : integer;
    begin
        if rising_edge(aclk) then
            if aresetn = '0' then
                cnt := 0;
                s00_axis_tlast <= '0';
                s01_axis_tlast <= '0';
            else
                cnt := cnt +1;
                if ((cnt mod 10) = 0) then
                    s00_axis_tlast <= '1';
                    s01_axis_tlast <= '1';
                else
                    s00_axis_tlast <= '0';
                    s01_axis_tlast <= '0';
                end if;
            end if;
        end if;
    end process;

    tready_stim: process(aclk)
        variable cnt : integer;
    begin
        if rising_edge(aclk) then
            if aresetn = '0' then
                cnt := 0;
            else
                cnt := cnt +1;
                if ((cnt mod 15) < 8 ) then
                    m00_axis_tready <= '0';
                else
                    m00_axis_tready <= '1';
                end if;
            end if;
        end if;
    end process;

end sim;
