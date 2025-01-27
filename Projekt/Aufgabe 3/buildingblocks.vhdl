-- Shift left by two
library IEEE; use IEEE.STD_LOGIC_1164.all;
entity sl2 is
    port(a: in STD_LOGIC_VECTOR(31 downto 0);
         y: out STD_LOGIC_VECTOR(31 downto 0));
end;

architecture behave of sl2 is
begin
    y <= a(29 downto 0) & "00";
end;

-- Sign extension
library IEEE; use IEEE.STD_LOGIC_1164.all; use IEEE.NUMERIC_STD.all;
entity signext is generic (width_in, width_out: integer);
    port(a: in STD_LOGIC_VECTOR(width_in-1  downto 0);
         y: out STD_LOGIC_VECTOR(width_out-1 downto 0));
end;

architecture behave of signext is
begin
	y <= std_logic_vector(resize(signed(a), width_out));
end;

-- Multiplexer
library IEEE; use IEEE.STD_LOGIC_1164.all; use IEEE.NUMERIC_STD.all;
entity mux2 is
    generic(width: integer);
    port(d0, d1:    in STD_LOGIC_VECTOR(width-1 downto 0);
         s:         in STD_LOGIC;
         y:         out STD_LOGIC_VECTOR(width-1 downto 0));
end;

architecture behave of mux2 is
begin
    y <= d0 when s = '0' else d1;
end;

library IEEE; use IEEE.STD_LOGIC_1164.all; use IEEE.NUMERIC_STD.all;
entity mux4 is
    generic(width: integer);
    port(d0, d1, d2, d3:    in STD_LOGIC_VECTOR(width-1 downto 0);
         s:         in STD_LOGIC_VECTOR(1 downto 0);
         y:         out STD_LOGIC_VECTOR(width-1 downto 0));
end;

architecture behave of mux4 is
	component mux2 generic(width: integer);
		port(d0, d1: in STD_LOGIC_VECTOR(width-1 downto 0);
			 s: 	 in STD_LOGIC;
			 y:		 out STD_LOGIC_VECTOR(width-1 downto 0));
	end component;
	signal res1, res2: STD_LOGIC_VECTOR(width-1 downto 0);
begin
	my_mux1: mux2 generic map(width => width) port map(d0, d1, s(0), res1);
	my_mux2: mux2 generic map(width => width) port map(d2, d3, s(0), res2);
	my_mux3: mux2 generic map(width => width) port map(res1, res2, s(1), y);
end;
