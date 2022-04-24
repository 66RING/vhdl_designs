library ieee;

use ieee.std_logic_1164.all;

entity booth8b is
	port(clk_in: in std_logic;
		rst: in std_logic;
		a_in, b_in: in std_logic_vector(7 downto 0);
		sum_out: out std_logic_vector(15 downto 0));
end entity;

architecture beh of booth8b is
	component controler is
		port(clk, rst: in std_logic;
			clkout, done: out std_logic);
	end component;

	-- 记录结果
	component reg16b is
		port(clk, rst: in std_logic;
			din: in std_logic_vector(7 downto 0);
			dout: out std_logic_vector(16 downto 0));
	end component;

	component reg8shift is
		port(clk, load : in std_logic;
			din: in std_logic_vector(7 downto 0);
			-- 01: +B
			-- 00: +0
			-- 11: +0
			-- 10: -B
			op_sel: out std_logic_vector(1 downto 0));
	end component;

	component selector is
		port(din: in std_logic_vector(7 downto 0);
			op_sel: in std_logic_vector(1 downto 0);
			dout: out std_logic_vector(7 downto 0));
	end component;

	component adder8b_s is
		port(
			c_in: in std_logic;
			a: in std_logic_vector(7 downto 0);
			b: in std_logic_vector(7 downto 0);
			result: out std_logic_vector(7 downto 0);
			c_out: out std_logic
		);
	end component;

	signal clkout: std_logic;
	signal done: std_logic;
	signal op_sel: std_logic_vector(1 downto 0);
	-- 所选择的待加被乘数
	signal B: std_logic_vector(7 downto 0);
	signal D: std_logic_vector(16 downto 0);

	signal sum: std_logic_vector(7 downto 0);
	-- signal csum: std_logic_vector(8 downto 0);
	signal csum: std_logic_vector(7 downto 0);
	signal c_out: std_logic;
begin
	u1: controler port map(clk_in, rst, clkout, done);

	u2: reg16b port map(clkout, rst, csum, D);

	u3: reg8shift port map(clkout, rst, b_in, op_sel);

	u4: selector port map(a_in, op_sel, B);

	u5: adder8b_s port map('0', B, D(16 downto 9), sum, c_out);

	csum <= sum;
	sum_out <= D(15 downto 0);

end beh;
