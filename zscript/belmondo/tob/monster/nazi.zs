class TOB_Nazi : TOB_Monster abstract
{
    enum EAlertState
    {
        EAlertState_None,
        EAlertState_Ambushing,
        EAlertState_Wandering,
        EAlertState_Chasing
    }

    mixin TOB_BulletShooterMixin;
    mixin TOB_Wolf3DSizedActorMixin;

    int alertState;
    int sightTime;

    int sightTimeBase, sightTimeAdd;
    property sightTime: sightTimeBase, sightTimeAdd;

    float wanderSpeed;
    property wanderSpeed: wanderSpeed;

    Sound chokeSound;
    property chokeSound: chokeSound;

    action void A_SpawnFlyingBlood(int num = 1)
    {
        int r = default.radius * 2;

        for (let i = 0; i < num; i++)
        {
            A_SpawnItemEx('TOB_BloodFly',
                frandom[TOB_Cosmetic](-r, r),
                frandom[TOB_Cosmetic](-r, r),
                frandom[TOB_Cosmetic](0, default.height),
                frandom[TOB_Cosmetic](-1, 1),
                frandom[TOB_Cosmetic](-1, 1),
                frandom[TOB_Cosmetic](2, 5),
                flags: SXF_USEBLOODCOLOR);
        }
    }

    virtual float GetDefaultSpeed()
    {
        return default.speed * default.scale.y;
    }

    void SetAlertState(int alertState)
    {
        self.alertState = alertState;

        bCantLeaveFloorPic = default.bCantLeaveFloorPic;
        speed = GetDefaultSpeed();

        if (alertState == EAlertState_Wandering)
        {
            bCantLeaveFloorPic = true;
            speed = wanderSpeed;
        }
    }

    virtual void AmbushLook()
    {
        A_LookEx(0, fov: 360);
    }

    virtual void Choke()
    {
        A_StartSound(chokeSound, CHAN_VOICE);
    }

    override void BeginPlay()
    {
        super.BeginPlay();

        alertState = EAlertState_None;

        if (bAmbush)
        {
            alertState = EAlertState_Ambushing;
        }

        wanderSpeed *= default.scale.y;
        speed *= default.scale.y;

        // times 10 to roughly simulate the sight check every 7.5 to 10 ecwolf
        // tics
        // addendum: idk if this is even correct. idk it feels faithful
        sightTime = (sightTimeBase + random[TOB_Nazi_SightTimeAdd](0, sightTimeAdd)) * 8;

        // if the enemy is in ambush mode, sight time is reduced to 0.
        sightTime *= !bAmbush;
    }

    override int DamageMobj(Actor inflictor, Actor source, int damage, Name mod, int flags, double angle)
    {
        // if the enemy has their guard down, apply double damage
        let damage = damage + (damage * (alertState == EAlertState_Wandering));

        let r = super.DamageMobj(inflictor, source, damage, mod, flags, angle);
        SetAlertState(EAlertState_Chasing);
        return r;
    }

    override void Die(Actor source, Actor inflictor, int dmgFlags, Name meansOfDeath)
    {
        super.Die(source, inflictor, dmgFlags, meansOfDeath);
        scale.x *= (level.mapTime & 1) * 2 - 1;
    }

    override void Tick()
    {
        super.Tick();

        if (tob_sv_alwayspain)
        {
            painChance = 256;
        }
        else
        {
            painChance = default.painChance;
        }
    }

    override void Look()
    {
        if (bAmbush)
        {
            AmbushLook();
            return;
        }

        if (sightTime <= 0)
        {
            sightTime = 0;
            A_Look();

            if (target)
            {
                SetAlertState(EAlertState_Chasing);
            }

            return;
        }

        A_LookEx(LOF_NOSEESOUND|LOF_NOJUMP);

        if (target)
        {
            sightTime--;
        }
    }

    override void Chase()
    {
        super.Chase();
        SetAlertState(EAlertState_Chasing);
    }

    override void Pain()
    {
        super.Pain();
        frame += randompick[TOB_Nazi_PainFrame](0, 1);
    }

    override void Scream()
    {
        if (alertState != EAlertState_Chasing)
        {
            Choke();
            return;
        }

        A_Scream();
    }

    default
    {
        MinMissileChance 1000;
        ReactionTime 40;
        Radius 16;
        Height 56;
        PainChance 256;
        MeleeRange 54;

        TOB_Nazi.BulletClass 'TOB_Bullet';
        TOB_Nazi.ChokeSound "TOB_Nazi/Death/Choke";

        +FLOORCLIP;
        +NOINFIGHTING;
    }

    states
    {
    Spawn:
        "####" A 1 Look();
        loop;
    Idle:
        "####" "#" 0 A_StartSound("TOB_Monster/Boot", CHAN_BODY);
        "####" BBBBBBBBBB 1 LookAndWander();
        "####" B 3;
        "####" "#" 0 A_StartSound("TOB_Monster/Boot", CHAN_BODY);
        "####" CCCCCCCC 1 LookAndWander();
        "####" "#" 0 A_StartSound("TOB_Monster/Boot", CHAN_BODY);
        "####" DDDDDDDDDD 1 LookAndWander();
        "####" D 3;
        "####" "#" 0 A_StartSound("TOB_Monster/Boot", CHAN_BODY);
        "####" EEEEEEEE 1 LookAndWander();
        loop;
    See:
        "####" "#" 0 A_StartSound("TOB_Monster/Gear", CHAN_BODY);
        "####" BBBBB 1 Chase();
        "####" B 2;
        "####" "#" 0 A_StartSound("TOB_Monster/Gear", CHAN_BODY);
        "####" CCCC 1 Chase();
        "####" "#" 0 A_StartSound("TOB_Monster/Gear", CHAN_BODY);
        "####" DDDDD 1 Chase();
        "####" D 2;
        "####" "#" 0 A_StartSound("TOB_Monster/Gear", CHAN_BODY);
        "####" EEEE 1 Chase();
        loop;
    Melee:
        "####" "#" 0 {
            let st = FindState('Missile', true);

            if (st)
            {
                return st;
            }

            return ResolveState(null);
        }
        goto See;
    Pain:
        "####" "#" 5 Pain();
        goto See;
    XDeath:
        "####" "#" 5;
        XDE0 A 0;
    XDeath_Through:
        "####" "#" 0 A_NoBlocking();
        "####" A 6 {
            for (let i = 0; i < 4; i++)
            {
                A_SpawnItemEx('TOB_FlyingGibs', frandom[TOB_Cosmetic](-4, 4),
                                                frandom[TOB_Cosmetic](-4, 4),
                                                frandom[TOB_Cosmetic](0, default.height),
                                                frandom[TOB_Cosmetic](-20, 20),
                                                frandom[TOB_Cosmetic](-20, 20),
                                                frandom[TOB_Cosmetic](5, 10),
                                                flags: SXF_USEBLOODCOLOR);
            }

            A_StartSound("misc/xdeath", CHAN_VOICE);
        }
        "####" BB 2 A_SpawnFlyingBlood();
        "####" B 1;
        "####" C 2 A_SpawnFlyingBlood();
        "####" C 1;
        "####" D 2 A_SpawnFlyingBlood();
        "####" D 1;
        "####" EF 3 A_SpawnFlyingBlood();
        "####" G -1;
        stop;
    // Death.Fire:
    //     "####" "#" 12 {
    //         A_SpawnItemEx('TOB_BigFire', zvel: 2);
    //         A_StartSound("TOB_WolfensteinMonster/Burn", CHAN_VOICE);
    //     }
    //     "####" CDCDCDCDCDCDCDCDCDCDCD 3 {
    //         A_SetTranslation('TOB_Crispy');
    //         A_Wander();
    //         // A_StopSound(CHAN_7);
    //         // A_StartSound("misc/small_fire", CHAN_7);
    //         for (let i = 0; i < 4; i++)
    //         {
    //             angle = frandom(0, 359);
    //             A_SpawnItemEx('TOB_SmallFire', xofs: frandom(-default.radius, default.radius),
    //                                            yofs: frandom(-default.radius, default.radius),
    //                                            zofs: frandom(0, default.height),
    //                                            zvel: 1);
    //         }
    //     }
    //     "####" "#" 12 {
    //         A_SpawnItemEx('TOB_BigFire', zvel: 2);
    //         return ResolveState('Death');
    //     }
    //     TNT1 A -1 A_NoBlocking();
    //     stop;
    }
}
