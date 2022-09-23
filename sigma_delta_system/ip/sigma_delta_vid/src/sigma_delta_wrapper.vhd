--Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2021.2 (win64) Build 3367213 Tue Oct 19 02:48:09 MDT 2021
--Date        : Sun Jul 31 23:43:50 2022
--Host        : DESKTOP-GPI6FBP running 64-bit major release  (build 9200)
--Command     : generate_target sigma_delta_wrapper.bd
--Design      : sigma_delta_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity sigma_delta_wrapper is
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
end sigma_delta_wrapper;

architecture STRUCTURE of sigma_delta_wrapper is
  component sigma_delta is
  port (
    reset_n : in STD_LOGIC;
    clk : in STD_LOGIC;
    s_axis_frame_arstn : in STD_LOGIC;
    s_axis_vm_arstn : in STD_LOGIC;
    s_axis_vm_aclk : in STD_LOGIC;
    s_axis_frame_aclk : in STD_LOGIC;
    m_axis_vm_arstn : in STD_LOGIC;
    m_axis_vm_aclk : in STD_LOGIC;
    m_axis_mask_arstn : in STD_LOGIC;
    m_axis_mask_aclk : in STD_LOGIC;
    S_AXIS_FRAME_tvalid : in STD_LOGIC;
    S_AXIS_FRAME_tready : out STD_LOGIC;
    S_AXIS_FRAME_tdata : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S_AXIS_FRAME_tlast : in STD_LOGIC;
    S_AXIS_FRAME_tuser : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXIS_VM_tvalid : in STD_LOGIC;
    S_AXIS_VM_tready : out STD_LOGIC;
    S_AXIS_VM_tdata : in STD_LOGIC_VECTOR ( 15 downto 0 );
    S_AXIS_VM_tlast : in STD_LOGIC;
    S_AXIS_VM_tuser : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXIS_VM_tvalid : out STD_LOGIC;
    M_AXIS_VM_tready : in STD_LOGIC;
    M_AXIS_VM_tdata : out STD_LOGIC_VECTOR ( 15 downto 0 );
    M_AXIS_VM_tlast : out STD_LOGIC;
    M_AXIS_VM_tuser : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXIS_MASK_tvalid : out STD_LOGIC;
    M_AXIS_MASK_tready : in STD_LOGIC;
    M_AXIS_MASK_tdata : out STD_LOGIC_VECTOR ( 7 downto 0 );
    M_AXIS_MASK_tlast : out STD_LOGIC;
    M_AXIS_MASK_tuser : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component sigma_delta;
begin
sigma_delta_i: component sigma_delta
     port map (
      M_AXIS_MASK_tdata(7 downto 0) => M_AXIS_MASK_tdata(7 downto 0),
      M_AXIS_MASK_tlast => M_AXIS_MASK_tlast,
      M_AXIS_MASK_tready => M_AXIS_MASK_tready,
      M_AXIS_MASK_tuser(0) => M_AXIS_MASK_tuser(0),
      M_AXIS_MASK_tvalid => M_AXIS_MASK_tvalid,
      M_AXIS_VM_tdata(15 downto 0) => M_AXIS_VM_tdata(15 downto 0),
      M_AXIS_VM_tlast => M_AXIS_VM_tlast,
      M_AXIS_VM_tready => M_AXIS_VM_tready,
      M_AXIS_VM_tuser(0) => M_AXIS_VM_tuser(0),
      M_AXIS_VM_tvalid => M_AXIS_VM_tvalid,
      S_AXIS_FRAME_tdata(7 downto 0) => S_AXIS_FRAME_tdata(7 downto 0),
      S_AXIS_FRAME_tlast => S_AXIS_FRAME_tlast,
      S_AXIS_FRAME_tready => S_AXIS_FRAME_tready,
      S_AXIS_FRAME_tuser(0) => S_AXIS_FRAME_tuser(0),
      S_AXIS_FRAME_tvalid => S_AXIS_FRAME_tvalid,
      S_AXIS_VM_tdata(15 downto 0) => S_AXIS_VM_tdata(15 downto 0),
      S_AXIS_VM_tlast => S_AXIS_VM_tlast,
      S_AXIS_VM_tready => S_AXIS_VM_tready,
      S_AXIS_VM_tuser(0) => S_AXIS_VM_tuser(0),
      S_AXIS_VM_tvalid => S_AXIS_VM_tvalid,
      clk => clk,
      m_axis_mask_aclk => m_axis_mask_aclk,
      m_axis_mask_arstn => m_axis_mask_arstn,
      m_axis_vm_aclk => m_axis_vm_aclk,
      m_axis_vm_arstn => m_axis_vm_arstn,
      reset_n => reset_n,
      s_axis_frame_aclk => s_axis_frame_aclk,
      s_axis_frame_arstn => s_axis_frame_arstn,
      s_axis_vm_aclk => s_axis_vm_aclk,
      s_axis_vm_arstn => s_axis_vm_arstn
    );
end STRUCTURE;
