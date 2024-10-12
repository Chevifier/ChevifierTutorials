#ifndef CUSTOM_RES
#define CUSTOM_RES

#include <godot_cpp/classes/resource.hpp>

namespace godot {

class CustomResource: public Resource{
    GDCLASS(CustomResource,Resource);

    public:
        int custom_res_num;
        CustomResource();
        ~CustomResource();
        void set_custom_res_num(int _custom_res_num);
        int get_custom_res_num();

    protected:
        static void _bind_methods();
};
}

#endif