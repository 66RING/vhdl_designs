library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
-- use ieee.numeric.all;

-- �Ӽ��˳�
-- �������


entity alu is
	port(
		clk_LED : in std_logic ;
		seg_sel : out std_logic_vector(15 downto 0);
		seg_data : out std_logic_vector(7 downto 0);

		nreset: in std_logic;	-- ��λ
		M_A, M_B: in std_logic;	-- �ݴ���ѡ��
		M_F: in std_logic;		-- ����״̬�ֿ����ź�
		nALU_EN: in std_logic;	-- ALU������ʹ��
		nPSW_EN: in std_logic;	-- PSW���ʹ��
		C0: in std_logic;		-- ��λλ����
		S: in std_logic_vector(4 downto 0); 	-- �������ͺͲ���ѡ��
		F_in: in std_logic_vector(1 downto 0); 	-- ��λ����ѡ��
		-- data: inout std_logic_vector(7 downto 0); 	-- ��������
		datain: in std_logic_vector(7 downto 0); 	-- ��������
		AC: out std_logic; 	-- ���λ��־
		CY: out std_logic; 	-- ��λ��־
		ZN: out std_logic; 	-- ���־
		OV: out std_logic); -- �����־
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
			nCn: in std_logic;		-- ��λ����
			Cout: out std_logic; 		-- ��λ���
			F: out std_logic_vector(3 downto 0)); 	-- ���
	end component;

	component alu181 is
		port(
			S: in std_logic_vector(3 downto 0);
			M: in std_logic;
			A: in std_logic_vector(7 downto 0);
			B: in std_logic_vector(7 downto 0);
			CN: in std_logic;		-- ��λ����
			Cout: out std_logic; 		-- ��λ���
			OV: out std_logic; 		-- �Ƴ���־
			F: out std_logic_vector(7 downto 0)); 	-- ���
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
	signal QA:  std_logic_vector(7 downto 0); 	-- �ݴ���A
	signal QB:  std_logic_vector(7 downto 0); 	-- �ݴ���B


	signal cout1, cout2: std_logic;
	signal F1:  std_logic_vector(3 downto 0); 	-- result1
	signal F2:  std_logic_vector(3 downto 0); 	-- result2

	signal F:  std_logic_vector(7 downto 0); 	-- result
	signal CO:  std_logic;
	signal OV_out:  std_logic;
	signal Ccc:  std_logic;


begin

	led: seg_dis port map(clk_LED, not nreset, data_in_A, data_in_B, data_in_C, data_in_D, seg_sel, seg_data);

	data_in_C <= "00000000"&QA;
	data_in_D <= "00000000"&QB;


	regA_sel <= M_A and clk_LED;
	regB_sel <= M_B and clk_LED;

	regA: octal_dff port map(regA_sel, nreset, datain, QA);
	regB: octal_dff port map(regB_sel, nreset, datain, QB);

	alu1: alu181d port map(S(4 downto 1), S(0), QA(3 downto 0), QB(3 downto 0), C0, cout1, F1); 

	alu3: alu181 port map(S(4 downto 1), S(0), QA, QB, C0, cout2, OV_out, F); 


	process(clk_LED, nreset)
		variable QA_F:  std_logic_vector(7 downto 0); 	-- �ݴ���A
		variable cnt:  std_logic_vector(7 downto 0); 	-- �ݴ���A
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
		elsif clk_LED'event and clk_LED = '1' then

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


end beh;

