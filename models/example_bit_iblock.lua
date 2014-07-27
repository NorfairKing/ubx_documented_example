return block
{
      name="example_bit",
      meta_data="An iblock that handles one bit of information",
      port_cache=true,

      types = {
    -- No special types
      },
      
      configurations= {
    -- define configuration data here. e.g. parameters to set at init
        { name="initial_value" },
      },

      ports = {
    -- define the ports for this block
        { name="value", in_type_name ="bool", out_type_name="bool", doc="bit access port" },
      },

      -- define which operations this block implements
      operations = { start=true, stop=true, step=false },

}
