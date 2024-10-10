#include "BouncingSprite.hpp"

using namespace godot;

void BouncySprite::_bind_methods()
{
    /**
    Register functions to class database 
    passing the Address of the current instance's function
    */
    ClassDB::bind_method(D_METHOD("set_speed","new_speed"),&BouncySprite::set_speed);
    ClassDB::bind_method(D_METHOD("get_speed"),&BouncySprite::get_speed);
    //add property passing its setter and getter
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT,"speed"),"set_speed","get_speed");
    //create a signal passing the property/variable of type Object named node
    ADD_SIGNAL(MethodInfo("direction_changed",PropertyInfo(Variant::OBJECT,"node")));

}

BouncySprite::BouncySprite()
{
    //initailize variables
    left_bounds = 0;
    right_bounds = 1152;
    top_bounds = 0;
    buttom_bounds = 648;
    speed = 50;
    velocity = Vector2(speed, speed);
}

BouncySprite::~BouncySprite()
{
}

void BouncySprite::_process(double delta)
{
    Vector2 pos = get_position();

    Vector2 size = get_texture()->get_size();
    //if poosition.x greater than bounds minus texturessize.x/2 if true invert speed vise vera
    if (pos.x > right_bounds-size.x/2)
    {
        //check velocity.x greater than 0 prior to changing it to prevent multiple calls to emit_signal
        if(velocity.x > 0){
            emit_signal("direction_changed",this);
        }
        velocity.x = -speed;
    }
    else if (pos.x < left_bounds+size.x/2)
    {
        if(velocity.x < 0){
            emit_signal("direction_changed",this);
        }
        velocity.x = speed;
    }

    if (pos.y < top_bounds+size.y/2)
    {
        if(velocity.y < 0){
            emit_signal("direction_changed",this);
        }
        velocity.y = speed;
    }
    else if (pos.y > buttom_bounds-size.y/2)
    {
        if(velocity.y > 0){
            emit_signal("direction_changed",this);
        }
        velocity.y = -speed;
    }
    //apply velocity to position
    pos += velocity * delta;
    //set position to new adjusted position
    set_position(pos);
}

void BouncySprite::set_speed(double new_speed){
    speed = new_speed;
    //update velocity on speed change
    velocity = velocity.normalized() * speed;
}

double BouncySprite::get_speed(){
    return speed;
}