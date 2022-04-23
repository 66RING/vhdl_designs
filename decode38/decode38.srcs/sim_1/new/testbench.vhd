library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


--this is how entity for your test bench code has to be declared.
entity testbench is
end testbench;

architecture behavior of testbench is
	--signal declarations.
	signal en : std_logic := '1';
	signal A, B, C: std_logic;
	signal Y :  std_logic_vector(7 downto 0) :=(others => '0');
	signal input: std_logic_vector(2 downto 0);
begin
	--entity instantiation
	UUT : entity work.decoder38_1 port map(EN, A, B, C, Y);
	
	--definition of simulation process
	tb : process 
	begin
		input<="000";  --input = 0.
		EN <= '0';
		wait for 20 ns;
		input<="001";   --input = 1.
		wait for 20 ns;
		input<="010";   --input = 2.
		wait for 20 ns;
		input<="011";   --input = 3.
		wait for 20 ns;
		EN <= '1';
		input<="100";   --input = 4.
		wait for 20 ns;
		input<="101";   --input = 5.
		wait for 20 ns;
		input<="110";   --input = 6.
		wait for 20 ns;
		input<="111";   --input = 7.
		wait;
	end process tb;

	A <= input(0);
	B <= input(1);
	C <= input(2);

end;
