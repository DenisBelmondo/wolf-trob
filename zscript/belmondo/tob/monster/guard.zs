class TOB_Guard : TOB_Nazi
{
    default
    {
        Health 25;
        Speed 3;
        PainChance 200;

        DropItem    'TOB_Clip';
        SeeSound    'TOB_Guard/Sight';
        PainSound   'TOB_Guard/Pain';
        DeathSound  'TOB_Guard/Death';

        Obituary "%o was got by a guard.";
        MissileHeight 44;

        TOB_Nazi.WanderSpeed 1;
        TOB_Nazi.SightTime 1, 4;
        TOB_Nazi.ShootSound 'Weapons/EnemyPistol/Fire';
    }

    states
    {
    Spawn:
        WGRD A 0;
        goto super::Spawn;
    Missile:
        "####" FG 10 A_FaceTarget();
        "####" H 10 Bright Shoot();
        goto See;
    Pain:
        "####" I 0;
        goto super::Pain;
    Death:
        "####" J 8 ScreamAndUnblock();
        "####" K 6;
        "####" L 3;
        "####" M 2;
        "####" N -1 Thud();
        stop;
    }
}
