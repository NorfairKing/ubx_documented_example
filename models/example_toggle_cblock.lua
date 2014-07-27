return block
{
      name="example_toggle",
      meta_data="A toggle cblock",
      port_cache=true,

      types = {
      -- no types
      },

      configurations= {
      -- no configurations
      },

      ports = {
        { name="toggle", out_type_name="bool", doc="bit to toggle" },
      },
      
      operations = { start=true, stop=true, step=true }
}
