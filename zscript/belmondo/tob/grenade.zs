class TOB_Grenade : Actor
{
    default
    {
        Radius 8;
        Height 8;
        Speed 35;
        BounceFactor 0.5;
        WallBounceFactor 0.25;

        BounceType 'Doom';
        BounceSound "weapons/grenade/bounce";
        Obituary "$OB_GRENADE"; // "%o caught %k's grenade."
        DamageType 'Grenade';

        Projectile;
        -NOGRAVITY;
        +RANDOMIZE;
        +FORCEXYBILLBOARD;
        +BOUNCEONCEILINGS;
        +BOUNCEONFLOORS;
        +EXPLODEONWATER;
    }

    states
    {
    Spawn:
        WGND ABCDEF 4 A_AlertMonsters(64);
        loop;
    Death:
        "####" "#" 20;
        TNT1 A 4 {
            A_SpawnItemEx('TOB_GroundExplosion');
            A_Explode(100, 256, XF_HURTSOURCE|XF_THRUSTZ, true, 1);
            A_QuakeEx(2, 2, 2, 10, 0, 2048, flags: QF_SCALEDOWN, falloff: 512);
            A_AlertMonsters();
        }
        TNT1 A 6 {
            let frags = 10;

            for (let i = 0; i < frags; i++)
            {
                A_SpawnProjectile(
                    'TOB_BazookaRocketShrapnel',
                    spawnHeight: 0,
                    angle: (i / double(frags)) * 360.0,
                    flags: CMF_TRACKOWNER|CMF_ABSOLUTEPITCH,
                    pitch: random(-45, 0)
                );
            }
        }
        stop;
    }
}

class TOB_TeslaGrenade : TOB_Grenade
{
    override void Tick()
    {
        super.Tick();

        if (level.mapTime & 3)
        {
            RestoreRenderStyle();
        }
        else
        {
            bBright = true;
            A_SetRenderStyle(alpha, STYLE_Stencil);
        }
    }

    default
    {
        StencilColor '20 60 FF';
    }

    states
    {
    Spawn:
        TGRN ABCD 3 A_AlertMonsters(64);
        "####" "#" 0 {
            A_SpawnItemEx('TOB_ZapSmall1');
            A_StartSound("weapons/tesla/idle", CHAN_AUTO);
        }
        "####" EFGH 3 A_AlertMonsters(64);
        loop;
    Death:
        "####" "#" 20;
        TNT1 A 4 {
            A_SpawnItemEx('TOB_TeslaExplosion');
            A_Explode(100, 256, XF_HURTSOURCE|XF_THRUSTZ, true, 1);
            A_QuakeEx(2, 2, 2, 10, 0, 2048, flags: QF_SCALEDOWN, falloff: 512);
            A_AlertMonsters();
        }
        stop;
    }
}
