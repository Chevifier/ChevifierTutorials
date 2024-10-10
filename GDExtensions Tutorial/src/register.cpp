#include "register.hpp"


#include "BouncingSprite.hpp"

#include "gdextension_interface.h"
#include "godot_cpp/core/defs.hpp"
#include "godot_cpp/godot.hpp"


using  namespace godot;

//initializer for registering classes
void initailize(ModuleInitializationLevel p_level){
    if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE){
        return;
    }

    GDREGISTER_CLASS(BouncySprite);

}
//deinitializer
void uninitailize(ModuleInitializationLevel p_level){
    if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE){
        return;
    }
}

//entry point function for godot
extern "C" {
    GDExtensionBool GDE_EXPORT library_init(GDExtensionInterfaceGetProcAddress p_get_proc_address,
     const GDExtensionClassLibraryPtr p_library, GDExtensionInitialization * r_initailization){
        godot::GDExtensionBinding::InitObject init_obj(p_get_proc_address,p_library,r_initailization);

        init_obj.register_initializer(initailize);
        init_obj.register_terminator(uninitailize);
        init_obj.set_minimum_library_initialization_level(MODULE_INITIALIZATION_LEVEL_SCENE);

        return init_obj.init();
     }
}