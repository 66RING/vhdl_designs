library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
-- use ieee.numeric.all;

-- 加减乘除
-- 与或非异或

-- TODO clk_ALU = nclk2
entity alu is
	port(
		clk_LED : in std_logic ;
		seg_sel : out std_logic_vector(15 downto 0);
		seg_data : out std_logic_vector(7 downto 0);

		clk_ALU: in std_logic;	-- 时钟
		nreset: in std_logic;	-- 复位
		M_A, M_B: in std_logic;	-- 暂存器选择
		M_F: in std_logic;		-- 程序状态字控制信号
		nALU_EN: in std_logic;	-- ALU运算结果使能
		nPSW_EN: in std_logic;	-- PSW输出使能
		C0: in std_logic;		-- 进位位输入
		S: in std_logic_vector(4 downto 0); 	-- 运算类型和操作选择
		F_in: in std_logic_vector(1 downto 0); 	-- 移位功能选择
		-- data: inout std_logic_vector(7 downto 0); 	-- 数据总线
		datain: in std_logic_vector(7 downto 0); 	-- 数据总线
		AC: out std_logic; 	-- 半进位标志
		CY: out std_logic; 	-- 进位标志
		ZN: out std_logic; 	-- 零标志
		OV: out std_logic); -- 溢出标志
end entity;

architecture beh of alu is
	component octal_dff is
		port(
			clk, nclr: in std_logic;
			D: in std_logic_vector(7 downto 0);
			Q: out std_logic_vector(7 downto 0));
	end component;

	component alu181d is
		port(
			S: in std_logic_vector(3 downto 0);
			M: in std_logic;
			A: in std_logic_vector(3 downto 0);
			B: in std_logic_vector(3 downto 0);
			nCn: in std_logic;		-- 进位输入
			Cout: out std_logic; 		-- 进位输出
			F: out std_logic_vector(3 downto 0)); 	-- 结果
	end component;

	component alu181 is
		port(
			S: in std_logic_vector(3 downto 0);
			M: in std_logic;
			A: in std_logic_vector(7 downto 0);
			B: in std_logic_vector(7 downto 0);
			CN: in std_logic;		-- 进位输入
			Cout: out std_logic; 		-- 进位输出
			OV: out std_logic; 		-- 移除标志
			F: out std_logic_vector(7 downto 0)); 	-- 结果
	end component;


	component seg_dis is
		generic( 
				clk_MHz: integer:=50;
				t_REF_uS: integer:=1000		-- 8K the same purpose
				);
		port(
			clk,rst : in std_logic ;
			data_in_A,data_in_B,data_in_C,data_in_D : in std_logic_vector(15 downto 0);
			seg_sel : out std_logic_vector(15 downto 0);
			seg_data : out std_logic_vector(7 downto 0)
			);
	end component;


	signal data_in_A,data_in_B,data_in_C,data_in_D : std_logic_vector(15 downto 0);


	signal regA_sel, regB_sel: std_logic;
	signal QA:  std_logic_vector(7 downto 0); 	-- 暂存器A
	signal QB:  std_logic_vector(7 downto 0); 	-- 暂存器B


	signal cout1, cout2: std_logic;
	signal F1:  std_logic_vector(3 downto 0); 	-- result1
	signal F2:  std_logic_vector(3 downto 0); 	-- result2

	signal F:  std_logic_vector(7 downto 0); 	-- result
	signal CO:  std_logic;
	signal OV_out:  std_logic;



begin

	led: seg_dis port map(clk_LED, not nreset, data_in_A, data_in_B, data_in_C, data_in_D, seg_sel, seg_data);

	data_in_C <= "00000000"&QA;
	data_in_D <= "00000000"&QB;


	regA_sel <= M_A and clk_ALU;
	regB_sel <= M_B and clk_ALU;

	regA: octal_dff port map(regA_sel, nreset, datain, QA);
	regB: octal_dff port map(regB_sel, nreset, datain, QB);

	alu1: alu181d port map(S(4 downto 1), S(0), QA(3 downto 0), QB(3 downto 0), C0, cout1, F1); 
	-- alu2: alu181d port map(S(4 downto 1), S(0), QA(7 downto 4), QB(7 downto 4), cout1, cout2, F2); 

	alu3: alu181 port map(S(4 downto 1), S(0), QA, QB, C0, cout2, OV_out, F); 


	process(clk_ALU, nreset)
		variable QA_F:  std_logic_vector(7 downto 0); 	-- 暂存器A
		variable cnt:  std_logic_vector(7 downto 0); 	-- 暂存器A
	begin
		if nreset = '0' then
			-- QA <= (others=>'0');
			-- QB <= (others=>'0');
			-- F <= (others=>'0');
			-- F2 <= (others=>'0');
			-- F2 <= (others=>'0');
			-- cout1 <= '0';
			-- cout2 <= '0';
			-- CO <= '0';
		elsif clk_ALU'event and clk_ALU = '1' then

			-- PSW
			if nPSW_EN = '0' then
				AC <= cout1;
				CY <= cout2;
				OV <= OV_out;
				if QA = QB then
					ZN <= '1';
				else
					ZN <= '0';
				end if;
			else 
				AC <= '0';
				CY <= '0';
				ZN <= '0';
			end if;


			if M_F = '1' then 	-- if shft
				QA_F := QA;
				if F_in = "00" then 	-- LL
					L1: for i in 0 to 7  loop
						if QB(i) = '0' then
							exit L1;
						end if;

						QA_F(7 downto 1) := QA_F(6 downto 0);
						QA_F(0) := '0';
					end loop;
				elsif F_in = "01" then 	-- LR
					L2: for i in 0 to 7  loop
						if QB(i) = '0' then
							exit L2;
						end if;
						QA_F(6 downto 0) := QA_F(7 downto 1);
						QA_F(7) := '0';
					end loop;
				elsif F_in = "10" then 	-- AL
					L3: for i in 0 to 7  loop
						if QB(i) = '0' then
							exit L3;
						end if;
						QA_F(7 downto 1) := QA_F(6 downto 0);
						QA_F(0) := '0';
					end loop;
				elsif F_in = "11" then 	-- AR
					L4: for i in 0 to 7  loop
						if QB(i) = '0' then
							exit L4;
						end if;
						QA_F(6 downto 0) := QA_F(7 downto 1);
					end loop;
				end if;
				data_in_A <= "00000000"&QA_F;
			else				-- if not shift
				data_in_A <= "00000000"&F;
			end if;
		end if;


	end process;


	-- -- TODO

	-- process(clk_ALU, nreset, M_A, M_B)
	-- begin
	-- 	if M_A = '1' or M_B = '1' then
	-- 		data <= (others=>'Z');
	-- 	end if;


	-- end process;

end beh;
