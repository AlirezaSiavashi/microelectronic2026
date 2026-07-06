library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.math_real.all; 
use IEEE.numeric_std.all; 

--------------------------------------------------------------------------------
--!@file: TB_mult_rtl.vhd
--!@brief: testbench for the rtl description of the multiplier
--!...
--
--!@author: Tobias Koal(TK)
--!@revision info :
-- last modification by tkoal(TK)
-- Mon Mar  4 09:49:47 CET 2013
--------------------------------------------------------------------------------

-- entity description

entity TB_mult_rtl is
end entity;

-- architecture description

architecture testbench of TB_mult_rtl is


	-- CONSTANTS (upper case only!)
	CONSTANT CYCLE_TIME  : time := 1.0 ns;
	CONSTANT RESET_TIME  : time := 4*CYCLE_TIME + CYCLE_TIME / 5.0;

	-- SIGNALS (lower case only!)
	signal s_a, s_b						:	unsigned(19 downto 0) := (others => '0');
	signal s_z,	s_z_golden, s_z_golden_buf				:	unsigned(39 downto 0) := (others => '0');
	signal reset, clk, ready, enable	:	std_logic;

begin

	-- put your code here!
	tb_component : entity work.mult_rtl(behave)
	port map (
				a => s_a,
				b => s_b,
				z => s_z,
				clk => clk,
				reset => reset,
				ready => ready,
				enable => enable
		  );


	-- create a stimulus process here!
	stimulus : process is
		variable seed1,seed2 : positive := 1;
		variable a_real, b_real : real := 0.0;
	begin
		enable <= '0';
		wait for RESET_TIME;
		loop
			wait until ready = '1';
			-- create random numbers
			uniform (seed1, seed2, a_real);
			uniform (seed1, seed2, b_real);
			-- convert random number from real to std_logic_vector
			s_a <= to_unsigned(integer(a_real * 2.0**20),20);
			s_b <= to_unsigned(integer(b_real * 2.0**20),20);
			wait for CYCLE_TIME/2;
			enable <= '1';
			wait for CYCLE_TIME;
			enable <= '0';
		end loop;
	end process;

	-- create golden device
	gold_dev : process is
	begin
		wait for RESET_TIME;
		loop
			wait until ready = '1';
			s_z_golden <= s_a * s_b;
			wait for CYCLE_TIME;
		end loop;
	end process;

	-- observe functionality
	obs : process is
	begin
		wait for RESET_TIME;
		loop
			wait until ready = '1';
			wait for CYCLE_TIME / 2;
			assert s_z_golden = s_z
			report "golden vector missmatch! end simulation!"
			severity error;
			wait for CYCLE_TIME / 2;
		end loop;
	end process;

	-- create a clk driver here!
	clk_process : process is
	begin
		clk <= '1';
		wait for CYCLE_TIME *0.5;
		clk <= '0';
		wait for CYCLE_TIME *0.5;
	end process;

	-- create a reset driver here!
	reset <= '1' , '0' after RESET_TIME;

end testbench;

