class TOB_SSGuard : TOB_Nazi
{
    virtual void FaceTargetAndPlayShootSound()
    {
        A_FaceTarget();
        PlayShootSound();
    }

    override void Shoot()
    {
        A_SpawnProjectile(bulletClass, missileHeight, 6);
        PlayShootSound();
    }

    default
    {
        Health 100;
        Speed 4;

        DropItem    'TOB_MachineGun';
        SeeSound    'TOB_SSGuard/Sight';
        PainSound   'TOB_SSGuard/Pain';
        DeathSound  'TOB_SSGuard/Death';
        PainChance 170;

        Obituary "%o was slaughtered by the SS.";
        MissileHeight 36;

        TOB_Nazi.WanderSpeed 1;
        TOB_Nazi.SightTime 1, 6;
        TOB_Nazi.ShootSound 'Weapons/EnemyMachineGun/Fire';
    }

    states
    {
    Spawn:
        WSSG A 0;
        goto super::Spawn;
    Missile:
        "####" FG 10 A_FaceTarget();
        "####" H 5 Bright Shoot();
        "####" G 5 FaceTargetAndPlayShootSound();
        "####" H 5 Bright Shoot();
        "####" G 5 FaceTargetAndPlayShootSound();
        "####" H 5 Bright Shoot();
        "####" G 5 FaceTargetAndPlayShootSound();
        "####" H 5 Bright Shoot();
        goto See;
    Pain:
        "####" I 0;
        goto super::Pain;
    Death:
        "####" J 8 ScreamAndUnblock();
        "####" K 7;
        "####" L 3;
        "####" M 2;
        "####" N -1 Thud();
        stop;
    }
}
