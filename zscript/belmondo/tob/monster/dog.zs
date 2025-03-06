class TOB_DogBitePuff : Actor
{
    default
    {
        SeeSound "TOB_Dog/Bite";
        ProjectileKickBack 0;
        +PUFFONACTORS;
        +NODAMAGETHRUST;
    }
}

class TOB_Dog : TOB_Nazi
{
    virtual void DogAttack()
    {
        if (!target)
        {
            return;
        }

        let pitch = LineAttack(AngleTo(target), meleeRange, BulletSlope(),
                               random(1, 15), 'Melee', 'TOB_DogBitePuff',
                               LAF_ISMELEEATTACK);
    }

    default
    {
        Health 60;
        Speed 8;
        PainChance 32;
        AttackSound "TOB_Dog/Attack";
        ActiveSound "TOB_Dog/Idle";
        DeathSound "TOB_Dog/Death";
        SeeSound "TOB_Dog/Sight";
        Obituary "%o was devoured by a dog.";
        TOB_Nazi.WanderSpeed 3;
        TOB_Nazi.SightTime 1, 8;
    }

    states
    {
    Spawn:
        WGSH A 0;
        goto super::Spawn;
    Melee:
        "####" FG 4 A_FaceTarget();
        "####" HF 3 DogAttack();
        "####" B 5;
        goto See;
    Death:
        "####" J 8 A_Fall();
        "####" K 5 A_Scream();
        "####" L 8;
        "####" MNO 1;
        "####" P -1 Thud();
        stop;
    }
}
