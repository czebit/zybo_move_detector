-- (c) Copyright 1995-2022 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
-- DO NOT MODIFY THIS FILE.

-- IP VLNV: xilinx.com:module_ref:sd_proc_wrapper:1.0
-- IP Revision: 1

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY sigma_delta_sd_proc_wrapper_0_0 IS
  PORT (
    CLK : IN STD_LOGIC;
    RESETN : IN STD_LOGIC;
    FRAME_IN : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    FRAME_SOF : IN STD_LOGIC;
    FRAME_EOL : IN STD_LOGIC;
    FRAME_READY : OUT STD_LOGIC;
    FRAME_VALID : IN STD_LOGIC;
    VM_IN_IN : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    VM_IN_READY : OUT STD_LOGIC;
    VM_IN_VALID : IN STD_LOGIC;
    VM_IN_SOF : IN STD_LOGIC;
    VM_IN_EOL : IN STD_LOGIC;
    VM_OUT_OUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    VM_OUT_READY : IN STD_LOGIC;
    VM_OUT_VALID : OUT STD_LOGIC;
    VM_OUT_SOF : OUT STD_LOGIC;
    VM_OUT_EOL : OUT STD_LOGIC;
    MASK_OUT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    MASK_SOF : OUT STD_LOGIC;
    MASK_EOL : OUT STD_LOGIC;
    MASK_READY : IN STD_LOGIC;
    MASK_VALID : OUT STD_LOGIC
  );
END sigma_delta_sd_proc_wrapper_0_0;

ARCHITECTURE sigma_delta_sd_proc_wrapper_0_0_arch OF sigma_delta_sd_proc_wrapper_0_0 IS
  ATTRIBUTE DowngradeIPIdentifiedWarnings : STRING;
  ATTRIBUTE DowngradeIPIdentifiedWarnings OF sigma_delta_sd_proc_wrapper_0_0_arch: ARCHITECTURE IS "yes";
  COMPONENT sd_proc_wrapper IS
    GENERIC (
      C_DATA_WIDTH : INTEGER;
      N : INTEGER;
      T : INTEGER
    );
    PORT (
      CLK : IN STD_LOGIC;
      RESETN : IN STD_LOGIC;
      FRAME_IN : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      FRAME_SOF : IN STD_LOGIC;
      FRAME_EOL : IN STD_LOGIC;
      FRAME_READY : OUT STD_LOGIC;
      FRAME_VALID : IN STD_LOGIC;
      VM_IN_IN : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      VM_IN_READY : OUT STD_LOGIC;
      VM_IN_VALID : IN STD_LOGIC;
      VM_IN_SOF : IN STD_LOGIC;
      VM_IN_EOL : IN STD_LOGIC;
      VM_OUT_OUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      VM_OUT_READY : IN STD_LOGIC;
      VM_OUT_VALID : OUT STD_LOGIC;
      VM_OUT_SOF : OUT STD_LOGIC;
      VM_OUT_EOL : OUT STD_LOGIC;
      MASK_OUT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      MASK_SOF : OUT STD_LOGIC;
      MASK_EOL : OUT STD_LOGIC;
      MASK_READY : IN STD_LOGIC;
      MASK_VALID : OUT STD_LOGIC
    );
  END COMPONENT sd_proc_wrapper;
  ATTRIBUTE X_CORE_INFO : STRING;
  ATTRIBUTE X_CORE_INFO OF sigma_delta_sd_proc_wrapper_0_0_arch: ARCHITECTURE IS "sd_proc_wrapper,Vivado 2021.2";
  ATTRIBUTE CHECK_LICENSE_TYPE : STRING;
  ATTRIBUTE CHECK_LICENSE_TYPE OF sigma_delta_sd_proc_wrapper_0_0_arch : ARCHITECTURE IS "sigma_delta_sd_proc_wrapper_0_0,sd_proc_wrapper,{}";
  ATTRIBUTE CORE_GENERATION_INFO : STRING;
  ATTRIBUTE CORE_GENERATION_INFO OF sigma_delta_sd_proc_wrapper_0_0_arch: ARCHITECTURE IS "sigma_delta_sd_proc_wrapper_0_0,sd_proc_wrapper,{x_ipProduct=Vivado 2021.2,x_ipVendor=xilinx.com,x_ipLibrary=module_ref,x_ipName=sd_proc_wrapper,x_ipVersion=1.0,x_ipCoreRevision=1,x_ipLanguage=VHDL,x_ipSimLanguage=MIXED,C_DATA_WIDTH=8}";
  ATTRIBUTE IP_DEFINITION_SOURCE : STRING;
  ATTRIBUTE IP_DEFINITION_SOURCE OF sigma_delta_sd_proc_wrapper_0_0_arch: ARCHITECTURE IS "module_ref";
  ATTRIBUTE X_INTERFACE_INFO : STRING;
  ATTRIBUTE X_INTERFACE_PARAMETER : STRING;
  ATTRIBUTE X_INTERFACE_PARAMETER OF RESETN: SIGNAL IS "XIL_INTERFACENAME RESETN, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF RESETN: SIGNAL IS "xilinx.com:signal:reset:1.0 RESETN RST";
  ATTRIBUTE X_INTERFACE_PARAMETER OF CLK: SIGNAL IS "XIL_INTERFACENAME CLK, ASSOCIATED_RESET RESETN, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN sigma_delta_clk, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF CLK: SIGNAL IS "xilinx.com:signal:clock:1.0 CLK CLK";
BEGIN
  U0 : sd_proc_wrapper
    GENERIC MAP (
      C_DATA_WIDTH => 8,
      N => 2,
      T => 5
    )
    PORT MAP (
      CLK => CLK,
      RESETN => RESETN,
      FRAME_IN => FRAME_IN,
      FRAME_SOF => FRAME_SOF,
      FRAME_EOL => FRAME_EOL,
      FRAME_READY => FRAME_READY,
      FRAME_VALID => FRAME_VALID,
      VM_IN_IN => VM_IN_IN,
      VM_IN_READY => VM_IN_READY,
      VM_IN_VALID => VM_IN_VALID,
      VM_IN_SOF => VM_IN_SOF,
      VM_IN_EOL => VM_IN_EOL,
      VM_OUT_OUT => VM_OUT_OUT,
      VM_OUT_READY => VM_OUT_READY,
      VM_OUT_VALID => VM_OUT_VALID,
      VM_OUT_SOF => VM_OUT_SOF,
      VM_OUT_EOL => VM_OUT_EOL,
      MASK_OUT => MASK_OUT,
      MASK_SOF => MASK_SOF,
      MASK_EOL => MASK_EOL,
      MASK_READY => MASK_READY,
      MASK_VALID => MASK_VALID
    );
END sigma_delta_sd_proc_wrapper_0_0_arch;
