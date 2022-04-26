-- 顶层测试模块
-- clk为系统时钟输入
-- rst为复位信号
-- key_in为**十六个拨码**开关输入值
-- seg_sel为数码管选择信号
-- set_data为数码管娴熟数据输出

library ieee;
use ieee.std_logic_1164.all;

entity seg_dis_keyin is
	port(clk, rst: std_logic;
		key_in: in std_logic_vector(15 downto 0);
		seg_sel: out std_logic_vector(3 downto 0);
		seg_data: out std_logic_vector(7 downto 0));
end entity;

architecture beh of seg_dis_keyin is
begin
end beh;
