class TOB_AssaultRifleRound : Ammo
{
    default
    {
        Inventory.MaxAmount 15;
        +Inventory.IGNORESKILL;
    }
}

class TOB_AssaultRifle : TOB_ReloadingWeapon
{
    const LAYER_HAND = 3;

    // protected action void A_FireAssaultRifle()
    // {
    //     FLineTraceData ltd;
    //     let a = angle;
    //     let p = BulletSlope();
    //     Array<Actor> hitActors;
    //     let z = (Height / 2) + PlayerPawn(self).AttackZOffset;

    //     A_StartSound("weapons/assault/fire", CHAN_WEAPON);

    //     for (let i = -20; i < 20; i++)
    //     {
    //         if (hitActors.Size() > 2)
    //         {
    //             return;
    //         }

    //         LineTrace(a + (11.25 * i / 20.0), 1024, p, offsetz: z, data: ltd);

    //         if (ltd.HitActor)
    //         {
    //             if (hitActors.Size() >= 1 && ltd.HitActor == hitActors[hitActors.Size() - 1])
    //             {
    //                 continue;
    //             }

    //             hitActors.Push(ltd.HitActor);

    //             Actor yea;
    //             int buddy;
    //             [yea, buddy] = LineAttack(AngleTo(ltd.HitActor), Distance2D(ltd.HitActor), p, random(1, 3) * 15, 'Hitscan', 'TOB_Puff');

    //             continue;
    //         }
    //     }
    // }

    action void A_FireAssaultRifle()
    {
        invoker.FireAssaultRifle();
    }

    action void A_PlayAssaultRifleSound()
    {
        invoker.PlayAssaultRifleSound();
    }

    virtual void FireAssaultRifle()
    {
        A_TOBFireBullets(1.4, 1.0, farDmg: 10, closeDist: 256, puffType: 'TOB_MediumPuff');
        owner.A_SetPitch(owner.pitch - 0.7, SPF_INTERPOLATE);
        DepleteSubAmmo();
    }

    virtual void PlayAssaultRifleSound()
    {
        owner.A_StartSound("weapons/assault/fire", CHAN_WEAPON);
    }

    default
    {
        Tag "Assault Rifle";
        Inventory.PickupMessage "Assault rifle";
        Weapon.AmmoGive1 15;
        Weapon.AmmoType1 'TOB_AssaultClip';
        Weapon.SisterWeapon 'TOB_AssaultRiflePowered';
        Weapon.UpSound "weapons/assault/select";
        TOB_ReloadingWeapon.SubAmmo1Type 'TOB_AssaultRifleRound';
        TOB_ReloadingWeapon.SubAmmo1Use 1;
    }

    states
    {
    Ready:
        WARG A 1 A_TOBWeaponReady();
        loop;
    Deselect:
        WARG A 1 A_Lower(24);
        loop;
    Select:
        WARG A 1 A_Raise(12);
        loop;
    Fire:
        WARG AA 1 A_WeaponOffset(0, -4, WOF_ADD);
        WARG A 1 A_StartSound("weapons/assault/start", CHAN_WEAPON);
        WARG A 1 A_WeaponOffset(0, -2, WOF_ADD);
        WARG A 1 A_WeaponOffset(0, -1, WOF_ADD);
        WARG A 1 A_WeaponOffset(0, 6, WOF_ADD);
    Hold:
        WARF A 1 Bright {
            A_FireAssaultRifle();
            A_PlayAssaultRifleSound();
            A_Flash(160, 104);
            A_Light(random(1, 2));
        }
        "####" "#" 0 A_Light(0);
        WARG B 1 A_WeaponOffset(random(-2, 2), WEAPONTOP + random(1, 3) - 12);
        WARG CA 2;
        WARG AA 1 A_ReFire();
        WARG AA 1 A_WeaponOffset(0, 6, WOF_ADD);
        goto Ready;
    Reload:
        WARG A 0;
        "####" "#" 1 A_WeaponOffset(0, 32, WOF_INTERPOLATE);
        "####" "#" 1 A_WeaponOffset(0, 34, WOF_INTERPOLATE);
        "####" "#" 1 A_WeaponOffset(0, 38, WOF_INTERPOLATE);
        "####" "#" 1 A_WeaponOffset(0, 44, WOF_INTERPOLATE);
        "####" "#" 1 A_WeaponOffset(0, 52, WOF_INTERPOLATE);
        "####" "#" 1 A_WeaponOffset(0, 62, WOF_INTERPOLATE);
        "####" "#" 1 A_WeaponOffset(0, 70, WOF_INTERPOLATE);
        "####" "#" 1 A_WeaponOffset(0, 76, WOF_INTERPOLATE);
        WARR A 0 {
            A_Overlay(LAYER_HAND, 'Reload_Part');
            A_OverlayFlags(LAYER_HAND, PSPF_ADDWEAPON, true);
            A_StartSound("weapons/assault/clipout", CHAN_AUTO);
        }
        "####" "#" 1 A_WeaponOffset(0, 76, WOF_INTERPOLATE);
        "####" "#" 4 A_WeaponOffset(8, 76, WOF_INTERPOLATE);
        "####" "#" 4 A_WeaponOffset(0, 76, WOF_INTERPOLATE);
        "####" "#" 1 A_WeaponOffset(13, 76, WOF_INTERPOLATE);
        "####" "#" 1 A_WeaponOffset(25, 65, WOF_INTERPOLATE);
        "####" "#" 1 A_WeaponOffset(36, 52, WOF_INTERPOLATE);
        "####" "#" 1 A_WeaponOffset(45, 39, WOF_INTERPOLATE);
        "####" "#" 1 A_WeaponOffset(53, 28, WOF_INTERPOLATE);
        "####" "#" 13 A_Overlay(LAYER_HAND - 1, 'Reload_Hand');
        WARR C 2 A_WeaponOffset(8, 0, WOF_ADD);
        "####" "#" 0 A_Reload();
        "####" "#" 2 A_WeaponOffset(-8, 0, WOF_ADD);
        "####" "#" 0 A_ClearOverlays(LAYER_HAND, LAYER_HAND);
        "####" "#" 1 A_WeaponOffset(53, 28, WOF_INTERPOLATE);
        "####" "#" 1 A_WeaponOffset(45, 39, WOF_INTERPOLATE);
        "####" "#" 1 A_WeaponOffset(36, 52, WOF_INTERPOLATE);
        "####" "#" 1 A_WeaponOffset(25, 65, WOF_INTERPOLATE);
        "####" "#" 1 A_WeaponOffset(13, 76, WOF_INTERPOLATE);
        WARG A 0;
        "####" "#" 1 A_WeaponOffset(0, 76, WOF_INTERPOLATE);
        "####" "#" 1 A_WeaponOffset(0, 70, WOF_INTERPOLATE);
        "####" "#" 1 A_WeaponOffset(0, 62, WOF_INTERPOLATE);
        "####" "#" 1 A_WeaponOffset(0, 52, WOF_INTERPOLATE);
        "####" "#" 1 A_WeaponOffset(0, 44, WOF_INTERPOLATE);
        "####" "#" 1 A_WeaponOffset(0, 38, WOF_INTERPOLATE);
        "####" "#" 1 A_WeaponOffset(0, 34, WOF_INTERPOLATE);
        "####" "#" 1 A_WeaponOffset(0, 32, WOF_INTERPOLATE);
        goto Ready;
    Reload_Hand:
        WARR B 0 A_OverlayOffset(LAYER_HAND - 1, -128, 160);
        "####" "#" 1 A_OverlayOffset(LAYER_HAND - 1, -128, 128, WOF_INTERPOLATE);
        "####" "#" 1 A_OverlayOffset(LAYER_HAND - 1, -126, 101, WOF_INTERPOLATE);
        "####" "#" 1 A_OverlayOffset(LAYER_HAND - 1, -122, 77, WOF_INTERPOLATE);
        "####" "#" 1 A_OverlayOffset(LAYER_HAND - 1, -114, 57, WOF_INTERPOLATE);
        "####" "#" 1 A_OverlayOffset(LAYER_HAND - 1, -103, 40, WOF_INTERPOLATE);
        "####" "#" 1 A_OverlayOffset(LAYER_HAND - 1, -88, 25, WOF_INTERPOLATE);
        "####" "#" 1 A_OverlayOffset(LAYER_HAND - 1, -71, 14, WOF_INTERPOLATE);
        "####" "#" 1 A_OverlayOffset(LAYER_HAND - 1, -51, 6, WOF_INTERPOLATE);
        "####" "#" 1 A_OverlayOffset(LAYER_HAND - 1, -27, 2, WOF_INTERPOLATE);
        "####" "#" 0 A_StartSound("weapons/assault/clipin", CHAN_AUTO);
        "####" "#" 4 A_OverlayOffset(LAYER_HAND - 1, 0, 0, WOF_INTERPOLATE);
        "####" "#" 0 A_ClearOverlays(LAYER_HAND - 1, LAYER_HAND - 1);
        stop;
    Reload_Part:
        WARS A -1;
        stop;
    Spawn:
        WARW A -1;
        stop;
    }
}

class TOB_AssaultRiflePowered : TOB_AssaultRifle
{
    override void FireAssaultRifle()
    {
        owner.SpawnPlayerMissile('TOB_AssaultRiflePoweredBullet', owner.angle);
        DepleteSubAmmo();
    }

    default
    {
        Weapon.SisterWeapon 'TOB_AssaultRifle';
        +Weapon.POWERED_UP;
    }
}

class TOB_AssaultRiflePoweredBullet : Actor
{
    mixin Db_Tracers_Mixin;

    override void PostBeginPlay()
    {
        super.PostBeginPlay();
        Db_Tracers_Mixin_PostBeginPlay();
    }

    override void Tick()
    {
        super.Tick();
        Db_Tracers_Mixin_Tick();
    }

    default
    {
        BounceCount 0;
        BounceFactor 0.0;
        BounceType 'Hexen';
        Damage 5;
        Speed 100;
        WallBounceFactor 0.0;
        TOB_AssaultRiflePoweredBullet.PuffType 'BulletPuff';
        TOB_AssaultRiflePoweredBullet.Length 32.0;

        Projectile;
        +RIPPER;
        +USEBOUNCESTATE;
    }

    states
    {
    Spawn:
        TNT1 A 1;
        loop;
    Bounce:
        // TODO: "heat seek" enemies and make it appear as if it were a naturalistic ricochet
        TNT1 A 100 { invoker.vel = (frandom(-default.speed, default.speed), frandom(-default.speed, default.speed), frandom(-default.speed, default.speed)); }
        stop;
    }
}
