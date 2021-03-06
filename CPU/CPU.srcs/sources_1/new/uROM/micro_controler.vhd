library ieee;
use ieee.std_logic_1164.all;

-- clk_MC = clk2 & W0
-- 控制信号由uMC发出

-- 取指
-- 取数
-- 执行
-- 写回

entity micro_controler is
	generic (WORDLENGTH : integer := 48;
			ADDRLENGTH : integer := 8);
	port(
		uAR_out : out std_logic_vector(ADDRLENGTH-1 downto 0);

		clk_MC: in std_logic;
		nreset: in std_logic;
		IR: in std_logic_vector(7 downto 2) := (others=>'0'); -- IR操作码信息
		M_uA: in std_logic;		-- 微程地址控制信号
		CMROM_CS: in std_logic := '1'; -- 控制存储器(uROM)选通信号
		CM: out std_logic_vector(WORDLENGTH-1 downto 0));
end entity;


-- TODO
-- IR -> trans -> uAR

architecture beh of micro_controler is
	component uMC_ROM is
		generic (WORDLENGTH : integer := 48;
				ADDRLENGTH : integer := 8);
		port(
			addr: in std_logic_vector(ADDRLENGTH-1 downto 0);
			oe: in std_logic;
			dout: out std_logic_vector(WORDLENGTH-1 downto 0));
	end component;



	signal uAR : std_logic_vector(ADDRLENGTH-1 downto 0);
	signal uAR_t : std_logic_vector(ADDRLENGTH-1 downto 0) := (others=>'0');
	signal uIR: std_logic_vector(WORDLENGTH-1 downto 0);
	signal started: std_logic := '0';

begin
	uAR_out <= uAR;
	uAR <= IR & "00" when started = '0' else
		   uAR_t;

	-- may be we can M_uA <= W0
	process(M_uA, clk_MC, nreset)
	begin
		if nreset = '0' then
			-- uAR_t <= IR & "00";
			started <= '0';
		elsif clk_MC'event and clk_MC = '1' then
			-- 入口4对齐的
			-- align(4)
			if M_uA = '1' then
				uAR_t <= IR & "00";
			elsif M_uA = '0' then
				-- 启动后的锁存状态持续到w0结束
				started <= '1';
				uAR_t <= uIR(7 downto 0);
			end if;
		end if;
	end process;

	-- uIR(7 downto 0): u7 ~ u0
	CM <= uIR;
	uROM: uMC_ROM port map(uAR, CMROM_CS, uIR);

end beh;

