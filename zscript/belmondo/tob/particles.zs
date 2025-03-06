class TOB_Particle : Actor abstract
{
    private int _flipFlags;

    flagdef flipX: _FlipFlags, 1;
    flagdef flipY: _FlipFlags, 2;
    flagdef roll:  _FlipFlags, 3;

    override void PostBeginPlay()
    {
        super.PostBeginPlay();

        if (bFlipX)
        {
            scale.x *= randompick[TOB_Particle_XScale](-1, 1);
        }

        if (bFlipY)
        {
            scale.y *= randompick[TOB_Particle_XScale](-1, 1);
        }

        if (bRoll)
            roll = random(0, 359);
    }

    default
    {
        +DONTSPLASH;
        +FORCEXYBILLBOARD;
        +ROLLSPRITE;
        +PUFFGETSOWNER;

        +TOB_Particle.FLIPX;
        +TOB_Particle.FLIPY;
        +TOB_Particle.ROLL;
    }
}

class TOB_NoInteractionParticle : TOB_Particle abstract
{
    default
    {
        +NOINTERACTION;
    }
}

class TOB_Puff : TOB_NoInteractionParticle
{
    private int _sparkChance;
    property sparkChance: _sparkChance;

    override void PostBeginPlay()
    {
        super.PostBeginPlay();

        if (level.mapTime % _sparkChance == 0)
        {
            A_StartSound("weapons/ricochet");
        }
    }

    default
    {
        SeeSound "misc/flesh_bullet";
        TOB_Puff.SparkChance 15;

        +PUFFONACTORS;
        +NOINTERACTION;
        +NOEXTREMEDEATH;
        -TOB_Particle.FLIPX;
        -TOB_Particle.FLIPY;
    }

    states
    {
    Crash:
        WPUF A 2 Bright;
        WPUF B 1 Bright;
    Melee:
        "####" "#" 0 A_SetRenderStyle(invoker.Alpha, STYLE_Add);
        WPUF CDEFG 1;
        WPUF HI 2 A_FadeOut(0.125);
        WPUF JK 3 A_FadeOut(0.125);
        TNT1 A -1 { return ResolveState('Null'); }
        stop;
    }
}

class TOB_MediumPuff : TOB_Puff
{
    states
    {
    Crash:
        WMPF A 2 Bright;
        WBPF A 1 Bright;
        goto super::Melee;
    }
}

class TOB_BigPuff : TOB_Puff
{
    states
    {
    Crash:
        WBPF A 2 Bright;
        WBPF B 1 Bright;
    Melee:
        TNT1 AAAA 0
        {
            bool yea;
            Actor buddy;

            [yea, buddy] = A_SpawnItemEx('TOB_Dust',
                xvel: 0.5,
                yvel: frandom[TOB_BigPuff_Puff](-0.3, 0.3),
                zvel: frandom[TOB_BigPuff_Puff](-0.3, 0.3));

            buddy.scale *= 1.5;
        }
        stop;
    }
}

class TOB_Dust : TOB_Puff
{
    default
    {
        RenderStyle 'Translucent';
        Alpha 0.5;
    }

    states
    {
    Spawn:
        WPUF CDEFG 4;
        WPUF HIJK 4 A_FadeOut(0.125);
        stop;
    }
}

class TOB_Spark : TOB_NoInteractionParticle
{
    default
    {
        RenderStyle "Add";
    }

    states
    {
    Spawn:
        BSPK ABCD 3 Bright;
        stop;
    }
}

class TOB_Blood : TOB_NoInteractionParticle replaces Blood
{
    action void A_Gross(uint times = 1)
    {
        let yvel = frandom[TOB_BloodSpray](0.5, 1.0)
            * scale.y * frandompick[TOB_BloodSpray](-1.0, 1.0);

        for (let i = 0; i < times; i++)
        {
            A_SpawnItemEx('TOB_BloodFly',
                zofs: frandom[TOB_BloodSpray](-1.0, 4.0) * scale.y,
                yvel: yvel,
                zvel: frandom[TOB_BloodSpray](3.0, 8.0) * scale.y,
                flags: SXF_TRANSFERTRANSLATION|SXF_TRANSFERSCALE);
        }
    }

    override void PostBeginPlay()
    {
        super.PostBeginPlay();
        vel = (0, 0, 0);
    }

    default
    {
        -TOB_Particle.ROLL;
    }

    states
    {
    Spawn:
        TNT1 A 0;
        goto Spawn_FallThrough;
    Spawn1:
        TNT1 A 0 A_SetScale(0.75);
        goto Spawn_FallThrough;
    Spawn2:
        TNT1 A 0 A_SetScale(0.5);
    Spawn_FallThrough:
        WBLD ABCD 2;
        TNT1 A 0 A_Gross();
        WBLD EFG 2;
        TNT1 A -1 { return ResolveState('Null'); }
        stop;
    }
}

class TOB_BloodSplatter : TOB_Blood replaces BloodSplatter {}

class TOB_BloodFly : TOB_NoInteractionParticle
{
    override void Tick()
    {
        super.Tick();

        if (!IsFrozen())
        {
            let trail = Spawn('TOB_BloodTrail', pos);
            trail.translation = translation;
            trail.scale = scale;

            if (pos.z <= floorZ)
            {
                for (let i = 0; i < random(4, 8); ++i)
                {
                    A_SpawnItemEx('TOB_BloodFloor',
                        frandom[TOB_BloodFlySplat](-4.0, 4.0),
                        frandom[TOB_BloodFlySplat](-4.0, 4.0),
                        flags: SXF_TRANSFERTRANSLATION | SXF_TRANSFERSCALE);
                }

                A_StartSound("misc/blood_drip", CHAN_AUTO, volume: scale.y / 2.0);
                SetState(ResolveState('Null'));
            }
        }
    }

    default
    {
        Radius 1;
        Height 1;

        -NOINTERACTION;
    }

    states
    {
    Spawn:
        BFLY ABCD 3;
        wait;
    }
}

class TOB_BloodTrail : TOB_NoInteractionParticle
{
    states
    {
    Spawn:
        BFLY ABCD 3;
        TNT1 A -1 {
            return resolveState('Null');
        }
        stop;
    }
}

class TOB_BloodFloor : TOB_NoInteractionParticle
{
    default
    {
        RenderStyle 'Translucent';
        +MOVEWITHSECTOR;
        -TOB_Particle.FLIPY;
        -TOB_Particle.ROLL;
    }

    states
    {
    Spawn:
        DRBD A 20 NoDelay {
            Frame = random[TOB_BloodFloorFrame](0, 7);
        }
    Death:
        "####" "#" 175;
        "####" "#" 1 {
            alpha -= 0.01;
            if (alpha <= 0)
            {
                return ResolveState('Null');
            }

            return ResolveState(null);
        }
        wait;
    }
}

class TOB_FlyingGibs : TOB_NoInteractionParticle
{
    default
    {
        Radius 2;
        Height 4;
        Projectile;

        -NOGRAVITY;
        -NOINTERACTION;
    }

    states
    {
    Spawn:
        BRBN ABCDEFGH 1 A_CheckFloor('Crash');
        // TNT1 A 0 A_SpawnItemEx('TOB_FlyingGibTrail', flags: SXF_TRANSFERTRANSLATION);
        loop;
    Death:
        TNT1 A -1;
        stop;
    Crash:
        TNT1 A 0 {
            for (let i = 0; i < 4; i++)
            {
                A_SpawnItemEx('TOB_Giblet',
                    frandom[TOB_FlyingGibs](-16.0, 16.0),
                    frandom[TOB_FlyingGibs](-16.0, 16.0),
                    flags: SXF_TRANSFERTRANSLATION);
            }

            Roll = 0.0;
            Scale.y = abs(Scale.y);
            vel.x = 0.0;
            vel.y = 0.0;
            A_StartSound("misc/tup", CHAN_AUTO, volume: 0.7);
        }
        GBSP ABCDEFG 3;
        stop;
    }
}

class TOB_FlyingGibTrail : TOB_NoInteractionParticle
{
    override void PostBeginPlay()
    {
        super.PostBeginPlay();
    }

    default
    {
        Scale 1.5;
    }

    states
    {
    Spawn:
        BFLY ABCD 4;
        stop;
    }
}

class TOB_Giblet : TOB_Particle
{
    default
    {
        Radius 2;
        Height 4;

        -TOB_Particle.FLIPY;
        -TOB_Particle.ROLL;
    }

    states
    {
    Spawn:
        GBLD A 0 NoDelay {
            frame += random[TOB_GibletFrame](0, 13);

            for (let i = 0; i < random(4, 8); ++i)
            {
                bool spawned;
                Actor a;

                [spawned, a] = A_SpawnItemEx('TOB_BloodFloor',
                    xvel: frandom[TOB_GibletBleed](-1.0, 1.0),
                    yvel: frandom[TOB_GibletBleed](-1.0, 1.0),
                    flags: SXF_TRANSFERTRANSLATION);

                if (a)
                {
                    a.bNoInteraction = false;
                }
            }
        }
        "####" "#" 175;
        "####" "#" 1 A_FadeOut(0.01);
        wait;
    }
}

class TOB_AbstractExplosion : TOB_NoInteractionParticle abstract
{
    virtual void SpawnSmoke()
    {
        A_SpawnItemEx('TOB_ExplosionSmoke', 2, yofs: frandom(-40, 40), zofs: frandom(-16, 32), zvel: frandom(1, 1.25));
    }
}

class TOB_ExplosionSmoke : TOB_AbstractExplosion
{
    default
    {
        Scale 3;
        Alpha 0.5;
    }

    states
    {
    Spawn:
        RSMK AAAAAAAAAAAAAAAABBBBBBBBBBBBBBBBCCCCCCCCCCCCCCCCDDDDDDDDDDDDDDDD 1 {
            A_FadeOut(0.015);
            scale *= 1.0125;
        }
        stop;
    }
}

class TOB_SmallExplosion : TOB_AbstractExplosion
{
    override void PostBeginPlay()
    {
        super.PostBeginPlay();
        A_StartSound("weapons/explode", CHAN_AUTO);
    }

    default
    {
        -TOB_Particle.FLIPX;
        -TOB_Particle.FLIPY;
    }

    states
    {
    Spawn:
        SXP2 A 3 Bright;
        SEXP AB 2 Bright;
        SEXP CD 3 Bright;
        SEXP EF 3 Bright {
            A_FadeOut(0.25);
            invoker.SpawnSmoke();
        }
        stop;
    }
}

class TOB_SmallerExplosion : TOB_AbstractExplosion
{
    override void PostBeginPlay()
    {
        super.PostBeginPlay();
        A_StartSound("misc/explode_tiny", CHAN_AUTO);
    }

    default
    {
        Scale 0.75;
    }

    states
    {
    Spawn:
        SXP2 A 3 Bright;
        SEXP B 2 Bright;
        SEXP D 3 Bright;
        SEXP F 2 Bright;
        stop;
    }
}

class TOB_MediumExplosion : TOB_AbstractExplosion
{
    override void PostBeginPlay()
    {
        super.PostBeginPlay();
        A_StartSound("weapons/explode", CHAN_AUTO);

        if (CVar.FindCVar("tob_weebmode").GetBool())
        {
            A_StartSound("Weapons/DBZExplode", CHAN_AUTO);
        }
    }

    default
    {
        -TOB_Particle.FLIPX;
        -TOB_Particle.FLIPY;
    }

    states
    {
    Spawn:
        MEXP AB 2 NoDelay Bright;
        MEXP C 2 Bright;
        MEXP D 3 Bright;
        MEXP E 2 Bright {
            A_FadeOut(0.3);

            for (let i = 0; i < 3; i++)
                SpawnSmoke();
        }
        MEXP F 3 A_FadeOut(0.3);
        MEXP GG 3 A_FadeOut(0.2);
        stop;
    }
}
/*
class TOB_BigExplosion : TOB_NoInteractionParticle
{
    override void PostBeginPlay()
    {
        super.PostBeginPlay();
        A_StartSound("weapons/explode_2", CHAN_AUTO);

        if (CVar.FindCVar("tob_weebmode").GetBool())
        {
            A_StartSound("Weapons/DBZExplode", CHAN_AUTO);
        }
    }

    default
    {
        Scale 0.8;

        -TOB_Particle.FLIPX;
        -TOB_Particle.FLIPY;
        -TOB_Particle.ROLL;
    }

    states
    {
    Spawn:
        MEXP AB 2 Bright;
        BXP2 AB 2 Bright;
        BXP2 CD 3 Bright A_FadeOut(0.2);
        BXP2 EF 4 Bright A_FadeOut(0.2);
        stop;
    }
}
*/

class TOB_BigExplosion : TOB_MediumExplosion
{
    default
    {
        Scale 1.5;
    }
}

class TOB_MushroomExplosion : TOB_AbstractExplosion
{
    override void PostBeginPlay()
    {
        super.PostBeginPlay();
        A_StartSound("weapons/explode_2", CHAN_AUTO);

        if (CVar.FindCVar("tob_weebmode").GetBool())
        {
            A_StartSound("Weapons/DBZExplode", CHAN_AUTO);
        }
    }

    default
    {
        RenderStyle 'Add';

        -TOB_Particle.FLIPY;
        -TOB_Particle.ROLL;
    }

    states
    {
    Spawn:
        MEXP AB 2 Bright;
        BEXP AB 3 Bright;
        BEXP CDEF 1 Bright;
        BEXP GHIJ 2 Bright SpawnSmoke();
        BEXP KLMNOP 2 Bright;
        BEXP QRSTU 2 A_FadeOut(0.15);
        stop;
    }
}

class TOB_GroundExplosion : TOB_AbstractExplosion
{
    override void PostBeginPlay()
    {
        super.PostBeginPlay();
        A_StartSound("weapons/explode", CHAN_AUTO);
    }

    default
    {
        -TOB_Particle.FLIPY;
        -TOB_Particle.ROLL;
    }

    states
    {
    Spawn:
        MEXP AB 2 Bright;
        TNT1 A 0 SpawnSmoke();
        GEXP ABCDEF 2 Bright;
        GEXP GHIJ 3 A_FadeOut(0.2);
        stop;
    }
}

class TOB_Combust : TOB_NoInteractionParticle
{
    default
    {
        RenderStyle 'Add';

        -TOB_Particle.FLIPX;
        -TOB_Particle.ROLL;
    }

    states
    {
    Spawn:
        CBST ABCDEFGHIJKLMNOPQRST 2 Bright;
        stop;
    }
}

class TOB_RocketTrail : TOB_NoInteractionParticle
{
    default
    {
        Scale 0.5;
        Alpha 0.5;
        RenderStyle 'Add';
    }

    states
    {
    Spawn:
        RTRL ABCD 2 Bright;
        "####" EF 2 A_FadeOut(0.33333333);
        stop;
    }
}

class TOB_BloodExplosion : TOB_Blood
{
    states
    {
    Spawn:
        TNT1 A 0 NoDelay A_Gross(random[TOB_BloodExplosion](1, 2));
        BSBU ABCDEFG 2;
        stop;
    }
}

class TOB_SkeletonBone : TOB_Particle
{
    states
    {
    Spawn:
        WSX1 ABCDEFGHIJKL 2 A_CheckFloor('Crash');
        loop;
    Crash:
        "####" "#" -1 {
            A_SpawnItemEx('TOB_SmallFire');
            return ResolveState('Null');
        }
        stop;
    }
}

class TOB_SkeletonSkull : TOB_SkeletonBone
{
    states
    {
    Spawn:
        WSX0 ABCDEFGHIJKLMN 2 A_CheckFloor('Crash');
        loop;
    }
}

class TOB_TeslaPuff : TOB_NoInteractionParticle
{
    default
    {
        RenderStyle 'Add';
        Scale 0.5;
        DamageType 'Electric';
        +ALWAYSPUFF;
        +BLOODLESSIMPACT;
        +NOBLOODDECALS;
        +NOEXTREMEDEATH;
    }
}

class TOB_LeichenfaustSparkles : TOB_NoInteractionParticle
{
    default
    {
        RenderStyle 'Add';
    }

    states
    {
    Spawn:
        LFX1 ABCDEF 2 Bright;
        TNT1 A -1;
        stop;
    }
}

class TOB_LeichenfaustTrail : TOB_NoInteractionParticle
{
    default
    {
        RenderStyle 'Add';
        Scale 2;
    }

    states
    {
    Spawn:
        LFX0 ABCDEF 3;
        TNT1 A -1;
        stop;
    }
}

class TOB_LeichenfaustExplosion : TOB_NoInteractionParticle
{
    default
    {
        RenderStyle 'Add';
        Scale 2;
    }

    states
    {
    Spawn:
        TNT1 A 0 NoDelay {
            A_QuakeEx(2, 2, 2, 10, 0, 2048, "");
            A_StartSound("weapons/explode_leichenfaust_0", CHAN_AUTO);
            scale = (1, 1);
        }
        LFBX EF 2 Bright;
        LFBX ABCD 1 Bright;
        TNT1 A 0 {
            scale = (2, 2);
        }
        LFBX ABC 2 Bright A_SpawnItemEx('TOB_LeichenfaustSparkles', yofs: random(-64, 64), zofs: random(-64, 64));
        LFX0 ABCDDEEFF 1 Bright A_SpawnItemEx('TOB_LeichenfaustSparkles', yofs: random(-64, 64), zofs: random(-64, 64));
        TNT1 A -1;
        stop;
    }
}

class TOB_BigFire : TOB_NoInteractionParticle
{
    default
    {
        RenderStyle 'Add';

        -TOB_Particle.ROLL;
        -TOB_Particle.FLIPY;
    }

    states
    {
    Spawn:
        WFLM ABCDEFGH 2 Bright;
        stop;
    }
}

class TOB_MediumFire : TOB_BigFire
{
    default
    {
        Scale 0.8;
    }
}

class TOB_SmallFire : TOB_BigFire
{
    default
    {
        XScale 0.33333333;
        YScale 0.2;
    }
}

class TOB_FireSkeletonFire : TOB_MediumFire
{
}

class TOB_KeySparkle : TOB_NoInteractionParticle
{
    default
    {
        Scale 0.5;
    }

    states
    {
    Spawn:
        WKSP ABC 3 Bright;
        TNT1 A -1 {
            return ResolveState('Null');
        }
        stop;
    }
}

class TOB_ZapSmall0 : TOB_NoInteractionParticle
{
    default
    {
        RenderStyle 'Add';
    }

    states
    {
    Spawn:
        ZAP0 ABABCBC 1 Bright;
        stop;
    }
}

class TOB_ZapSmall1 : TOB_NoInteractionParticle
{
    default
    {
        RenderStyle 'Add';
    }

    states
    {
    Spawn:
        ZAP1 QPQON 1 Bright;
        stop;
    }
}

class TOB_ZapMedium0 : TOB_NoInteractionParticle
{
    default
    {
        RenderStyle 'Add';
    }

    states
    {
    Spawn:
        ZAP1 ABCDEKLM 1 Bright;
        stop;
    }
}

class TOB_TeslaExplosion : TOB_NoInteractionParticle
{
    int times;

    override void BeginPlay()
    {
        super.BeginPlay();
        times = 0;
    }

    override void PostBeginPlay()
    {
        super.PostBeginPlay();
        A_StartSound("weapons/tesla_grenade/explode", CHAN_AUTO);
    }

    default
    {
        Radius 64;
        RenderStyle 'Add';
        -TOB_Particle.ROLL;
    }

    states
    {
    Spawn:
        ELEX ACBCD 1 Bright A_SpawnItemEx('TOB_ZapMedium0', frandom[TOB_TeslaExplosion](-default.radius, default.radius), frandom[TOB_TeslaExplosion](-default.radius, default.radius), frandom[TOB_TeslaExplosion](0, default.radius));
        "####" EF 2 Bright;
        TNT1 A 0;
    Spawn_Loop:
        "####" "#" 10 {
            tics = random[TOB_TeslaExplosion](3, 17);
        }
        "####" "#" 0 {
            A_SpawnItemEx('TOB_ZapMedium0', frandom[TOB_TeslaExplosion](-default.radius, default.radius), frandom[TOB_TeslaExplosion](-default.radius, default.radius), frandom[TOB_TeslaExplosion](0, default.radius));
            A_StartSound("weapons/tesla/idle", CHAN_AUTO);
        }
        "####" "#" 0 {
            invoker.times += 1;

            if (invoker.times >= 3) {
                return ResolveState('Null');
            }

            return ResolveState(null);
        }
        loop;
    }
}
