--Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2021.2 (win64) Build 3367213 Tue Oct 19 02:48:09 MDT 2021
--Date        : Sun Jul 31 23:43:50 2022
--Host        : DESKTOP-GPI6FBP running 64-bit major release  (build 9200)
--Command     : generate_target sigma_delta.bd
--Design      : sigma_delta
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity sigma_delta is
  generic(
    N : INTEGER := 2;
    T : INTEGER := 5
    );
  port (
    M_AXIS_MASK_tdata : out STD_LOGIC_VECTOR ( 7 downto 0 );
    M_AXIS_MASK_tlast : out STD_LOGIC;
    M_AXIS_MASK_tready : in STD_LOGIC;
    M_AXIS_MASK_tuser : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXIS_MASK_tvalid : out STD_LOGIC;
    M_AXIS_VM_tdata : out STD_LOGIC_VECTOR ( 15 downto 0 );
    M_AXIS_VM_tlast : out STD_LOGIC;
    M_AXIS_VM_tready : in STD_LOGIC;
    M_AXIS_VM_tuser : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXIS_VM_tvalid : out STD_LOGIC;
    S_AXIS_FRAME_tdata : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S_AXIS_FRAME_tlast : in STD_LOGIC;
    S_AXIS_FRAME_tready : out STD_LOGIC;
    S_AXIS_FRAME_tuser : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXIS_FRAME_tvalid : in STD_LOGIC;
    S_AXIS_VM_tdata : in STD_LOGIC_VECTOR ( 15 downto 0 );
    S_AXIS_VM_tlast : in STD_LOGIC;
    S_AXIS_VM_tready : out STD_LOGIC;
    S_AXIS_VM_tuser : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXIS_VM_tvalid : in STD_LOGIC;
    clk : in STD_LOGIC;
    m_axis_mask_aclk : in STD_LOGIC;
    m_axis_mask_arstn : in STD_LOGIC;
    m_axis_vm_aclk : in STD_LOGIC;
    m_axis_vm_arstn : in STD_LOGIC;
    reset_n : in STD_LOGIC;
    s_axis_frame_aclk : in STD_LOGIC;
    s_axis_frame_arstn : in STD_LOGIC;
    s_axis_vm_aclk : in STD_LOGIC;
    s_axis_vm_arstn : in STD_LOGIC
  );
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of sigma_delta : entity is "sigma_delta,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=sigma_delta,x_ipVersion=1.00.a,x_ipLanguage=VHDL,numBlks=9,numReposBlks=9,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=1,numPkgbdBlks=0,bdsource=USER,da_clkrst_cnt=5,synth_mode=OOC_per_IP}";
  attribute HW_HANDOFF : string;
  attribute HW_HANDOFF of sigma_delta : entity is "sigma_delta.hwdef";
end sigma_delta;

architecture STRUCTURE of sigma_delta is
  component sigma_delta_axis_clock_converter_0_0 is
  port (
    s_axis_aresetn : in STD_LOGIC;
    m_axis_aresetn : in STD_LOGIC;
    s_axis_aclk : in STD_LOGIC;
    s_axis_tvalid : in STD_LOGIC;
    s_axis_tready : out STD_LOGIC;
    s_axis_tdata : in STD_LOGIC_VECTOR ( 15 downto 0 );
    s_axis_tlast : in STD_LOGIC;
    s_axis_tuser : in STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_aclk : in STD_LOGIC;
    m_axis_tvalid : out STD_LOGIC;
    m_axis_tready : in STD_LOGIC;
    m_axis_tdata : out STD_LOGIC_VECTOR ( 15 downto 0 );
    m_axis_tlast : out STD_LOGIC;
    m_axis_tuser : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component sigma_delta_axis_clock_converter_0_0;
  component sigma_delta_axis_clock_converter_1_0 is
  port (
    s_axis_aresetn : in STD_LOGIC;
    m_axis_aresetn : in STD_LOGIC;
    s_axis_aclk : in STD_LOGIC;
    s_axis_tvalid : in STD_LOGIC;
    s_axis_tready : out STD_LOGIC;
    s_axis_tdata : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axis_tlast : in STD_LOGIC;
    s_axis_tuser : in STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_aclk : in STD_LOGIC;
    m_axis_tvalid : out STD_LOGIC;
    m_axis_tready : in STD_LOGIC;
    m_axis_tdata : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m_axis_tlast : out STD_LOGIC;
    m_axis_tuser : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component sigma_delta_axis_clock_converter_1_0;
  component sigma_delta_axis_clock_converter_2_0 is
  port (
    s_axis_aresetn : in STD_LOGIC;
    m_axis_aresetn : in STD_LOGIC;
    s_axis_aclk : in STD_LOGIC;
    s_axis_tvalid : in STD_LOGIC;
    s_axis_tready : out STD_LOGIC;
    s_axis_tdata : in STD_LOGIC_VECTOR ( 15 downto 0 );
    s_axis_tlast : in STD_LOGIC;
    s_axis_tuser : in STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_aclk : in STD_LOGIC;
    m_axis_tvalid : out STD_LOGIC;
    m_axis_tready : in STD_LOGIC;
    m_axis_tdata : out STD_LOGIC_VECTOR ( 15 downto 0 );
    m_axis_tlast : out STD_LOGIC;
    m_axis_tuser : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component sigma_delta_axis_clock_converter_2_0;
  component sigma_delta_axis_clock_converter_3_0 is
  port (
    s_axis_aresetn : in STD_LOGIC;
    m_axis_aresetn : in STD_LOGIC;
    s_axis_aclk : in STD_LOGIC;
    s_axis_tvalid : in STD_LOGIC;
    s_axis_tready : out STD_LOGIC;
    s_axis_tdata : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axis_tlast : in STD_LOGIC;
    s_axis_tuser : in STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_aclk : in STD_LOGIC;
    m_axis_tvalid : out STD_LOGIC;
    m_axis_tready : in STD_LOGIC;
    m_axis_tdata : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m_axis_tlast : out STD_LOGIC;
    m_axis_tuser : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component sigma_delta_axis_clock_converter_3_0;
  component sigma_delta_sd_proc_wrapper_0_0 is
  generic (
  N : INTEGER;
  T : INTEGER
  );
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
  component sigma_delta_m_axis_int_0_0 is
  port (
    M_AXIS_ACLK : in STD_LOGIC;
    M_AXIS_ARESETN : in STD_LOGIC;
    M_AXIS_TVALID : out STD_LOGIC;
    M_AXIS_TDATA : out STD_LOGIC_VECTOR ( 7 downto 0 );
    M_AXIS_TUSER : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXIS_TLAST : out STD_LOGIC;
    M_AXIS_TREADY : in STD_LOGIC;
    M_FIFO_DATA_IN : in STD_LOGIC_VECTOR ( 7 downto 0 );
    M_FIFO_TUSER : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_FIFO_WRITE_EN : in STD_LOGIC;
    M_FIFO_TLAST : in STD_LOGIC;
    M_FIFO_NOT_ALMOST_FULL : out STD_LOGIC
  );
  end component sigma_delta_m_axis_int_0_0;
  component sigma_delta_m_axis_int_0_1 is
  port (
    M_AXIS_ACLK : in STD_LOGIC;
    M_AXIS_ARESETN : in STD_LOGIC;
    M_AXIS_TVALID : out STD_LOGIC;
    M_AXIS_TDATA : out STD_LOGIC_VECTOR ( 15 downto 0 );
    M_AXIS_TUSER : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXIS_TLAST : out STD_LOGIC;
    M_AXIS_TREADY : in STD_LOGIC;
    M_FIFO_DATA_IN : in STD_LOGIC_VECTOR ( 15 downto 0 );
    M_FIFO_TUSER : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_FIFO_WRITE_EN : in STD_LOGIC;
    M_FIFO_TLAST : in STD_LOGIC;
    M_FIFO_NOT_ALMOST_FULL : out STD_LOGIC
  );
  end component sigma_delta_m_axis_int_0_1;
  component sigma_delta_s_axis_int_0_0 is
  port (
    S_AXIS_ACLK : in STD_LOGIC;
    S_AXIS_ARESETN : in STD_LOGIC;
    S_AXIS_TREADY : out STD_LOGIC;
    S_AXIS_TDATA : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S_AXIS_TUSER : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXIS_TLAST : in STD_LOGIC;
    S_AXIS_TVALID : in STD_LOGIC;
    S_FIFO_DATA_OUT : out STD_LOGIC_VECTOR ( 7 downto 0 );
    S_FIFO_READ_EN : in STD_LOGIC;
    S_FIFO_TLAST : out STD_LOGIC;
    S_FIFO_TUSER : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_FIFO_NOT_ALMOST_EMPTY : out STD_LOGIC
  );
  end component sigma_delta_s_axis_int_0_0;
  component sigma_delta_s_axis_int_0_1 is
  port (
    S_AXIS_ACLK : in STD_LOGIC;
    S_AXIS_ARESETN : in STD_LOGIC;
    S_AXIS_TREADY : out STD_LOGIC;
    S_AXIS_TDATA : in STD_LOGIC_VECTOR ( 15 downto 0 );
    S_AXIS_TUSER : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXIS_TLAST : in STD_LOGIC;
    S_AXIS_TVALID : in STD_LOGIC;
    S_FIFO_DATA_OUT : out STD_LOGIC_VECTOR ( 15 downto 0 );
    S_FIFO_READ_EN : in STD_LOGIC;
    S_FIFO_TLAST : out STD_LOGIC;
    S_FIFO_TUSER : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_FIFO_NOT_ALMOST_EMPTY : out STD_LOGIC
  );
  end component sigma_delta_s_axis_int_0_1;
  signal S_AXIS_FRAME_1_TDATA : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal S_AXIS_FRAME_1_TLAST : STD_LOGIC;
  signal S_AXIS_FRAME_1_TREADY : STD_LOGIC;
  signal S_AXIS_FRAME_1_TUSER : STD_LOGIC_VECTOR ( 0 to 0 );
  signal S_AXIS_FRAME_1_TVALID : STD_LOGIC;
  signal S_AXIS_VM_1_TDATA : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal S_AXIS_VM_1_TLAST : STD_LOGIC;
  signal S_AXIS_VM_1_TREADY : STD_LOGIC;
  signal S_AXIS_VM_1_TUSER : STD_LOGIC_VECTOR ( 0 to 0 );
  signal S_AXIS_VM_1_TVALID : STD_LOGIC;
  signal axis_clock_conv_frame_M_AXIS_TDATA : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal axis_clock_conv_frame_M_AXIS_TLAST : STD_LOGIC;
  signal axis_clock_conv_frame_M_AXIS_TREADY : STD_LOGIC;
  signal axis_clock_conv_frame_M_AXIS_TUSER : STD_LOGIC_VECTOR ( 0 to 0 );
  signal axis_clock_conv_frame_M_AXIS_TVALID : STD_LOGIC;
  signal axis_clock_conv_in_vm_M_AXIS_TDATA : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal axis_clock_conv_in_vm_M_AXIS_TLAST : STD_LOGIC;
  signal axis_clock_conv_in_vm_M_AXIS_TREADY : STD_LOGIC;
  signal axis_clock_conv_in_vm_M_AXIS_TUSER : STD_LOGIC_VECTOR ( 0 to 0 );
  signal axis_clock_conv_in_vm_M_AXIS_TVALID : STD_LOGIC;
  signal axis_clock_converter_2_M_AXIS_TDATA : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal axis_clock_converter_2_M_AXIS_TLAST : STD_LOGIC;
  signal axis_clock_converter_2_M_AXIS_TREADY : STD_LOGIC;
  signal axis_clock_converter_2_M_AXIS_TUSER : STD_LOGIC_VECTOR ( 0 to 0 );
  signal axis_clock_converter_2_M_AXIS_TVALID : STD_LOGIC;
  signal axis_clock_converter_3_M_AXIS_TDATA : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal axis_clock_converter_3_M_AXIS_TLAST : STD_LOGIC;
  signal axis_clock_converter_3_M_AXIS_TREADY : STD_LOGIC;
  signal axis_clock_converter_3_M_AXIS_TUSER : STD_LOGIC_VECTOR ( 0 to 0 );
  signal axis_clock_converter_3_M_AXIS_TVALID : STD_LOGIC;
  signal clock_1 : STD_LOGIC;
  signal m_axis_aclk_0_1 : STD_LOGIC;
  signal m_axis_aclk_1_1 : STD_LOGIC;
  signal m_axis_aresetn_0_1 : STD_LOGIC;
  signal m_axis_aresetn_1_1 : STD_LOGIC;
  signal m_axis_int_mask_M_AXIS_TDATA : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal m_axis_int_mask_M_AXIS_TLAST : STD_LOGIC;
  signal m_axis_int_mask_M_AXIS_TREADY : STD_LOGIC;
  signal m_axis_int_mask_M_AXIS_TUSER : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m_axis_int_mask_M_AXIS_TVALID : STD_LOGIC;
  signal m_axis_int_mask_M_FIFO_NOT_ALMOST_FULL : STD_LOGIC;
  signal m_axis_int_vm_M_AXIS_TDATA : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal m_axis_int_vm_M_AXIS_TLAST : STD_LOGIC;
  signal m_axis_int_vm_M_AXIS_TREADY : STD_LOGIC;
  signal m_axis_int_vm_M_AXIS_TUSER : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m_axis_int_vm_M_AXIS_TVALID : STD_LOGIC;
  signal m_axis_int_vm_M_FIFO_NOT_ALMOST_FULL : STD_LOGIC;
  signal reset_n_1 : STD_LOGIC;
  signal s_axis_aclk_0_1 : STD_LOGIC;
  signal s_axis_aclk_1_1 : STD_LOGIC;
  signal s_axis_aresetn_0_1 : STD_LOGIC;
  signal s_axis_aresetn_0_2 : STD_LOGIC;
  signal s_axis_int_0_S_FIFO_DATA_OUT : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal s_axis_int_0_S_FIFO_DATA_OUT1 : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal s_axis_int_0_S_FIFO_NOT_ALMOST_EMPTY : STD_LOGIC;
  signal s_axis_int_0_S_FIFO_NOT_ALMOST_EMPTY1 : STD_LOGIC;
  signal s_axis_int_0_S_FIFO_TLAST : STD_LOGIC;
  signal s_axis_int_0_S_FIFO_TLAST1 : STD_LOGIC;
  signal s_axis_int_0_S_FIFO_TUSER : STD_LOGIC_VECTOR ( 0 to 0 );
  signal s_axis_int_vm_S_FIFO_TUSER : STD_LOGIC_VECTOR ( 0 to 0 );
  signal sd_proc_wrapper_0_FRAME_READY : STD_LOGIC;
  signal sd_proc_wrapper_0_MASK_EOL : STD_LOGIC;
  signal sd_proc_wrapper_0_MASK_OUT : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal sd_proc_wrapper_0_MASK_SOF : STD_LOGIC;
  signal sd_proc_wrapper_0_MASK_VALID : STD_LOGIC;
  signal sd_proc_wrapper_0_VM_IN_READY : STD_LOGIC;
  signal sd_proc_wrapper_0_VM_OUT_EOL : STD_LOGIC;
  signal sd_proc_wrapper_0_VM_OUT_OUT : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal sd_proc_wrapper_0_VM_OUT_SOF : STD_LOGIC;
  signal sd_proc_wrapper_0_VM_OUT_VALID : STD_LOGIC;
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of M_AXIS_MASK_tlast : signal is "xilinx.com:interface:axis:1.0 M_AXIS_MASK TLAST";
  attribute X_INTERFACE_INFO of M_AXIS_MASK_tready : signal is "xilinx.com:interface:axis:1.0 M_AXIS_MASK TREADY";
  attribute X_INTERFACE_INFO of M_AXIS_MASK_tvalid : signal is "xilinx.com:interface:axis:1.0 M_AXIS_MASK TVALID";
  attribute X_INTERFACE_INFO of M_AXIS_VM_tlast : signal is "xilinx.com:interface:axis:1.0 M_AXIS_VM TLAST";
  attribute X_INTERFACE_INFO of M_AXIS_VM_tready : signal is "xilinx.com:interface:axis:1.0 M_AXIS_VM TREADY";
  attribute X_INTERFACE_INFO of M_AXIS_VM_tvalid : signal is "xilinx.com:interface:axis:1.0 M_AXIS_VM TVALID";
  attribute X_INTERFACE_INFO of S_AXIS_FRAME_tlast : signal is "xilinx.com:interface:axis:1.0 S_AXIS_FRAME TLAST";
  attribute X_INTERFACE_INFO of S_AXIS_FRAME_tready : signal is "xilinx.com:interface:axis:1.0 S_AXIS_FRAME TREADY";
  attribute X_INTERFACE_INFO of S_AXIS_FRAME_tvalid : signal is "xilinx.com:interface:axis:1.0 S_AXIS_FRAME TVALID";
  attribute X_INTERFACE_INFO of S_AXIS_VM_tlast : signal is "xilinx.com:interface:axis:1.0 S_AXIS_VM TLAST";
  attribute X_INTERFACE_INFO of S_AXIS_VM_tready : signal is "xilinx.com:interface:axis:1.0 S_AXIS_VM TREADY";
  attribute X_INTERFACE_INFO of S_AXIS_VM_tvalid : signal is "xilinx.com:interface:axis:1.0 S_AXIS_VM TVALID";
  attribute X_INTERFACE_INFO of clk : signal is "xilinx.com:signal:clock:1.0 CLK.CLK CLK";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of clk : signal is "XIL_INTERFACENAME CLK.CLK, ASSOCIATED_RESET reset_n, CLK_DOMAIN sigma_delta_clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0";
  attribute X_INTERFACE_INFO of m_axis_mask_aclk : signal is "xilinx.com:signal:clock:1.0 CLK.M_AXIS_MASK_ACLK CLK";
  attribute X_INTERFACE_PARAMETER of m_axis_mask_aclk : signal is "XIL_INTERFACENAME CLK.M_AXIS_MASK_ACLK, ASSOCIATED_BUSIF M_AXIS_MASK, ASSOCIATED_RESET m_axis_mask_arstn, CLK_DOMAIN sigma_delta_m_axis_mask_aclk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0";
  attribute X_INTERFACE_INFO of m_axis_mask_arstn : signal is "xilinx.com:signal:reset:1.0 RST.M_AXIS_MASK_ARSTN RST";
  attribute X_INTERFACE_PARAMETER of m_axis_mask_arstn : signal is "XIL_INTERFACENAME RST.M_AXIS_MASK_ARSTN, INSERT_VIP 0, POLARITY ACTIVE_LOW";
  attribute X_INTERFACE_INFO of m_axis_vm_aclk : signal is "xilinx.com:signal:clock:1.0 CLK.M_AXIS_VM_ACLK CLK";
  attribute X_INTERFACE_PARAMETER of m_axis_vm_aclk : signal is "XIL_INTERFACENAME CLK.M_AXIS_VM_ACLK, ASSOCIATED_BUSIF M_AXIS_VM, ASSOCIATED_RESET m_axis_vm_arstn, CLK_DOMAIN sigma_delta_m_axis_vm_aclk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0";
  attribute X_INTERFACE_INFO of m_axis_vm_arstn : signal is "xilinx.com:signal:reset:1.0 RST.M_AXIS_VM_ARSTN RST";
  attribute X_INTERFACE_PARAMETER of m_axis_vm_arstn : signal is "XIL_INTERFACENAME RST.M_AXIS_VM_ARSTN, INSERT_VIP 0, POLARITY ACTIVE_LOW";
  attribute X_INTERFACE_INFO of reset_n : signal is "xilinx.com:signal:reset:1.0 RST.RESET_N RST";
  attribute X_INTERFACE_PARAMETER of reset_n : signal is "XIL_INTERFACENAME RST.RESET_N, INSERT_VIP 0, POLARITY ACTIVE_LOW";
  attribute X_INTERFACE_INFO of s_axis_frame_aclk : signal is "xilinx.com:signal:clock:1.0 CLK.S_AXIS_FRAME_ACLK CLK";
  attribute X_INTERFACE_PARAMETER of s_axis_frame_aclk : signal is "XIL_INTERFACENAME CLK.S_AXIS_FRAME_ACLK, ASSOCIATED_BUSIF S_AXIS_FRAME, ASSOCIATED_RESET s_axis_frame_arstn, CLK_DOMAIN sigma_delta_s_axis_frame_aclk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0";
  attribute X_INTERFACE_INFO of s_axis_frame_arstn : signal is "xilinx.com:signal:reset:1.0 RST.S_AXIS_FRAME_ARSTN RST";
  attribute X_INTERFACE_PARAMETER of s_axis_frame_arstn : signal is "XIL_INTERFACENAME RST.S_AXIS_FRAME_ARSTN, INSERT_VIP 0, POLARITY ACTIVE_LOW";
  attribute X_INTERFACE_INFO of s_axis_vm_aclk : signal is "xilinx.com:signal:clock:1.0 CLK.S_AXIS_VM_ACLK CLK";
  attribute X_INTERFACE_PARAMETER of s_axis_vm_aclk : signal is "XIL_INTERFACENAME CLK.S_AXIS_VM_ACLK, ASSOCIATED_BUSIF S_AXIS_VM, ASSOCIATED_RESET s_axis_vm_arstn, CLK_DOMAIN sigma_delta_s_axis_vm_aclk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0";
  attribute X_INTERFACE_INFO of s_axis_vm_arstn : signal is "xilinx.com:signal:reset:1.0 RST.S_AXIS_VM_ARSTN RST";
  attribute X_INTERFACE_PARAMETER of s_axis_vm_arstn : signal is "XIL_INTERFACENAME RST.S_AXIS_VM_ARSTN, INSERT_VIP 0, POLARITY ACTIVE_LOW";
  attribute X_INTERFACE_INFO of M_AXIS_MASK_tdata : signal is "xilinx.com:interface:axis:1.0 M_AXIS_MASK TDATA";
  attribute X_INTERFACE_PARAMETER of M_AXIS_MASK_tdata : signal is "XIL_INTERFACENAME M_AXIS_MASK, CLK_DOMAIN sigma_delta_m_axis_mask_aclk, FREQ_HZ 100000000, HAS_TKEEP 0, HAS_TLAST 1, HAS_TREADY 1, HAS_TSTRB 0, INSERT_VIP 0, LAYERED_METADATA undef, PHASE 0.0, TDATA_NUM_BYTES 1, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 1";
  attribute X_INTERFACE_INFO of M_AXIS_MASK_tuser : signal is "xilinx.com:interface:axis:1.0 M_AXIS_MASK TUSER";
  attribute X_INTERFACE_INFO of M_AXIS_VM_tdata : signal is "xilinx.com:interface:axis:1.0 M_AXIS_VM TDATA";
  attribute X_INTERFACE_PARAMETER of M_AXIS_VM_tdata : signal is "XIL_INTERFACENAME M_AXIS_VM, CLK_DOMAIN sigma_delta_m_axis_vm_aclk, FREQ_HZ 100000000, HAS_TKEEP 0, HAS_TLAST 1, HAS_TREADY 1, HAS_TSTRB 0, INSERT_VIP 0, LAYERED_METADATA undef, PHASE 0.0, TDATA_NUM_BYTES 2, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 1";
  attribute X_INTERFACE_INFO of M_AXIS_VM_tuser : signal is "xilinx.com:interface:axis:1.0 M_AXIS_VM TUSER";
  attribute X_INTERFACE_INFO of S_AXIS_FRAME_tdata : signal is "xilinx.com:interface:axis:1.0 S_AXIS_FRAME TDATA";
  attribute X_INTERFACE_PARAMETER of S_AXIS_FRAME_tdata : signal is "XIL_INTERFACENAME S_AXIS_FRAME, CLK_DOMAIN sigma_delta_s_axis_frame_aclk, FREQ_HZ 100000000, HAS_TKEEP 0, HAS_TLAST 1, HAS_TREADY 1, HAS_TSTRB 0, INSERT_VIP 0, LAYERED_METADATA undef, PHASE 0.0, TDATA_NUM_BYTES 1, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 1";
  attribute X_INTERFACE_INFO of S_AXIS_FRAME_tuser : signal is "xilinx.com:interface:axis:1.0 S_AXIS_FRAME TUSER";
  attribute X_INTERFACE_INFO of S_AXIS_VM_tdata : signal is "xilinx.com:interface:axis:1.0 S_AXIS_VM TDATA";
  attribute X_INTERFACE_PARAMETER of S_AXIS_VM_tdata : signal is "XIL_INTERFACENAME S_AXIS_VM, CLK_DOMAIN sigma_delta_s_axis_vm_aclk, FREQ_HZ 100000000, HAS_TKEEP 0, HAS_TLAST 1, HAS_TREADY 1, HAS_TSTRB 0, INSERT_VIP 0, LAYERED_METADATA undef, PHASE 0.0, TDATA_NUM_BYTES 2, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 1";
  attribute X_INTERFACE_INFO of S_AXIS_VM_tuser : signal is "xilinx.com:interface:axis:1.0 S_AXIS_VM TUSER";
begin
  M_AXIS_MASK_tdata(7 downto 0) <= axis_clock_converter_3_M_AXIS_TDATA(7 downto 0);
  M_AXIS_MASK_tlast <= axis_clock_converter_3_M_AXIS_TLAST;
  M_AXIS_MASK_tuser(0) <= axis_clock_converter_3_M_AXIS_TUSER(0);
  M_AXIS_MASK_tvalid <= axis_clock_converter_3_M_AXIS_TVALID;
  M_AXIS_VM_tdata(15 downto 0) <= axis_clock_converter_2_M_AXIS_TDATA(15 downto 0);
  M_AXIS_VM_tlast <= axis_clock_converter_2_M_AXIS_TLAST;
  M_AXIS_VM_tuser(0) <= axis_clock_converter_2_M_AXIS_TUSER(0);
  M_AXIS_VM_tvalid <= axis_clock_converter_2_M_AXIS_TVALID;
  S_AXIS_FRAME_1_TDATA(7 downto 0) <= S_AXIS_FRAME_tdata(7 downto 0);
  S_AXIS_FRAME_1_TLAST <= S_AXIS_FRAME_tlast;
  S_AXIS_FRAME_1_TUSER(0) <= S_AXIS_FRAME_tuser(0);
  S_AXIS_FRAME_1_TVALID <= S_AXIS_FRAME_tvalid;
  S_AXIS_FRAME_tready <= S_AXIS_FRAME_1_TREADY;
  S_AXIS_VM_1_TDATA(15 downto 0) <= S_AXIS_VM_tdata(15 downto 0);
  S_AXIS_VM_1_TLAST <= S_AXIS_VM_tlast;
  S_AXIS_VM_1_TUSER(0) <= S_AXIS_VM_tuser(0);
  S_AXIS_VM_1_TVALID <= S_AXIS_VM_tvalid;
  S_AXIS_VM_tready <= S_AXIS_VM_1_TREADY;
  axis_clock_converter_2_M_AXIS_TREADY <= M_AXIS_VM_tready;
  axis_clock_converter_3_M_AXIS_TREADY <= M_AXIS_MASK_tready;
  clock_1 <= clk;
  m_axis_aclk_0_1 <= m_axis_vm_aclk;
  m_axis_aclk_1_1 <= m_axis_mask_aclk;
  m_axis_aresetn_0_1 <= m_axis_vm_arstn;
  m_axis_aresetn_1_1 <= m_axis_mask_arstn;
  reset_n_1 <= reset_n;
  s_axis_aclk_0_1 <= s_axis_vm_aclk;
  s_axis_aclk_1_1 <= s_axis_frame_aclk;
  s_axis_aresetn_0_1 <= s_axis_frame_arstn;
  s_axis_aresetn_0_2 <= s_axis_vm_arstn;
axis_clock_conv_frame: component sigma_delta_axis_clock_converter_1_0
     port map (
      m_axis_aclk => clock_1,
      m_axis_aresetn => reset_n_1,
      m_axis_tdata(7 downto 0) => axis_clock_conv_frame_M_AXIS_TDATA(7 downto 0),
      m_axis_tlast => axis_clock_conv_frame_M_AXIS_TLAST,
      m_axis_tready => axis_clock_conv_frame_M_AXIS_TREADY,
      m_axis_tuser(0) => axis_clock_conv_frame_M_AXIS_TUSER(0),
      m_axis_tvalid => axis_clock_conv_frame_M_AXIS_TVALID,
      s_axis_aclk => s_axis_aclk_1_1,
      s_axis_aresetn => s_axis_aresetn_0_1,
      s_axis_tdata(7 downto 0) => S_AXIS_FRAME_1_TDATA(7 downto 0),
      s_axis_tlast => S_AXIS_FRAME_1_TLAST,
      s_axis_tready => S_AXIS_FRAME_1_TREADY,
      s_axis_tuser(0) => S_AXIS_FRAME_1_TUSER(0),
      s_axis_tvalid => S_AXIS_FRAME_1_TVALID
    );
axis_clock_conv_in_vm: component sigma_delta_axis_clock_converter_0_0
     port map (
      m_axis_aclk => clock_1,
      m_axis_aresetn => reset_n_1,
      m_axis_tdata(15 downto 0) => axis_clock_conv_in_vm_M_AXIS_TDATA(15 downto 0),
      m_axis_tlast => axis_clock_conv_in_vm_M_AXIS_TLAST,
      m_axis_tready => axis_clock_conv_in_vm_M_AXIS_TREADY,
      m_axis_tuser(0) => axis_clock_conv_in_vm_M_AXIS_TUSER(0),
      m_axis_tvalid => axis_clock_conv_in_vm_M_AXIS_TVALID,
      s_axis_aclk => s_axis_aclk_0_1,
      s_axis_aresetn => s_axis_aresetn_0_2,
      s_axis_tdata(15 downto 0) => S_AXIS_VM_1_TDATA(15 downto 0),
      s_axis_tlast => S_AXIS_VM_1_TLAST,
      s_axis_tready => S_AXIS_VM_1_TREADY,
      s_axis_tuser(0) => S_AXIS_VM_1_TUSER(0),
      s_axis_tvalid => S_AXIS_VM_1_TVALID
    );
axis_clock_conv_mask: component sigma_delta_axis_clock_converter_3_0
     port map (
      m_axis_aclk => m_axis_aclk_1_1,
      m_axis_aresetn => m_axis_aresetn_1_1,
      m_axis_tdata(7 downto 0) => axis_clock_converter_3_M_AXIS_TDATA(7 downto 0),
      m_axis_tlast => axis_clock_converter_3_M_AXIS_TLAST,
      m_axis_tready => axis_clock_converter_3_M_AXIS_TREADY,
      m_axis_tuser(0) => axis_clock_converter_3_M_AXIS_TUSER(0),
      m_axis_tvalid => axis_clock_converter_3_M_AXIS_TVALID,
      s_axis_aclk => clock_1,
      s_axis_aresetn => reset_n_1,
      s_axis_tdata(7 downto 0) => m_axis_int_mask_M_AXIS_TDATA(7 downto 0),
      s_axis_tlast => m_axis_int_mask_M_AXIS_TLAST,
      s_axis_tready => m_axis_int_mask_M_AXIS_TREADY,
      s_axis_tuser(0) => m_axis_int_mask_M_AXIS_TUSER(0),
      s_axis_tvalid => m_axis_int_mask_M_AXIS_TVALID
    );
axis_clock_conv_out_vm: component sigma_delta_axis_clock_converter_2_0
     port map (
      m_axis_aclk => m_axis_aclk_0_1,
      m_axis_aresetn => m_axis_aresetn_0_1,
      m_axis_tdata(15 downto 0) => axis_clock_converter_2_M_AXIS_TDATA(15 downto 0),
      m_axis_tlast => axis_clock_converter_2_M_AXIS_TLAST,
      m_axis_tready => axis_clock_converter_2_M_AXIS_TREADY,
      m_axis_tuser(0) => axis_clock_converter_2_M_AXIS_TUSER(0),
      m_axis_tvalid => axis_clock_converter_2_M_AXIS_TVALID,
      s_axis_aclk => clock_1,
      s_axis_aresetn => reset_n_1,
      s_axis_tdata(15 downto 0) => m_axis_int_vm_M_AXIS_TDATA(15 downto 0),
      s_axis_tlast => m_axis_int_vm_M_AXIS_TLAST,
      s_axis_tready => m_axis_int_vm_M_AXIS_TREADY,
      s_axis_tuser(0) => m_axis_int_vm_M_AXIS_TUSER(0),
      s_axis_tvalid => m_axis_int_vm_M_AXIS_TVALID
    );
m_axis_int_mask: component sigma_delta_m_axis_int_0_0
     port map (
      M_AXIS_ACLK => clock_1,
      M_AXIS_ARESETN => reset_n_1,
      M_AXIS_TDATA(7 downto 0) => m_axis_int_mask_M_AXIS_TDATA(7 downto 0),
      M_AXIS_TLAST => m_axis_int_mask_M_AXIS_TLAST,
      M_AXIS_TREADY => m_axis_int_mask_M_AXIS_TREADY,
      M_AXIS_TUSER(0) => m_axis_int_mask_M_AXIS_TUSER(0),
      M_AXIS_TVALID => m_axis_int_mask_M_AXIS_TVALID,
      M_FIFO_DATA_IN(7 downto 0) => sd_proc_wrapper_0_MASK_OUT(7 downto 0),
      M_FIFO_NOT_ALMOST_FULL => m_axis_int_mask_M_FIFO_NOT_ALMOST_FULL,
      M_FIFO_TLAST => sd_proc_wrapper_0_MASK_EOL,
      M_FIFO_TUSER(0) => sd_proc_wrapper_0_MASK_SOF,
      M_FIFO_WRITE_EN => sd_proc_wrapper_0_MASK_VALID
    );
m_axis_int_vm: component sigma_delta_m_axis_int_0_1
     port map (
      M_AXIS_ACLK => clock_1,
      M_AXIS_ARESETN => reset_n_1,
      M_AXIS_TDATA(15 downto 0) => m_axis_int_vm_M_AXIS_TDATA(15 downto 0),
      M_AXIS_TLAST => m_axis_int_vm_M_AXIS_TLAST,
      M_AXIS_TREADY => m_axis_int_vm_M_AXIS_TREADY,
      M_AXIS_TUSER(0) => m_axis_int_vm_M_AXIS_TUSER(0),
      M_AXIS_TVALID => m_axis_int_vm_M_AXIS_TVALID,
      M_FIFO_DATA_IN(15 downto 0) => sd_proc_wrapper_0_VM_OUT_OUT(15 downto 0),
      M_FIFO_NOT_ALMOST_FULL => m_axis_int_vm_M_FIFO_NOT_ALMOST_FULL,
      M_FIFO_TLAST => sd_proc_wrapper_0_VM_OUT_EOL,
      M_FIFO_TUSER(0) => sd_proc_wrapper_0_VM_OUT_SOF,
      M_FIFO_WRITE_EN => sd_proc_wrapper_0_VM_OUT_VALID
    );
s_axis_int_frame: component sigma_delta_s_axis_int_0_0
     port map (
      S_AXIS_ACLK => clock_1,
      S_AXIS_ARESETN => reset_n_1,
      S_AXIS_TDATA(7 downto 0) => axis_clock_conv_frame_M_AXIS_TDATA(7 downto 0),
      S_AXIS_TLAST => axis_clock_conv_frame_M_AXIS_TLAST,
      S_AXIS_TREADY => axis_clock_conv_frame_M_AXIS_TREADY,
      S_AXIS_TUSER(0) => axis_clock_conv_frame_M_AXIS_TUSER(0),
      S_AXIS_TVALID => axis_clock_conv_frame_M_AXIS_TVALID,
      S_FIFO_DATA_OUT(7 downto 0) => s_axis_int_0_S_FIFO_DATA_OUT(7 downto 0),
      S_FIFO_NOT_ALMOST_EMPTY => s_axis_int_0_S_FIFO_NOT_ALMOST_EMPTY,
      S_FIFO_READ_EN => sd_proc_wrapper_0_FRAME_READY,
      S_FIFO_TLAST => s_axis_int_0_S_FIFO_TLAST,
      S_FIFO_TUSER(0) => s_axis_int_0_S_FIFO_TUSER(0)
    );
s_axis_int_vm: component sigma_delta_s_axis_int_0_1
     port map (
      S_AXIS_ACLK => clock_1,
      S_AXIS_ARESETN => reset_n_1,
      S_AXIS_TDATA(15 downto 0) => axis_clock_conv_in_vm_M_AXIS_TDATA(15 downto 0),
      S_AXIS_TLAST => axis_clock_conv_in_vm_M_AXIS_TLAST,
      S_AXIS_TREADY => axis_clock_conv_in_vm_M_AXIS_TREADY,
      S_AXIS_TUSER(0) => axis_clock_conv_in_vm_M_AXIS_TUSER(0),
      S_AXIS_TVALID => axis_clock_conv_in_vm_M_AXIS_TVALID,
      S_FIFO_DATA_OUT(15 downto 0) => s_axis_int_0_S_FIFO_DATA_OUT1(15 downto 0),
      S_FIFO_NOT_ALMOST_EMPTY => s_axis_int_0_S_FIFO_NOT_ALMOST_EMPTY1,
      S_FIFO_READ_EN => sd_proc_wrapper_0_VM_IN_READY,
      S_FIFO_TLAST => s_axis_int_0_S_FIFO_TLAST1,
      S_FIFO_TUSER(0) => s_axis_int_vm_S_FIFO_TUSER(0)
    );
sd_proc_wrapper_0: component sigma_delta_sd_proc_wrapper_0_0
     generic map (
     N => N,
     T => T
     )
     port map (
      CLK => clock_1,
      FRAME_EOL => s_axis_int_0_S_FIFO_TLAST,
      FRAME_IN(7 downto 0) => s_axis_int_0_S_FIFO_DATA_OUT(7 downto 0),
      FRAME_READY => sd_proc_wrapper_0_FRAME_READY,
      FRAME_SOF => s_axis_int_0_S_FIFO_TUSER(0),
      FRAME_VALID => s_axis_int_0_S_FIFO_NOT_ALMOST_EMPTY,
      MASK_EOL => sd_proc_wrapper_0_MASK_EOL,
      MASK_OUT(7 downto 0) => sd_proc_wrapper_0_MASK_OUT(7 downto 0),
      MASK_READY => m_axis_int_mask_M_FIFO_NOT_ALMOST_FULL,
      MASK_SOF => sd_proc_wrapper_0_MASK_SOF,
      MASK_VALID => sd_proc_wrapper_0_MASK_VALID,
      RESETN => reset_n_1,
      VM_IN_EOL => s_axis_int_0_S_FIFO_TLAST1,
      VM_IN_IN(15 downto 0) => s_axis_int_0_S_FIFO_DATA_OUT1(15 downto 0),
      VM_IN_READY => sd_proc_wrapper_0_VM_IN_READY,
      VM_IN_SOF => s_axis_int_vm_S_FIFO_TUSER(0),
      VM_IN_VALID => s_axis_int_0_S_FIFO_NOT_ALMOST_EMPTY1,
      VM_OUT_EOL => sd_proc_wrapper_0_VM_OUT_EOL,
      VM_OUT_OUT(15 downto 0) => sd_proc_wrapper_0_VM_OUT_OUT(15 downto 0),
      VM_OUT_READY => m_axis_int_vm_M_FIFO_NOT_ALMOST_FULL,
      VM_OUT_SOF => sd_proc_wrapper_0_VM_OUT_SOF,
      VM_OUT_VALID => sd_proc_wrapper_0_VM_OUT_VALID
    );
end STRUCTURE;
