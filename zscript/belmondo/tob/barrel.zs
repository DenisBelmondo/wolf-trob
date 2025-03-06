class TOB_ExplosiveBarrel : TOB_Actor
{
    default
    {
        Health 20;
        Radius 10;
        Height 42;
        Scale 1.1;

        +SOLID;
        +SHOOTABLE;
        +ACTIVATEMCROSS;
        +NOBLOOD;
        +DONTGIB;
        +NOICEDEATH;
        +OLDRADIUSDMG;
    }

    states
    {
    Spawn:
        WDRM A 1;
        loop;
    Death:
        WDRM BC 5 Bright;
        TNT1 A 0 {
            A_Explode();
            A_SpawnItemEx('TOB_MushroomExplosion');
            A_StartSound("misc/barrel/break", CHAN_AUTO);
        }
        WDRM C 5 Bright A_Quake(4, 20, 0, 512, "");
        TNT1 A 0 {
            for (let i = 0; i < 20; i++)
            {
                A_SpawnProjectile(
                    'TOB_BazookaRocketShrapnel',
                    spawnHeight: 0,
                    angle: (i / double(20)) * 360.0,
                    flags: CMF_TRACKOWNER|CMF_ABSOLUTEPITCH,
                    pitch: random(-45, 0)
                );
            }
        }
        "####" "#" 5 Bright;
        TNT1 A 15;
        TNT1 A 1050 A_BarrelDestroy();
        TNT1 A 5 A_Respawn();
        wait;
    }
}
