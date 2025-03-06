class TOB_HansGrosse : TOB_Boss
{
    override void Shoot()
    {
        A_SpawnProjectile(
            bulletClass,
            missileHeight, 24 * ((!!(level.mapTime & 2) * 2) - 1),
            flags: CMF_OFFSETPITCH,
            pitch: frandom(-2, 2));
        PlayShootSound();
    }

    default
    {
        Health 1200;
        Speed 3;
        SeeSound "TOB_HansGrosse/Sight";
        DeathSound "TOB_HansGrosse/Death";
        Obituary "%o was greeted by the warden.";
        TOB_Boss.ShootSound 'weapons/enemychaingun/fire';
        TOB_Boss.BulletClass 'TOB_BossBullet';
        +LOOKALLAROUND;
    }

    states
    {
    Spawn:
        HANS A 0;
        "####" "#" 1 A_Look();
        wait;
    See:
        "####" AAAAA 1 A_Chase();
        "####" A 2;
        "####" BBBB 1 A_Chase();
        "####" CCCCC 1 A_Chase();
        "####" C 2;
        "####" DDDD 1 A_Chase();
        loop;
    Melee:
    Missile:
        "####" E 15 A_FaceTarget();
        "####" F 5 A_FaceTarget();

        "####" GFGFGFGFGFGFGFG 2 Bright { A_FaceTarget(); Shoot(); }
        "####" E 5 Bright Shoot();

        goto See;
    Pain:
        "####" "#" 5 A_Pain();
        goto See;
    Death:
        "####" H 0;
        goto super::Death;
    Death_Normal:
        "####" H 10;
        "####" I 7;
        "####" J 5;
        "####" K -1 A_BossThud();
        stop;
    }
}

class TOB_TransGrosse : TOB_HansGrosse
{
    default
    {
        SeeSound "TOB_TransGrosse/Sight";
        DeathSound "TOB_TransGrosse/Death";
        Obituary "%o made a sprachschnitzer.";
    }

    states
    {
    Spawn:
        TRNS A 0;
        goto super::Spawn + 1;
    }
}

class TOB_GretelGrosse : TOB_HansGrosse
{
    default
    {
        SeeSound "TOB_GretelGrosse/Sight";
        DeathSound "TOB_GretelGrosse/Death";
        Obituary "%o tried to trespass.";
    }

    states
    {
    Spawn:
        GRET A 0;
        goto super::Spawn + 1;
    }
}

class TOB_DoctorSchabbs : Actor
{
    default
    {
        Obituary "%o ";
    }
}

class TOB_Hitler : Actor
{
    default
    {
        Obituary "%o saw Der Fuhrer's Face.";
    }
}

class TOB_OttoGiftmacher : Actor
{
    default
    {
        Obituary "%o ";
    }
}

class TOB_Fatface : Actor
{
    default
    {
        Obituary "%o ";
    }
}
