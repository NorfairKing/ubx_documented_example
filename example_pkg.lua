return pkg
{
  name="ubx_example",
  path="../",

  dependencies = {
-- no dependencies
  },

  types = {
-- no types
  },

  blocks = {
-- define the blocks of your package, e.g. a sender and a receiver block
    { name="example_bit", file="example_bit_iblock.lua", src_dir="src" },
    { name="example_toggle", file="example_toggle_cblock.lua", src_dir="src" },
    { name="example_sequence", file="example_sequence_sblock.lua", src_dir="src" },
    { name="example_bitprinter", file="example_bitprinter_cblock.lua", src_dir="src" },
  },

  libraries = {
-- define the libraries. Preferably 1 library per block
    { name="example_bit", blocks={"example_bit"} },
    { name="example_toggle", blocks={"example_toggle"} },
    { name="example_sequence", blocks={"example_sequence"} },
  },
}
