class TOB_FakeHitlerFireball : Actor
{
    default
    {
        Radius 6;
        Height 8;
        Speed 18;
        DamageFunction random[MissileDamage](0, 31);
        RenderStyle "Add";
        Projectile;
        -BLOODLESSIMPACT;
    }

    states
    {
    Spawn:
        WFBL ABC 3 Bright;
        loop;
    Death:
        WFBL DEFGH 3 Bright;
        stop;
    }
}

class TOB_FakeHitler : TOB_Monster
{
    mixin TOB_Wolf3DSizedActorMixin;

    default
    {
        Health 400;
        Radius 31;
        Height 56;
        Mass 400;
        Speed 3;
        PainChance 128;
        SeeSound "TOB_FakeHitler/Sight";
        DeathSound "TOB_FakeHitler/Death";
        Monster;

        +FLOAT;
        +NOGRAVITY;
        +NOBLOOD;
        +FLOATBOB;
    }

    states
    {
    Spawn:
        FAKE A 5 Look();
        "####" A 6 Look();
        "####" C 7 Look();
        "####" D 4 Look();
        loop;
    See:
        "####" AAAAA 1 Chase();
        "####" A 2;
        "####" BBBB 1 Chase();
        "####" CCCCC 1 Chase();
        "####" C 2;
        "####" DDDD 1 Chase();
        loop;
    Missile:
        FAKE E 8 Bright A_FaceTarget();
        FAKE EEE 4 Bright {
            A_FaceTarget();
            A_SpawnProjectile('TOB_FakeHitlerFireball');
            A_StartSound("TOB_FakeHitler/Shoot", CHAN_WEAPON);
        }
        goto See;
    Death:
        TNT1 A 0 {
            bFloatBob = false;
        }
        FAKE F 5 ScreamAndUnblock();
        FAKE G 5;
        FAKE HIJ 5;
        FAKE K -1;
        stop;
    }
}
