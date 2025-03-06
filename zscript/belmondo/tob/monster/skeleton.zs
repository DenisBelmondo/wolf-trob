class TOB_SkeletonPuff : Actor
{
    default
    {
        ProjectileKickBack 200;
        +PUFFONACTORS;
    }

    states
    {
    Spawn:
        TNT1 A -1 NoDelay A_StartSound("TOB_Skeleton/Attack_1", CHAN_AUTO);
    }
}

class TOB_SkeletonBlood : Actor
{
    states
    {
    Spawn:
        TNT1 AAA 0 NoDelay;
        TNT1 A -1 {
            bool spawned;
            Actor actor;
            [spawned, actor] = A_SpawnItemEx('TOB_BigPuff');

            if (spawned)
            {
                actor.SetState(actor.ResolveState('Melee'));
            }
        }
        stop;
    }
}

class TOB_Skeleton : TOB_Monster
{
    virtual void SkeletonAttack()
    {
        A_CustomBulletAttack(0, 0, 1, random(1, 10) * 4, "TOB_SkeletonPuff", meleeRange * 1.5, CBAF_NORANDOM);
    }

    virtual Actor TossBoneGib()
    {
        bool _;
        Actor a;

        [_, a] = A_SpawnItemEx('TOB_SkeletonBone',
            zofs: frandom(0, default.height),
            xvel: frandom(-10, 10),
            yvel: frandom(-10, 10),
            zvel: frandom(8, 16),
            flags: SXF_TRANSFERTRANSLATION);

        return a;
    }

    virtual Actor TossSkullGib()
    {
        bool _;
        Actor a;

        A_SpawnItemEx('TOB_SkeletonSkull',
            zofs: default.height / 2,
            zvel: frandom(8, 16),
            flags: SXF_TRANSFERTRANSLATION);

        return a;
    }

    default
    {
        Health 75;
        Speed 5;
        Radius 20;
        Height 56;
        PainChance 16;
        DeathSound "TOB_Skeleton/Death";
        BloodType 'TOB_SkeletonBlood';
        Scale 1.1;
        Obituary "%o was smacked by a Skeleton.";

        +FLOORCLIP;
        +NOBLOODDECALS;
    }

    states
    {
    Spawn:
        WSKL A 10 A_Look();
        loop;
    See:
        "####" "#" 0 {
            scale.x = default.scale.x;
        }
        "####" AAAABBBBCCCCDDDD 1 Chase();
        loop;
    Melee:
    TOB_Skeleton_Attack:
        "####" F 2 {
            A_FaceTarget();
            A_StartSound("TOB_Skeleton/Attack_0", CHAN_AUTO);
        }
        "####" E 0;
        "####" "###" 1 {
            scale.x = frandom(0.8, 1.2);
        }
        "####" "#" 6 {
            scale.x = default.scale.x;
            A_StartSound("TOB_Skeleton/Attack_2", CHAN_AUTO);
        }
        "####" F 2 {
            SkeletonAttack();
            scale.x += 0.4;
        }
        "####" G 10 {
            scale.x = default.scale.x;
        }
        goto See;
    Pain:
        "####" H 10 A_Pain();
        goto See;
    Death:
        "####" "#" 0 ScreamAndUnblock();
        "####" "#" 0 {
            for (let i = 0; i < 4; i++)
            {
                TossBoneGib();
            }
        }
        "####" "####" 1 TossBoneGib();
        TNT1 A -1 TossSkullGib();
        stop;
    }
}
