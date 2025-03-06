class TOB_FireSkeletonBone : Actor
{
    default
    {
        Radius 4;
        Height 8;
        Speed 20;
        FastSpeed 40;
        Damage 4;
        Translation "0:255=%[0.42,0.21,0.00]:[2.00,0.87,0.35]";

        Projectile;
        +RANDOMIZE;
    }

    states
    {
    Spawn:
        WSX1 ABCDEFGHIJKL 2 Bright A_SpawnItemEx('TOB_RocketTrail');
        loop;
    Death:
        TNT1 A -1;
        stop;
    }
}

class TOB_FireSkeleton : TOB_Skeleton
{
    const INIT_FIRE_TICKS = 14;

    float halfRadius;
    int fireTicks;
    Actor a;

    void SpawnFireParticles()
    {
        A_SpawnItemEx('TOB_SmallFire',
            frandom[TOB_FireSkeleton](-halfRadius, halfRadius),
            frandom[TOB_FireSkeleton](-halfRadius, halfRadius),
            frandom[TOB_FireSkeleton](0, height));

        if (a)
        {
            a.SetOrigin(pos, true);
        }

        if (fireTicks-- <= 0)
        {
            bool success;
            Actor a;

            [success, a] = A_SpawnItemEx('TOB_FireSkeletonFire');

            if (success)
            {
                self.a = a;
            }

            fireTicks = INIT_FIRE_TICKS;
        }
    }

    //
    // engine messages
    //

    override void BeginPlay()
    {
        super.BeginPlay();

        halfRadius = radius / 2;
        fireTicks = 0;
    }

    override void Tick()
    {
        super.Tick();

        if (!isFrozen() && health > 0)
        {
            SpawnFireParticles();
        }
    }

    //
    //  TOB_Skeleton
    //

    override Actor TossBoneGib()
    {
        let a = super.TossBoneGib();

        if (a)
        {
            a.bBright = true;
        }

        return a;
    }

    override Actor TossSkullGib()
    {
        let a = super.TossSkullGib();

        if (a)
        {
            a.bBright = true;
        }

        return a;
    }

    default
    {
        Health 60;
        Translation "0:255=%[0.42,0.21,0.00]:[2.00,0.87,0.35]";
        +BRIGHT;
    }

    states
    {
    Missile:
        goto TOB_Skeleton_Attack;
    }
}
