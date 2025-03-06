#include "zscript/belmondo/tracers/mixin.zs"

class Db_Tracers_FastProjectile : FastProjectile version("4.7")
{
    mixin Db_Tracers_Mixin;

    override void PostBeginPlay()
    {
        super.PostBeginPlay();
        Db_Tracers_Mixin_PostBeginPlay();
    }

    override void Tick()
    {
        super.Tick();
        Db_Tracers_Mixin_Tick();
    }

    default
    {
        Radius 1;
        Height 2;
        Speed 45;

        Db_Tracers_FastProjectile.PuffType 'BulletPuff';
        Db_Tracers_FastProjectile.Length 32.0;
    }
}
