library IEEE;
use IEEE.std_logic_1164.all; -- import std_logic types
use IEEE.numeric_std.all; -- for type conversion to_unsigned

--library STD;
--use STD.textio.all;

--------------------------------------------------------------------------------
--!@file: mult_rtl.vhd
--!@brief: this is a simple multiplier description (generic) and iterativ
--!...
--
--!@author: Tobias Koal(TK)
--!@revision info :
-- last modification by tkoal(TK)
-- Fri Jul  1 15:46:21 CEST 2011
--------------------------------------------------------------------------------

-- entity description

entity mult_rtl is
port(
		a, b	:	IN	unsigned(19 downto 0);
		z		:	OUT	unsigned(39 downto 0);
		clk, reset : IN std_logic;
		enable	:	IN	std_logic;
		ready	:	OUT	std_logic
);
end entity;

-- architecture description

architecture behave of mult_rtl is


begin

	mult_proc : process (clk,reset)
		variable z_intern, a_intern :	unsigned(39 downto 0);
		variable a_buf, b_buf		:	unsigned(19 downto 0);
		variable count				:	natural;
	begin
		if reset = '1' then
			ready 		<= '1';
			z 			<= (others => '0');
			z_intern	:=	(others => '0');
			a_intern	:=	(others => '0');
			a_buf		:=	(others => '0');
			b_buf		:=	(others => '0');
			count		:=	0;
		elsif rising_edge(clk) then 
			if enable = '1' then
				z_intern := (others => '0');
				count	:= 0;
				a_buf	:= a;
				b_buf	:= b;
				ready	<= '0';
			elsif count < 20 then
				ready	<= '0';
				if b_buf(count) = '1' then
					a_intern := (others => '0');
					a_intern(count+19 downto count)	:= a_buf(19 downto 0);
					z_intern := z_intern + a_intern;
				end if;
				count	:= count + 1;
			elsif count = 20 then
				z <= z_intern;
				ready <= '1';
			end if;
		end if;
	end process;

end behave;

