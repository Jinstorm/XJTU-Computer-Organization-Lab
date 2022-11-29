-- Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity halfadder is
  Port ( 
    S : out STD_LOGIC;
    C : out STD_LOGIC;
    A : in STD_LOGIC;
    B : in STD_LOGIC
  );

end halfadder;

architecture stub of halfadder is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
begin
end;
