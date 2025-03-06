class TOB_SuperSoldierBlood : Actor
{
    override void PostBeginPlay()
    {
        super.PostBeginPlay();

        let p = Spawn('TOB_Puff', pos, ALLOW_REPLACE);
        p.SetState(p.FindState('Crash'));
    }
}

class TOB_SuperSoldier : TOB_Boss
{
    static const Class<Ammo> ammoWhitelist[] = {
        'TOB_Clip',
        'TOB_StripperClip',
        'TOB_AssaultClip',
        'TOB_RocketAmmo',
        'TOB_FuelAmmo'
    };

    override void Shoot()
    {
        A_SpawnProjectile(
            bulletClass,
            missileHeight,
            24,
            flags: CMF_OFFSETPITCH,
            pitch: frandom(-2, 2));
        PlayShootSound();
    }

    default
    {
        BloodType 'TOB_SuperSoldierBlood';
        Health 600;
        Speed 3;
        Mass 200;
        SeeSound "TOB_SuperSoldier/Sight";
        DeathSound "TOB_SuperSoldier/Death";
        // Obituary "%o was greeted by the warden.";
        TOB_Boss.ShootSound 'TOB_BossRocket/Sight';
        TOB_Boss.BulletClass 'TOB_SmallRocket';
        +LOOKALLAROUND;
        +NOBLOODDECALS;
    }

    states
    {
    Spawn:
        WSSD A 0;
        "####" "#" 1 A_Look();
        wait;
    See:
        "####" "#" 0 A_StartSound("TOB_SuperSoldier/Step", CHAN_AUTO);
        "####" AAAAA 1 A_Chase();
        "####" A 3;
        "####" BBBB 1 A_Chase();
        "####" "#" 0 A_StartSound("TOB_SuperSoldier/Step", CHAN_AUTO);
        "####" CCCCC 1 A_Chase();
        "####" C 3;
        "####" DDDD 1 A_Chase();
        loop;
    Melee:
    Missile:
        "####" E 15 A_FaceTarget();
        "####" F 10 Bright { A_FaceTarget(); Shoot(); }
        goto See;
    Pain:
        "####" "#" 5 A_Pain();
        goto See;
    Death:
        WSSD G 5 A_Fall();
        WSSD HHHHHIIIII 5 {
            A_FaceTarget();
            A_SpawnItemEx(
                'TOB_SmallerExplosion',
                random[TOB_SuperSoldier](1, 2),
                random[TOB_SuperSoldier](-default.radius, default.radius),
                random[TOB_SuperSoldier](0, default.height));
        }
        "####" "#" 17 A_SpawnItemEx('TOB_MediumExplosion', zofs: default.height / 2);
        "####" "#" 0 A_Scream();
        "####" "#" 0 {
            if (random2[TOB_SuperSoldier]() == 255)
            {
                A_StartSound("TOB_SuperSoldier/Meme", CHAN_AUTO);
            }
            else
            {
                A_StartSound("misc/crash", CHAN_AUTO);
            }

            if (target is 'PlayerPawn')
            {
                for (let i = 0; i < ammoWhitelist.Size(); i++)
                {
                    let cls = ammoWhitelist[i];
                    let a = Ammo(target.FindInventory(cls));
                    if (a && a.amount < a.maxAmount)
                    {
                        for (let ii = 0; ii < 3; ii++)
                        {
                            A_DropItem(cls, GetDefaultByType(cls).amount);
                        }
                    }
                }
            }
        }
        "####" J 5;
        "####" K -1 A_StartSound("misc/bigbody_hard", CHAN_AUTO);
        stop;
    }
}
