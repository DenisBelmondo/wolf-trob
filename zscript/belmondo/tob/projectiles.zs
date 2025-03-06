class TOB_SmallRocket : Actor
{
    mixin TOB_Wolf3DSizedActorMixin;

    default
    {
        Radius 8;
        Height 8;
        Speed 15;
        Damage 10;
        StencilColor "FF 99 00";
        Projectile;
        +RANDOMIZE;
        +MTHRUSPECIES;
    }

    states
    {
    Spawn:
        SRKT A 3 Bright {
            A_SpawnItemEx('TOB_RocketTrail');
            RestoreRenderStyle();
        }
        "####" "#" 1 Bright {
            A_SetRenderStyle(alpha, STYLE_Stencil);
        }
        loop;
    Death:
        TNT1 A 0 A_SpawnItemEx('TOB_SmallExplosion');
        TNT1 A 7 A_QuakeEx(2, 2, 2, 7, 0, 256, "");
        stop;
    }
}
