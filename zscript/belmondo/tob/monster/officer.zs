class TOB_Officer : TOB_Guard
{
    default
    {
        Health 50;
        Speed 5;

        SeeSound   'TOB_Officer/Sight';
        PainSound  'TOB_Officer/Pain';
        DeathSound 'TOB_Officer/Death';
        PainChance 170;

        Obituary "%o was obliterated by an officer.";

        TOB_Nazi.WanderSpeed 1;
        TOB_Nazi.SightTime 1, 2;
    }

    states
    {
    Spawn:
        WOFC A 0;
        goto TOB_Nazi::Spawn;
    Missile:
        "####" F 3 A_FaceTarget();
        "####" G 10 A_FaceTarget();
        "####" H 5 Bright Shoot();
        goto See;
    Death:
        "####" J 8 ScreamAndUnblock();
        "####" K 6;
        "####" L 3;
        "####" MN 2;
        "####" O -1 Thud();
        stop;
    }
}
