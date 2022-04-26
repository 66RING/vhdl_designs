-- 数码管扫描显示功能
-- A B C D四组数码管
-- data_in_X中(3:0)对应第一个数码管 (7:4), (11:8), (15:12)分别对应第2, 3, 4个
-- seg_sel(3:0)为数码管选择编码输出信号
-- seg_data(7:0)为数码管显示数据输出。

library ieee;
use ieee.std_logic_1164.all;

entity seg_dis is
	port(clk, rst: in std_logic;
		data_in_A, data_in_B: in std_logic_vector(15 downto 0);
		data_in_C, data_in_D: in std_logic_vector(15 downto 0);
		seg_sel: out std_logic_vector(3 downto 0);
		seg_data: out std_logic_vector(7 downto 0));
end entity;
