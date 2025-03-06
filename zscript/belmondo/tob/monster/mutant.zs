class TOB_Mutant : TOB_Nazi
{
    default
    {
        Health 65;
        Speed 3;

        DropItem 'TOB_BigClip';
        PainSound "TOB_Mutant/Pain";
        DeathSound "TOB_Mutant/Death";

        BloodColor '#FF00FF';
        Obituary "%o was murdered by a mutant.";

        TOB_Nazi.WanderSpeed 1;
        TOB_Nazi.SightTime 1, 6;
        TOB_Nazi.ShootSound 'Weapons/EnemyPistol/Fire';
    }

    states
    {
    Spawn:
        WMUT A 0;
        goto super::Spawn;
    Missile:
        "####" F 3 A_FaceTarget();
        "####" G 10 Bright Shoot();
        "####" H 5 A_FaceTarget();
        "####" I 10 Bright Shoot();
        goto See;
    Pain:
        "####" J 0;
        goto super::Pain;
    Death:
        "####" K 8 ScreamAndUnblock();
        "####" L 6;
        "####" M 3;
        "####" NO 2;
        "####" P -1 Thud();
        stop;
    XDeath:
        XDMT A 0;
        goto XDeath_Through;
    }
}
