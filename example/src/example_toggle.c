#include "example_toggle.h"

/* define a structure for holding the block local state. By assigning an
 * instance of this struct to the block private_data pointer (see init), this
 * information becomes accessible within the hook functions.
 */
struct example_toggle_info
{
        /* add custom block local data here */

        /* this is to have fast access to ports for reading and writing, without
         * needing a hash table lookup */
        struct example_toggle_port_cache ports;
};

/* init */
int example_toggle_init(ubx_block_t *b)
{
        int ret = -1;
        struct example_toggle_info *inf;

        /* allocate memory for the block local state */
        if ((inf = (struct example_toggle_info*)calloc(1, sizeof(struct example_toggle_info)))==NULL) {
                ERR("example_toggle: failed to alloc memory");
                ret=EOUTOFMEM;
                goto out;
        }
        b->private_data=inf;
        update_port_cache(b, &inf->ports);
        ret=0;
out:
        return ret;
}

/* start */
int example_toggle_start(ubx_block_t *b)
{
        /* struct example_toggle_info *inf = (struct example_toggle_info*) b->private_data; */
        int ret = 0;
        return ret;
}

/* stop */
void example_toggle_stop(ubx_block_t *b)
{
        /* struct example_toggle_info *inf = (struct example_toggle_info*) b->private_data; */
}

/* cleanup */
void example_toggle_cleanup(ubx_block_t *b)
{
        free(b->private_data);
}

/* step */
void example_toggle_step(ubx_block_t *b)
{
        /*
        struct example_toggle_info *inf = (struct example_toggle_info*) b->private_data;
        */
}

