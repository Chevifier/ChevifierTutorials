#include "CustomResource.h"

using namespace godot;

void CustomResource::_bind_methods()
{
    ClassDB::bind_method(D_METHOD("set_custom_res_num", "_custom_res_num"), &CustomResource::set_custom_res_num);
    ClassDB::bind_method(D_METHOD("get_custom_res_num"), &CustomResource::get_custom_res_num);

    ADD_PROPERTY(PropertyInfo(Variant::INT, "custom_res_num"), "set_custom_res_num", "get_custom_res_num");
}
CustomResource::CustomResource()
{
    custom_res_num = 0;
}

CustomResource::~CustomResource() {}

void CustomResource::set_custom_res_num(int _custom_res_num)
{
    custom_res_num = _custom_res_num;
}
int CustomResource::get_custom_res_num()
{
    return custom_res_num;
}