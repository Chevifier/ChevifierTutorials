#ifndef BOUNCY_SPRITE_H
#define BOUNCY_SPRITE_H

#include <godot_cpp/classes/sprite2d.hpp>
#include <godot_cpp/variant/vector2.hpp>
#include <godot_cpp/classes/packed_scene.hpp>

namespace godot {

class BouncySprite: public Sprite2D{
    GDCLASS(BouncySprite,Sprite2D);

    public:
        double left_bounds;
        double right_bounds;
        double top_bounds;
        double buttom_bounds;
        Vector2 velocity;
        double speed;

    protected:
        static void _bind_methods();

    public:
        BouncySprite();
        ~BouncySprite();

        void set_speed(double new_speed);
        double get_speed();

        void _process(double delta) override;
};

}

#endif