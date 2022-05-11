library ieee;
use ieee.std_logic_1164.all;

entity cpu is
	port(
		clk_LED: in std_logic;
		seg_sel : out std_logic_vector(15 downto 0);
		seg_data : out std_logic_vector(7 downto 0);

		clk: in std_logic;
		nreset: in std_logic);
end entity;

architecture beh of cpu is
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

	component sp is
		port(
			SP_out: out std_logic_vector(7 downto 0);

			clk_SP: in std_logic;
			nreset: in std_logic;
			SP_CS: in std_logic;
			SP_UP: in std_logic;
			SP_DN: in std_logic;
			nSP_EN: in std_logic;
			AR: out std_logic_vector(6 downto 0);		-- sp输出ram地址
			-- data: inout std_logic_vector(7 downto 0));
			spin: in std_logic_vector(7 downto 0));
	end component;

	component ram is
		port(
			clk_RAM: in std_logic;
			nreset: in std_logic;
			RAM_CS: in std_logic;
			nRAM_EN: in std_logic;		-- 输出使能
			wr_nRD: in std_logic;		-- 读写信号1读，0写
			AR: in std_logic_vector(6 downto 0);	-- 地址信号
			-- data: inout std_logic_vector(7 downto 0));
			ramin: in std_logic_vector(7 downto 0);
			ramout: out std_logic_vector(7 downto 0));
	end component;

	component clk_gen is
		port(
			clk, reset: in std_logic;
			clk1, nclk1: out std_logic := '0';
			clk2, nclk2: out std_logic := '0';
			w0, w1, w2, w3: out std_logic := '0');
	end component;

	component rom is
		generic (WORDLENGTH : integer := 8;
				ADDRLENGTH : integer := 12);
		port(
			clk_ROM: in std_logic; -- ROM时钟信号
			M_ROM: in std_logic; -- ROM片选信号
			ROM_EN: in std_logic; -- ROM使能信号
			addr: in std_logic_vector(11 downto 0); -- ROM地址信号
			-- data: inout std_logic_vector(7 downto 0)	-- 数据总线
			romout: out std_logic_vector(7 downto 0)	-- 数据总线
		);
	end component;


	component micro_controler is
		generic (WORDLENGTH : integer := 48;
				ADDRLENGTH : integer := 8);
		port(
			uAR_out : out std_logic_vector(ADDRLENGTH-1 downto 0);

			clk_MC: in std_logic;
			nreset: in std_logic;
			IR: in std_logic_vector(7 downto 2); -- IR操作码信息
			M_uA: in std_logic;		-- 微程地址控制信号
			CMROM_CS: in std_logic; -- 控制存储器(uROM)选通信号
			CM: out std_logic_vector(WORDLENGTH-1 downto 0));
	end component;

	component pc is
		port(
			clk_pc: in std_logic; 		-- pc时钟信号
			nreset: in std_logic;		-- 全局复位信号, n开头表示低电平有效
			nLD_PC: in std_logic; 		-- 装载新地址
			M_PC: in std_logic; 		-- PC加一信号
			nPCH, nPCL: in std_logic;	-- PC输出总线控制信号，分两次送H表示高位
			PC: in std_logic_vector(11 downto 0);		-- PC指针, 来自IR
			ADDR: out std_logic_vector(11 downto 0);	-- ROM读地址输出
			pcout: out std_logic_vector(7 downto 0) 		-- PC数值输出到数据总线
			-- d: inout std_logic_vector(7 downto 0) 		-- PC数值输出到数据总线
		);
	end component;

	-- clk_RN = nclk2
	component RN is
		port(
			R0_out: out std_logic_vector(7 downto 0);
			R1_out: out std_logic_vector(7 downto 0);

			clk_RN: in std_logic;						-- RN时钟信号
			nreset: in std_logic;						-- 复位
			Rn_CS: in std_logic;						-- RD RS disorder(read mode only)
			nRi_EN: in std_logic; 						-- RN寄存器使能 (低电平有效)
			RDRi, WRRi: in std_logic;					-- RN读写信号
			RS: in	std_logic;							-- 源寄存器地址(0,1中选一个)
			RD: in	std_logic; 							-- 目的寄存器地址
			-- data: inout std_logic_vector(7 downto 0));	-- 数据总线
			rnin: in std_logic_vector(7 downto 0);	-- 数据总线
			rnout: out std_logic_vector(7 downto 0));	-- 数据总线
	end component;

	-- nclk2
	component IR is
		port(
			clk_IR: in std_logic;						-- IR时钟信号
			nreset: in std_logic;						-- 复位
			LD_IR1, LD_IR2, LD_IR3: in std_logic;		-- 存储控制信号
			nARen: in std_logic; 						-- AR使能
			-- 为什么data是inout时出问题是UU呢？？
			-- data: inout std_logic_vector(7 downto 0);	-- 数据总线
			irin: in std_logic_vector(7 downto 0);	-- 数据总线
			IR: out std_logic_vector(7 downto 2);		-- IR地址编码
			PC: out std_logic_vector(11 downto 0);		-- PC新地址
			AR: out std_logic_vector(6 downto 0); 		-- RAM读写地址  6bit(低2bit做寄存器)
			RS: out std_logic; 							-- 源寄存器		1bit
			RD: out std_logic); 						-- 目的寄存器 	1bit
	end component;

	component alu is
		port(
			clk_ALU : in std_logic ;
			nreset: in std_logic;	-- 复位
			M_A, M_B: in std_logic;	-- 暂存器选择
			M_F: in std_logic;		-- 程序状态字控制信号
			nALU_EN: in std_logic;	-- ALU运算结果使能
			nPSW_EN: in std_logic;	-- PSW输出使能
			C0: in std_logic;		-- 进位位输入
			S: in std_logic_vector(4 downto 0); 	-- 运算类型和操作选择
			F_in: in std_logic_vector(1 downto 0); 	-- 移位功能选择
			-- data: inout std_logic_vector(7 downto 0); 	-- 数据总线
			aluin: in std_logic_vector(7 downto 0); 	-- 数据总线
			aluout: out std_logic_vector(7 downto 0); 	-- 数据总线
			AC: out std_logic; 	-- 半进位标志
			CY: out std_logic; 	-- 进位标志
			ZN: out std_logic; 	-- 零标志
			OV: out std_logic); -- 溢出标志
	end component;




	signal M_A, M_B, M_F: std_logic;
	-- S3 S2 S1 S0 M
	signal S: std_logic_vector(4 downto 0);
	signal F: std_logic_vector(1 downto 0);
	signal nALU_EN, nPSW_EN: std_logic;

	signal C0 : std_logic;
	signal RAM_CS : std_logic;
	signal Wr_nRD : std_logic;
	signal nRAM_EN : std_logic;

	signal Rn_CS: std_logic;
	signal RDRi: std_logic;
	signal WRRi: std_logic;
	signal nRi_EN: std_logic;

	-- 27 26 25 24
	signal LDIR1: std_logic;
	signal LDIR2: std_logic;
	signal LDIR3: std_logic;
	signal nAREN: std_logic;

	signal M_PC: std_logic;
	signal nLD_PC: std_logic;
	signal nPCH: std_logic;
	signal nPCL: std_logic;

	-- 19 18 17 16
	signal SP_UP: std_logic;
	signal SP_DN: std_logic;
	signal SP_CS: std_logic;
	signal nSP_EN: std_logic;

	-- 15 14 13 12
	signal P_CS: std_logic;
	signal nP_IEN: std_logic;
	signal nP_OEN: std_logic;
	-- signal X: std_logic;

	-- 11 10 9 8 
	signal M_ROM: std_logic;
	signal nROM_EN: std_logic;
	signal M_uA: std_logic;
	signal CMROM_CS: std_logic;

	signal clk1, nclk1, clk2, nclk2, w0, w1, w2, w3: std_logic;

	signal IR_reg: std_logic_vector(7 downto 2) := (others=>'0');
	signal CM_reg: std_logic_vector(47 downto 0);

	signal new_pc: std_logic_vector(11 downto 0) := (others=>'0');
	signal rom_addr_reg: std_logic_vector(11 downto 0) := (others=>'0');	-- ROM读地址输出
	signal ar_reg: std_logic_vector(6 downto 0);	-- ram addr
	signal data: std_logic_vector(7 downto 0);	-- 总线
	signal rs_reg: std_logic;	-- source
	signal rd_reg: std_logic;	-- destination

	-- alu flags
	signal AC: std_logic; 	-- 半进位标志
	signal CY: std_logic; 	-- 进位标志
	signal ZN: std_logic; 	-- 零标志
	signal OV: std_logic; -- 溢出标志

	signal result: std_logic_vector(7 downto 0);




	signal data_in_A,data_in_B,data_in_C,data_in_D : std_logic_vector(15 downto 0);

	signal CY_L, ZN_L: std_logic;

	-- TODO temp
	signal aluin: std_logic_vector(7 downto 0);
	signal aluout: std_logic_vector(7 downto 0);
	signal pcout: std_logic_vector(7 downto 0);
	signal romout: std_logic_vector(7 downto 0);
	signal irin: std_logic_vector(7 downto 0);
	signal rnin: std_logic_vector(7 downto 0);
	signal rnout: std_logic_vector(7 downto 0);
	signal spin: std_logic_vector(7 downto 0);
	signal ramin: std_logic_vector(7 downto 0);
	signal ramout: std_logic_vector(7 downto 0);
begin

	-- uAR, SP, R1, R0
	U_led: seg_dis port map(clk_LED, not nreset, data_in_A, data_in_B, data_in_C,
						   data_in_D, seg_sel, seg_data);

	data_in_D(15 downto 8) <= (others=>'0');
	data_in_C(15 downto 8) <= (others=>'0');
	data_in_B(15 downto 8) <= (others=>'0');
	data_in_A(15 downto 8) <= (others=>'0');


	U_clocker: clk_gen port map(clk, nreset, clk1, nclk1, clk2, nclk2, w0, w1, w2, w3);

	-- -- TODO ALU输出到哪??没有锁存
	-- TODO ALU 有问题，影响data
	-- TODO fuckin alu
	U_ALU: alu port map(nclk2, nreset, M_A, M_B, M_F, nALU_EN, nPSW_EN, C0,
					   -- S, F, data, AC, CY, ZN, OV);
					   S, F, aluin, aluout, AC, CY, ZN, OV);


	-- TODO clk
	-- ??
	-- TODO
	U_pc: pc port map(nclk2,nreset,nLD_PC,M_PC,nPCH,nPCL,
					new_pc, 	-- TODO PC(11 downto 0) <= IR(7 downto 2)??
					-- IR_reg&"000000", 	-- TODO PC(11 downto 0) <= IR(7 downto 2)??
					rom_addr_reg, 	-- TODO ???
					-- data); 			-- PC送总线，两次送 nPCH, nPCL
					pcout); 			-- PC送总线，两次送 nPCH, nPCL


	U_rom: rom port map((clk2 and nclk1), M_ROM, not nROM_EN, rom_addr_reg, romout);


	U_ir: IR port map(nclk2, nreset, LDIR1, LDIR2, LDIR3, nAREN, irin,
					 IR_reg, 
					 new_pc,
					 -- rom_addr_reg,
					 ar_reg,rs_reg,rd_reg);


	-- 设M_uA <= w0
	-- TODO CMROM_CS hard code 1
	U_CM: micro_controler port map(data_in_D(7 downto 0), clk2, nreset, IR_reg, w0, '1', CM_reg);


	-- nRi_EN 微码 错误？？？
	-- U_RN: RN port map(nclk2, nreset, not nRi_EN, RDRi, WRRi, rs_reg, rd_reg, data);
	-- U_RN: RN port map(nclk2, nreset, nRi_EN, RDRi, WRRi, rs_reg, rd_reg, data);

	-- TODO!!!!!!
	-- TODO!!!!!! -- change nclk2 -> nclk1
	-- TODO!!!!!!

	-- TODO modify
	-- TODO Rn_CS = 1 => rs is rs; Rn_CS = 0 => rs is rd; since we read from rs only
	-- TODO only work in read mode
	-- TODO modify
	U_RN: RN port map(data_in_A(7 downto 0), data_in_B(7 downto 0), nclk1, nreset, Rn_CS, nRi_EN, RDRi, WRRi, rs_reg, rd_reg, rnin, rnout);


	U_SP: sp port map(data_in_C(7 downto 0), (clk1 and clk2 and w1), nreset, SP_CS, SP_UP, SP_DN, nSP_EN, ar_reg, spin);

	U_RAM: ram port map((nclk1 and w1), nreset, RAM_CS, nRAM_EN, wr_nRD, ar_reg, ramin, ramout);



	aluin <= rnout;

	rnin <= aluout when nALU_EN = '0' else
			romout when (M_ROM = '1' and nROM_EN = '0') else
			rnout when RDRi = '0' else
			ramout when nRAM_EN = '0' else
			(others => 'Z');

	irin <= romout when nROM_EN = '0';

	spin <= romout when nROM_EN = '0';

	ramin <= romout when nRAM_EN = '0' else
			 rnout when nRi_EN = '0' else
			 (others => 'Z');





















	-- signal binding
	M_A <= CM_reg(47);
	M_B <= CM_reg(46);
	M_F <= CM_reg(45);

	-- TODO 
	-- S <= CM_reg(44 downto 40);
	-- S3 & S2 & S1 & S0 & M
	S <= CM_reg(43 downto 40) & CM_reg(44);

	F <= CM_reg(39 downto 38);
	nALU_EN <= CM_reg(37);
	nPSW_EN <= CM_reg(36);

	-- 35 34 33 32
	C0 <= CM_reg(35);
	RAM_CS <= CM_reg(34);
	Wr_nRD <= CM_reg(33);
	nRAM_EN <= CM_reg(32);

	Rn_CS <= CM_reg(31);
	RDRi <= CM_reg(30);
	WRRi <= CM_reg(29);
	nRi_EN <= CM_reg(28);

	LDIR1 <= CM_reg(27);
	LDIR2 <= CM_reg(26);
	LDIR3 <= CM_reg(25);
	nAREN <= CM_reg(24);

	M_PC <= CM_reg(23);

	p_ldpc: process(nALU_EN, CM_reg(22), IR_reg)
		variable CY_T, ZN_T: std_logic;
	begin

		-- latch
		if nALU_EN'event and nALU_EN = '1' then
			CY_T := CY;
			ZN_T := ZN;
			CY_L <= CY;
			ZN_L <= ZN;
		end if;

		if IR_reg = "100011" then -- if JZ
			nLD_PC <= not ZN_L;
		elsif IR_reg = "100100" then -- if JC
			nLD_PC <= not CY_L;
		else
			nLD_PC <= CM_reg(22);
		end if;
	end process;

	-- nLD_PC <= CM_reg(22);


	nPCH <= CM_reg(21);
	nPCL <= CM_reg(20);

	SP_UP <= CM_reg(19);
	SP_DN <= CM_reg(18);
	SP_CS <= CM_reg(17);
	nSP_EN <= CM_reg(16);

	P_CS <= CM_reg(15);
	nP_IEN <= CM_reg(14);
	nP_OEN <= CM_reg(13);

	M_ROM <= CM_reg(11);
	nROM_EN <= CM_reg(10);
	M_uA <= CM_reg(9);
	CMROM_CS <= CM_reg(8);

end beh;

