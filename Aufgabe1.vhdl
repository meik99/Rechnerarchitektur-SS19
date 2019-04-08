

-- Start Full Adder

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity FA is
  port(
    a, b, cin: in STD_LOGIC;
    cout, s: out STD_LOGIC
  );
end FA;

architecture behaviour of FA is
begin
  s <= a xor b xor cin;
  cout <= (a and b) or (b and cin) or (a and cin);
end behaviour ;

-- End Full Adder

-- Start 2to1 Mux
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity TwoToOneMux is
  port(
    a, b, sel: in STD_LOGIC;
    s: out STD_LOGIC
  );
end TwoToOneMux;

architecture behaviour of TwoToOneMux is
begin
  s <= (a and not sel) or (b and sel);
end behaviour;

-- End 2to1 Mux

-- Start 4to2 Mux
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity FourToTwoMux is
  port(
    a, b, x, y, sel: in STD_LOGIC;
    s, c: out STD_LOGIC
  );
end FourToTwoMux;

architecture behaviour of FourToTwoMux is
  component TwoToOneMux
  port(
    a, b, sel: in STD_LOGIC;
    s: out STD_LOGIC
  );
  end component;
begin
  mux0: TwoToOneMux
  port map(a => a, b => b, sel => sel, s => s);

  mux1: TwoToOneMux
  port map(a => x, b => y, sel => sel, s => c);
end behaviour;
-- End 4to2 Mux

-- Start CAS2Bit
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity CAS2Bit is
  port(
    a, b: in std_logic_vector(1 downto 0);
    cin: std_logic;
    sum: out std_logic_vector(1 downto 0);
    cout: std_logic
  );
end CAS2Bit;

architecture behaviour of CAS2Bit is
  component FA
    port(
      a, b, cin: in STD_LOGIC;
      cout, s: out STD_LOGIC
    );
  end component;
  component FourToTwoMux
    port(
      a, b, x, y, sel: in STD_LOGIC;
      s, c: out STD_LOGIC
    );
  end component;

  signal s0, c0, s1, c1: std_logic_vector(1 downto 0);
  signal carry: std_logic;
begin
  fa0_0: FA
  port map(a => a(0), b => b(0), cin => '0', s => s0(0), cout => c0(0));

  fa0_1: FA
  port map(a => a(0), b => b(0), cin => '1', s => s1(0), cout => c1(0));

  fa1_0: FA
  port map(a => a(1), b => b(1), cin => '0', s => s0(1), cout => c0(1));

  fa1_1: FA
  port map(a => a(1), b => b(1), cin => '1', s => s1(1), cout => c1(1));

  mux0: FourToTwoMux
  port map(a => s0(0), b => s1(0), x => c0(0), y => c1(0), sel => cin, s => sum(0), c => carry);

  mux1: FourToTwoMux
  port map(a => s0(1), b => s1(1), x => c0(1), y => c1(1), sel => carry, s => sum(1), c => cout);
end behaviour ; -- behaviour
-- End CAS2Bit

-- Start SixToThreeMux
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity SixToThreeMux is
  port(
    a, b: std_logic_vector(1 downto 0);
    c0, c1: std_logic;
    s: std_logic_vector(1 downto 0);
    c: std_logic;
    sel: std_logic
  );
end SixToThreeMux;

architecture behaviour of SixToThreeMux is 
  component FourToTwoMux
    port(
      a, b, x, y, sel: in STD_LOGIC;
      s, c: out STD_LOGIC
    );
  end component;
  component TwoToOneMux
    port(
      a, b, sel: in STD_LOGIC;
      s: out STD_LOGIC
    );
  end component;
begin
  mux0: FourToTwoMux
  port map(a => a(0), b => b(0), x => a(1), y => b(1), sel => sel, s => s(0), c => s(1));

  mux1: TwoToOneMux
  port map(a => c0, b => c1, sel => sel, s => c);
end behaviour ; -- behaviour
-- End SixToThreeMux

-- Start TenToFiveMux

entity TenToFiveMux is
  port(
    a, b: in std_logic_vector(3 downto 0);
    x, y: in std_logic;
    s: out std_logic_vector(3 downto 0);
    c: out std_logic;
    sel: in std_logic
  );
end TenToFiveMux;

architecture behaviour of TenToFiveMux is
  component TwoToOneMux
  port(
    a, b, sel: in STD_LOGIC;
    s: out STD_LOGIC
  );
  end component;
begin
  for i in 0 to 3 loop
    mux: TwoToOneMux
    port map(a => a(i), b => b(i), sel => sel, s => s(i));
  end loop;

  mux_c: TwoToOne
  port map(a => x, b => y, sel => sel, s => c);
end behaviour ; -- behaviour
-- End TenToFiveMux

-- Start CAS4Bit
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity CAS4Bit is
  port(
    a, b: in std_logic_vector(3 downto 0);
    cin: std_logic;
    sum: out std_logic_vector(3 downto 0);
    cout: std_logic
  );
end CAS4Bit;

architecture behaviour of CAS4Bit is
  component CAS2Bit
    port(
      a, b: in std_logic_vector(1 downto 0);
      cin: std_logic;
      sum: out std_logic_vector(1 downto 0);
      cout: std_logic
    );
  end component;
  component FourToTwoMux
    port(
      a, b, x, y, sel: in STD_LOGIC;
      s, c: out STD_LOGIC
    );
  end component;
  component SixToThreeMux
    port(
      a, b: std_logic_vector(1 downto 0);
      c0, c1: std_logic;
      s: std_logic_vector(1 downto 0);
      c: std_logic;
      sel: std_logic
    );
  end component;
  signal s0_0, s0_1, s1_0, s1_1: std_logic_vector(1 downto 0);
  signal c0, c1: std_logic_vector(1 downto 0);
  signal carry: std_logic;
begin

  cas20_0: CAS2Bit
  port map(a => a(1 downto 0), b => b(1 downto 0), cin => '0', sum => s0_0, cout => c0(0));

  cas20_1: CAS2Bit
  port map(a => a(1 downto 0), b => b(1 downto 0), cin => '1', sum => s0_1, cout => c1(0));

  cas21_0: CAS2Bit
  port map(a => a(3 downto 2), b => b(3 downto 2), cin => '0', sum => s1_0, cout => c0(1));

  cas22_1: CAS2Bit
  port map(a => a(3 downto 2), b => b(3 downto 2), cin => '1', sum => s1_1, cout => c1(1));

  mux0: SixToThreeMux
  port map(a => s0_0, b => s0_1, c0 => c0(0), c1 => c1(0), s => sum(1 downto 0), c => carry, sel => cin);

  mux1: SixToThreeMux
  port map(a => s1_0, b => s1_1, c0 => c0(1), c1 => c1(1), s => sum(3 downto 2), c => cout, sel => carry);
end behaviour ; -- behaviout
-- End CAS4Bit

-- Conditional Sum Adder for 8 BITS

library IEEE; 
use IEEE.STD_LOGIC_1164.all;

entity adder is
  port(a,b:  in STD_LOGIC_VECTOR(7 downto 0);
       cin:  in STD_LOGIC;
 	   cout: out STD_LOGIC;
       sum:  out STD_LOGIC_VECTOR(7 downto 0));
end;

architecture behaviour of adder is
  component CAS4Bit
    port(
      a, b: in std_logic_vector(3 downto 0);
      cin: std_logic;
      sum: out std_logic_vector(3 downto 0);
      cout: std_logic
    );
  end component;
  component TenToFiveMux
    port(
      a, b: in std_logic_vector(3 downto 0);
      x, y: in std_logic;
      s: out std_logic_vector(3 downto 0);
      c: out std_logic;
      sel: in std_logic
    );
  end component;
begin
  
end behaviour ; -- behaviour

-- End CAS8Bit


-- Testbench

library IEEE; use IEEE.STD_LOGIC_1164.all; use IEEE.STD_LOGIC_UNSIGNED.all; use IEEE.NUMERIC_STD.all;

entity testbench is
end;

architecture test of testbench is
  component adder
    port(a, b: in STD_LOGIC_VECTOR(7 downto 0);
         cin:  in STD_LOGIC;
		 cout: out STD_LOGIC;
         sum:  out STD_LOGIC_VECTOR(7 downto 0));
  end component;
  signal a, b:  STD_LOGIC_VECTOR(7 downto 0);
  signal y:     STD_LOGIC_VECTOR(8 downto 0);
begin
      my_add: adder port map(a, b, '0', y(8), y(7 downto 0));

    process begin
      a <= STD_LOGIC_VECTOR(TO_UNSIGNED(15, a'length));
      b <= STD_LOGIC_VECTOR(TO_UNSIGNED(10, b'length));
      wait for 40 ns;
      report "15 + 10 = " & integer'image(to_integer(unsigned(y)));

      a <= STD_LOGIC_VECTOR(TO_UNSIGNED(11, a'length));
      b <= STD_LOGIC_VECTOR(TO_UNSIGNED(2, b'length));
      wait for 40 ns;
      report "11 + 2 = " & integer'image(to_integer(unsigned(y)));

      a <= STD_LOGIC_VECTOR(TO_UNSIGNED(19, a'length));
      b <= STD_LOGIC_VECTOR(TO_UNSIGNED(46, b'length));
      wait for 40 ns;
      report "19 + 46 = " & integer'image(to_integer(unsigned(y)));

	  for aa in 0 to 255 loop
		for bb in 0 to 255 loop
			a <= STD_LOGIC_VECTOR(TO_UNSIGNED(aa, a'length));
     		b <= STD_LOGIC_VECTOR(TO_UNSIGNED(bb, b'length));
			wait for 5 ns;
			if (aa + bb /= to_integer(unsigned(y))) then
				report integer'image(aa) & " + " & integer'image(bb) & " = " & integer'image(to_integer(unsigned(y))) severity error;
			    wait;
			end if;
		end loop;
	  end loop;
      wait;
    end process;
end;
