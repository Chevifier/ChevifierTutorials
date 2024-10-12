#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/variant/string.hpp>
#include <godot_cpp/variant/node_path.hpp>
#include <godot_cpp/variant/dictionary.hpp>
#include <godot_cpp/classes/resource.hpp>
#include <godot_cpp/classes/packed_scene.hpp>
#include "CustomResource.h"

namespace godot{

class PropertiesExport: public Node {
    GDCLASS(PropertiesExport, Node);


protected:
    static void _bind_methods();

public:
    int number;
    int ranged_number;
    String string;
    NodePath node_path;
    bool some_bool;
    Dictionary dict;
    Ref<Resource> res;
    Ref<CustomResource> custom_res;
    Ref<PackedScene> example_scene;
    PropertiesExport();
    ~PropertiesExport();

    void _ready() override;

    void set_number(int _number);
    int get_number();

    void set_ranged_number(int _number);
    int get_ranged_number();
    
    void set_string(String _string);
    String get_string();

    void set_node_path(NodePath _node_path);
    NodePath get_node_path();

    void set_some_bool(bool _some_bool);
    bool get_some_bool();

    void set_dict(Dictionary _dict);
    Dictionary get_dict();

    void set_res(Ref<Resource> _res);
    Ref<Resource> get_res();

    void set_custom_res(Ref<CustomResource> custom_res);
    Ref<CustomResource> get_custom_res();

    void set_scene(Ref<PackedScene> p_scene);
    Ref<PackedScene> get_scene();

};

}