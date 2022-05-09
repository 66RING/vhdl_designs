library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-- TODO without SN, which not use
entity alu181 is
	port(
		S: in std_logic_vector(3 downto 0);
		M: in std_logic;
		A: in std_logic_vector(7 downto 0);
		B: in std_logic_vector(7 downto 0);
		CN: in std_logic;		-- 进位输入
		Cout: out std_logic; 	-- 进位输出
		OV: out std_logic; 		-- 移除标志
		F: out std_logic_vector(7 downto 0)); 	-- 结果
end entity;

architecture bef of alu181 is
	signal A9 : std_logic_vector(9 downto 0);
	signal B9 : std_logic_vector(9 downto 0);
	signal F10 : std_logic_vector(9 downto 0);
begin
	A9 <= "00" & A ;  B9 <= "00" & B ; 
	-- with no latch
	process(M,CN,A9,B9,S)
	begin
		case S  is
			when "0000" =>  
				if M='0' then 
					F10<= A9 + CN;
				else  F10<=not A9;
				end if;
			when "0001" => 
				if M='0' then F10 <= (A9 or B9) + CN;
				else  F10<=not(A9 or B9);
				end if;
			when "0010" => 
				if M='0' then 
					F10 <= (A9 or (not B9))+ CN;
				else  F10<=(not A9) and B9;
				end if;
			when "0011" => 
				if M='0' then F10<= "0000000000" - CN;
				else  F10<="0000000000";
				end if;
			when "0100" =>
				if M='0' then F10 <= A9 + (A9 and not B9)+ CN;
				else  F10<= not (A9 and B9);
				end if;
			when "0101" =>
				if M='0' then F10 <= (A9 OR B9)+(A9 and not B9)+CN ;
				else  F10<= not B9;
				end if;
			when "0110" =>
				if M='0' then F10<=A9 -B9 - CN;
				else  F10<=A9 xor B9;
				end if;
			when "0111" =>
				if M='0' then F10<=(A9 and (not B9)) - CN;
				else  F10<=A9 and (not B9);
				end if;
			when "1000" =>
				if M='0' then F10<=A9 + (A9 and B9)+CN;
				else  F10<=(not A9) or B9;
				end if;
			when "1001" =>
				if M='0' then F10<=A9 + B9 + CN;
				else  F10<=not(A9 xor B9);
				end if;
			when "1010" =>
				if M='0' then F10 <= (A9 or (not B9))+(A9 and b9)+CN ;
				ELSE  F10<=B9;
				end if;
			when "1011" =>
				if M='0' then F10<=(A9 AND B9)- CN;
				else  F10<=A9 AND B9;
				end if;
			when "1100" =>
				if M='0' then F10 <= A9 + A9 + CN;
				else  F10<= "0000000001";
				end if;
			when "1101" =>
				if M='0' then F10 <= (A9 OR B9) + A9 + CN;
				else  F10<=A9 OR (NOT B9);
				end if;
			when "1110" =>
				if M='0' then F10 <= (A9 OR(NOT B9)) + A9 + CN;
				elSE  F10<=A9 OR B9;
				end if;
			when "1111" =>
				if M='0' then F10<=A9 -CN;
				else  F10<=A9;
				end if;
			when others  => F10<= "0000000000"; 
		end case;

	end process;
	F<= F10(7 downto 0) ;
	Cout <= F10(8) ;
	OV <= F10(9) xor F10(8) ;
end bef;
