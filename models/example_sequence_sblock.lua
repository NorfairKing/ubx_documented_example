return block
{
      name="example_sequence",
      meta_data="",
      port_cache=true,

      types = {
      -- no types
      },

      configurations= {
      -- no configurations
      },

      ports = {
        -- I'm lost here. How do i define trigger ports?
        { name="first", in_type_name="WHAT HERE", out_type_name="WHAT HERE", doc="The first port to trigger." },
        { name="second", out_type_name="WHAT HERE", out_type_name="WHAT HERE", doc="The second port to trigger." },
      },
      
      operations = { start=true, stop=true, step=true },

}
