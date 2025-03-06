class TOB_Rifleman : TOB_Guard
{
    override void Shoot()
    {
        A_SpawnProjectile(BulletClass, MissileHeight, 6);
        PlayShootSound();
    }

    default
    {
        Health 35;
        Obituary "%o was picked off by a rifleman.";
        MissileHeight 40;
        MaxTargetRange 8192;
        DropItem 'TOB_Rifle';

        TOB_Nazi.BulletClass 'TOB_RifleBullet';
        TOB_Nazi.ShootSound 'Weapons/EnemyRifle/Fire';
    }

    states
    {
    Spawn:
        WRMN A 0;
        goto TOB_Nazi::Spawn;
    Missile:
        "####" F 7 A_FaceTarget();
        "####" "#" 0 A_StartSound("weapons/rifle/bolt_0", CHAN_AUTO);
        "####" F 8 A_FaceTarget();
        "####" G 1 A_FaceTarget;
        "####" H 15 A_FaceTarget();
        "####" I 10 Bright Shoot();
        goto See;
    Pain:
        "####" J 0;
        goto TOB_Nazi::Pain;
    Death:
        "####" K 8 ScreamAndUnblock();
        "####" L 6;
        "####" M 3;
        "####" NO 2;
        "####" P -1 Thud();
        stop;
    }
}
