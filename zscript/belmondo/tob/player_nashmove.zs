mixin class TOB_NashMovePlayerMixin
{
    // nashmove
    const TOB_NashMoveMixin__DECEL_MUL = 0.8;

    void TOB_NashMoveMixin__BeforeTick()
    {
        if (player.onGround)
        {
            // [nash] bump up the player's speed to compensate for the
            //        deceleration
            // [nash] TO DO: math here is shit and wrong, please fix
            double s = 1.0 + (1.0 - TOB_NashMoveMixin__DECEL_MUL);
            speed = s * 2;

            vel.x *= TOB_NashMoveMixin__DECEL_MUL;
            vel.y *= TOB_NashMoveMixin__DECEL_MUL;

            // [nash] make the view bobbing match the player's movement
            ViewBob = TOB_NashMoveMixin__DECEL_MUL;
        }
    }
}
