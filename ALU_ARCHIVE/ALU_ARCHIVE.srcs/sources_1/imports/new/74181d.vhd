library ieee;
use ieee.std_logic_1164.all;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;


-- TODO without SN, which not use
entity alu181d is
	port(
		S: in std_logic_vector(3 downto 0);
		M: in std_logic;
		A: in std_logic_vector(3 downto 0);
		B: in std_logic_vector(3 downto 0);
		nCn: in std_logic;		-- 进位输入
		Cout: out std_logic; 		-- 进位输出
		F: out std_logic_vector(3 downto 0)); 	-- 结果
end entity;

-- TODO
architecture bef of alu181d is
	signal A5 : std_logic_vector(4 downto 0);
	signal B5 : std_logic_vector(4 downto 0);
	signal F5 : std_logic_vector(4 downto 0);

	signal Cn : std_logic;
begin

	Cn <= not nCn;

	A5 <= '0' & A ;  B5 <= '0' & B ; 
	process(M,Cn,A5,B5,S)
	begin
		case S  is
			when "0000" =>  
				if M='0' then 
					F5<=A5 + not Cn;
				else  F5<= not A5;
				end if;
			when "0001" => 
				if M='0' then F5<= (A5 or B5) + not Cn;
				else  F5<= not(A5 or B5);
				end if;
			when "0010" => 
				if M='0' then 
					F5<= (A5 or (not B5)) + not Cn;
				else  F5<= (not A5) and B5;
				end if;
			when "0011" => 
				-- TODO 补码?
				if M='0' then F5<= "00000" - not Cn;
				else  F5<="00000";
				end if;
			when "0100" =>
				if M='0' then F5<= A5+(A5 and not B5) + not Cn;
				else  F5<= not (A5 and B5);
				end if;
			when "0101" =>
				if M='0' then F5<=(A5 OR B5)+(A5 and not B5) + not Cn ;
				else  F5<= not B5;
				end if;
			when "0110" =>
				-- TODO 补码?
				if M='0' then F5 <= A5 - B5 - Cn;
				else  F5 <= A5 xor B5;
				end if;
			when "0111" =>
				if M='0' then F5 <= (A5 and (not B5)) - Cn;
				else  F5<= A5 and (not B5);
				end if;
			when "1000" =>
				-- TODO diff
				if M='0' then F5<= A5 + (A5 and B5) + not Cn;
				else  F5<= (not A5) or B5;
				end if;
			when "1001" =>
				if M='0' then F5<= A5 + B5 + not Cn;
				else  F5<= not(A5 xor B5);
				end if;
			when "1010" =>
				if M='0' then F5 <= (A5 or (not B5)) + (A5 and B5) + not Cn ;
				ELSE  F5 <= B5;
				end if;
			when "1011" =>
				if M='0' then F5<= (A5 and B5) - Cn;
				else  F5<= A5 and B5;
				end if;
			when "1100" =>
				if M='0' then F5<= A5 + A5 + not Cn;
				else  F5<= "00001";
				end if;
			when "1101" =>
				if M='0' then F5<= (A5 or B5) + A5 + not Cn;
				else  F5<=A5 or (not B5);
				end if;
			when "1110" =>
				if M='0' then F5 <= (A5 or (not B5)) + A5 + not Cn;
				elSE  F5<= A5 or B5;
				end if;
			when "1111" =>
				if M='0' then F5 <= A5 - Cn;
				else  F5<= A5;
				end if;
			when others  => F5<= "00000"; 
		end case;

	end process;
	F<= F5(3 downto 0) ; 
	Cout <= F5(4) ;
end bef;

