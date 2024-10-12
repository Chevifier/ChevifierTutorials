
#include "PropertiesExport.h"
#include <godot_cpp/classes/sprite2d.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

void PropertiesExport::_bind_methods()
{
    // Register Properties
    ClassDB::bind_method(D_METHOD("set_number", "_number"), &PropertiesExport::set_number);
    ClassDB::bind_method(D_METHOD("get_number"), &PropertiesExport::get_number);
    ADD_PROPERTY(PropertyInfo(Variant::INT, "number"), "set_number", "get_number");
    // Number with range
    ClassDB::bind_method(D_METHOD("set_ranged_number", "_ranged_number"), &PropertiesExport::set_ranged_number);
    ClassDB::bind_method(D_METHOD("get_ranged_number"), &PropertiesExport::get_ranged_number);
    ADD_PROPERTY(PropertyInfo(Variant::INT, "ranged_number", PROPERTY_HINT_RANGE, "0,256,1"), "set_ranged_number", "get_ranged_number");
    // String Property
    ClassDB::bind_method(D_METHOD("set_string", "_string"), &PropertiesExport::set_string);
    ClassDB::bind_method(D_METHOD("get_string"), &PropertiesExport::get_string);
    ADD_PROPERTY(PropertyInfo(Variant::STRING, "string"), "set_string", "get_string");
    // Node Path
    ClassDB::bind_method(D_METHOD("set_node_path", "_node_path"), &PropertiesExport::set_node_path);
    ClassDB::bind_method(D_METHOD("get_node_path"), &PropertiesExport::get_node_path);
    ADD_PROPERTY(PropertyInfo(Variant::NODE_PATH, "node_path"), "set_node_path", "get_node_path");
    // Boolean
    ClassDB::bind_method(D_METHOD("set_some_bool", "_some_bool"), &PropertiesExport::set_some_bool);
    ClassDB::bind_method(D_METHOD("get_some_bool"), &PropertiesExport::get_some_bool);
    ADD_PROPERTY(PropertyInfo(Variant::BOOL, "some_bool"), "set_some_bool", "get_some_bool");
    // Dictionary
    ClassDB::bind_method(D_METHOD("set_dict", "_dict"), &PropertiesExport::set_dict);
    ClassDB::bind_method(D_METHOD("get_dict"), &PropertiesExport::get_dict);
    ADD_PROPERTY(PropertyInfo(Variant::DICTIONARY, "dict"), "set_dict", "get_dict");
    // Resource
    ClassDB::bind_method(D_METHOD("set_res", "_res"), &PropertiesExport::set_res);
    ClassDB::bind_method(D_METHOD("get_res"), &PropertiesExport::get_res);
    ADD_PROPERTY(PropertyInfo(Variant::OBJECT, "res", PROPERTY_HINT_RESOURCE_TYPE, "Resource"), "set_res", "get_res");
    // Custom Resource
    ClassDB::bind_method(D_METHOD("set_custom_res", "_custom_res"), &PropertiesExport::set_custom_res);
    ClassDB::bind_method(D_METHOD("get_custom_res"), &PropertiesExport::get_custom_res);
    ADD_PROPERTY(PropertyInfo(Variant::OBJECT, "custom_res", PROPERTY_HINT_RESOURCE_TYPE, "CustomResource"), "set_custom_res", "get_custom_res");
    // PackedScene
    ClassDB::bind_method(D_METHOD("set_scene", "p_scene"), &PropertiesExport::set_scene);
    ClassDB::bind_method(D_METHOD("get_scene"), &PropertiesExport::get_scene);
    ADD_PROPERTY(PropertyInfo(Variant::OBJECT, "example_scene", PROPERTY_HINT_RESOURCE_TYPE, "PackedScene"), "set_scene", "get_scene");
}

PropertiesExport::PropertiesExport()
{
    number = 0;
    ranged_number = 0;
    string = "Some String";
}

PropertiesExport::~PropertiesExport()
{
}

void PropertiesExport::_ready()
{
    // Instance a Packed Scene
    // NOTE _ready gets call in editor. Editor will crash if loading scene without null check
    if (example_scene == nullptr)
    {
        return;
    }
    // Instantiate Scene
    Node *inst = example_scene->instantiate();
    // Type checking
    if (typeid(*inst) == typeid(Sprite2D))
    {
        UtilityFunctions::print("Node is a Sprite 2D");
    }
    else
    {
        UtilityFunctions::print("Node is NOT a Sprite 2D");
    }
    // add instanced scene
    add_child(inst);
    // Print name for no reason :)
    UtilityFunctions::print(inst->get_name());
}

void PropertiesExport::set_number(int _number)
{
    number = _number;
}

int PropertiesExport::get_number()
{
    return number;
}
void PropertiesExport::set_ranged_number(int _ranged_number)
{
    ranged_number = _ranged_number;
}

int PropertiesExport::get_ranged_number()
{
    return ranged_number;
}

void PropertiesExport::set_string(String _string)
{
    string = _string;
}
String PropertiesExport::get_string()
{
    return string;
}

void PropertiesExport::set_node_path(NodePath _node_path)
{
    node_path = _node_path;
}
NodePath PropertiesExport::get_node_path()
{
    return node_path;
}

void PropertiesExport::set_some_bool(bool _some_bool)
{
    some_bool = _some_bool;
}
bool PropertiesExport::get_some_bool()
{
    return some_bool;
}
void PropertiesExport::set_dict(Dictionary _dict)
{
    dict = _dict;
}
Dictionary PropertiesExport::get_dict()
{
    return dict;
}

void PropertiesExport::set_res(Ref<Resource> _res)
{
    res = _res;
}
Ref<Resource> PropertiesExport::get_res()
{
    return res;
}

void PropertiesExport::set_custom_res(Ref<CustomResource> _custom_res)
{
    custom_res = _custom_res;
}

Ref<CustomResource> PropertiesExport::get_custom_res()
{
    return custom_res;
}

void PropertiesExport::set_scene(Ref<PackedScene> p_scene)
{
    example_scene = p_scene;
}

Ref<PackedScene> PropertiesExport::get_scene()
{
    return example_scene;
}
