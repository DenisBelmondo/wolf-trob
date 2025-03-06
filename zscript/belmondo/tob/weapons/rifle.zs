class TOB_RiflePuff : TOB_BigPuff
{
    default
    {
        +ALWAYSPUFF;
    }
}

class TOB_RifleRound : Ammo
{
    default
    {
        Inventory.MaxAmount 5;
        +Inventory.IGNORESKILL;
    }
}

class TOB_Rifle : TOB_ReloadingWeapon
{
    private bool _shouldRechamber;

    action void A_FireRifle()
    {
        invoker.FireRifle();
    }

    action void A_PlayRifleSound()
    {
        invoker.PlayRifleSound();
    }

    virtual void FireRifle()
    {
        let t = owner.AimTarget();
        double ang = 0.0;

        if (t)
        {
            ang = owner.AngleTo(t, true) - owner.angle;
        }

        // A_RailAttack(75, useAmmo: true, color1: "",
        //                                 color2: "",
        //                                 flags: RGF_EXPLICITANGLE|RGF_SILENT,
        //                                 puffType: 'TOB_RiflePuff',
        //                                 spread_xy: ang,
        //                                 spread_z: BulletSlope() - pitch,
        //                                 spawnofs_z: 8,
        //                                 limit: 2);

        FRailParams p;
        p.damage = 150;
        p.distance = PLAYERMISSILERANGE;
        p.color1 = Color("");
        p.color2 = Color("");
        p.flags = RGF_EXPLICITANGLE|RGF_SILENT;
        p.puff = 'TOB_RiflePuff';
        p.angleOffset = ang;
        p.pitchOffset = owner.BulletSlope() - owner.pitch;
        p.offset_z = 8;
        p.limit = 2;
        // p.duration = 0;

        owner.RailAttack(p);
        DepleteSubAmmo();
    }

    virtual void PlayRifleSound()
    {
        owner.A_StartSound("weapons/rifle/fire", CHAN_WEAPON);
    }

    override void BeginPlay()
    {
        super.BeginPlay();
        _shouldRechamber = false;
    }

    override State GetAtkState(bool hold)
    {
        if (subAmmo1.amount <= 0)
        {
            return FindState('Reload');
        }

        return super.GetAtkState(hold);
    }

    override State GetReadyState()
    {
        _shouldRechamber = false;
        return super.GetReadyState();
    }

    default
    {
        Tag "Rifle";
        Inventory.PickupMessage "Rifle";
        Weapon.AmmoType1 'TOB_StripperClip';
        Weapon.AmmoGive1 5;
        Weapon.KickBack 100;
        Weapon.UpSound "weapons/rifle/select";
        Weapon.SisterWeapon 'TOB_RiflePowered';
        TOB_ReloadingWeapon.SubAmmo1Type 'TOB_RifleRound';
        TOB_ReloadingWeapon.SubAmmo1Use 1;
    }

    states
    {
    Ready:
        WRFG A 0;
        "####" "#" 1 A_TOBWeaponReady();
        wait;
    Deselect:
        WRFG A 0;
        "####" "#" 1 A_Lower(24);
        loop;
    Select:
        WRFG A 0;
        "####" "#" 1 A_Raise(12);
        loop;
    Fire:
        WRFG A 0;
        "####" AA 1 A_WeaponOffset(0, -4, WOF_ADD);
        "####" A 1 A_WeaponOffset(0, -2, WOF_ADD);
        "####" A 1 A_WeaponOffset(0, -1, WOF_ADD);
        "####" A 1 A_WeaponOffset(0, 6, WOF_ADD);

        "####" "#" 0 A_WeaponOffset(0, WEAPONTOP);

        "####" "#" 0 A_Flash(muzzleY: 104, label: 'Flash');
        "####" "#" 0 A_Light(2);
        WRFF A 1 Bright;

        "####" "#" 0 A_Light(1);
        "####" "#" 0 A_StartSound("weapons/rifle/start", CHAN_WEAPON);
        WRFG A 1;

        WRFF A 1 Bright A_Light(0);
        WRFG A 1;

        "####" "#" 0 A_FireRifle();
        "####" "#" 0 A_PlayRifleSound();
        "####" "#" 0 A_ZoomFactor(0.98);
        WRFG B 2;

        "####" "#" 0 A_WeaponOffset(random(-4, 4), WEAPONTOP + random(-4, 4));
        "####" "#" 0 A_ZoomFactor(0.9825);
        WRFG C 2;

        "####" "#" 0 A_WeaponOffset(random(-4, 4), WEAPONTOP + random(-4, 4));
        "####" "#" 0 A_ZoomFactor(0.99);
        WRFG C 2;

        "####" "#" 0 A_WeaponOffset(random(-4, 4), WEAPONTOP + random(-4, 4));
        "####" "#" 0 A_ZoomFactor(1.0);
        WRFG A 2;

        "####" "#" 0 A_WeaponOffset(0, WEAPONTOP);
    // allow switch:
        "####" "#" 0 A_WeaponReady(WRF_NOBOB|WRF_NOFIRE);
        "####" "#" 0 {
            invoker._shouldRechamber = true;
        }
    Reload:
    Reload_Open:
        WRFG A 0;
        "####" A 1 A_WeaponOffset(-4, 8, WOF_ADD);
        "####" A 1 A_WeaponOffset(-8, 4, WOF_ADD);
        "####" AA 1 A_WeaponOffset(-12, 2, WOF_ADD);
        "####" "#" 0 A_StartSound("weapons/rifle/bolt_0", CHAN_AUTO);
        "####" DD 1 A_WeaponOffset(-8, -4, WOF_ADD);
        "####" DD 1 A_WeaponOffset(-4, -2, WOF_ADD);
        "####" E 3 A_WeaponOffset(-2, 0, WOF_ADD);
        "####" F 1 A_WeaponOffset(2, 1, WOF_ADD);
        "####" G 2 A_WeaponOffset(12, 8, WOF_ADD);
        "####" H 3;
        "####" "#" 0 A_JumpIf(invoker.subAmmo1.amount && invoker._shouldRechamber, 'Reload_Close');
    Reload_Insert:
        WRFR A 0;
        "####" "#" 0 A_JumpIf(invoker.subAmmo1.amount >= invoker.subAmmo1.maxAmount || invoker.ammo1.amount <= 0, 'Reload_Close');
        "####" AABBB 1;
        "####" "#" 0 A_StartSound("weapons/rifle/insert", CHAN_AUTO);
        "####" CD 2 A_WeaponOffset(-2, 2, WOF_ADD);
        "####" D 1 A_WeaponOffset(4, -4, WOF_ADD);
        "####" "#" 0 A_WeaponReady(WRF_NOBOB|WRF_NOFIRE);
        "####" "#" 0 A_Reload(1);
        "####" "#" 0 A_JumpIf(player.cmd.buttons & BT_ATTACK, 'Reload_Close');
        loop;
    Reload_Close:
        WRFG A 0;
        "####" "#" 0 A_StartSound("weapons/rifle/bolt_1", CHAN_AUTO);
        "####" I 1 A_WeaponOffset(-8, -4, WOF_ADD);
        "####" J 2;
        "####" KD 2;
        "####" D 1 A_WeaponOffset(4, 8, WOF_ADD);
        "####" D 1 A_WeaponOffset(8, 4, WOF_ADD);
        "####" AA 1 A_WeaponOffset(10, 2, WOF_ADD);
        "####" AA 1 A_WeaponOffset(7, -4, WOF_ADD);
        "####" AA 1 A_WeaponOffset(4, -8, WOF_ADD);
        "####" "#" 0 {
            invoker._shouldRechamber = false;
        }
        goto Ready;
    Flash:
        MZF3 A 1 Bright A_Light(1);
        TNT1 A 1;
        MZF3 B 1 Bright A_Light(2);
        "####" "#" 0 A_Light(0);
        goto FlashDone;
    Spawn:
        WRFW A -1;
        stop;
    }
}

class TOB_RiflePowered : TOB_Rifle
{
    default
    {
        Weapon.SisterWeapon 'TOB_Rifle';
        +Weapon.POWERED_UP;
    }

    override void FireRifle()
    {
        let pp = TOB_Util.GetPlayerOwnerForInventory(self);
        if (!pp || !pp.player)
        {
            return;
        }

        pp.LineAttack(pp.angle, PLAYERMISSILERANGE, pp.BulletSlope(), 200, 'Hitscan', 'TOB_RiflePoweredPuff');
        DepleteSubAmmo();
    }
}

class TOB_RiflePoweredPuff : Actor
{
    default
    {
        +PUFFONACTORS;
        +NOINTERACTION;
    }

    states
    {
    Spawn:
        TNT1 AAA 0 NoDelay;
        TNT1 A 0 A_Explode();
        TNT1 A -1 A_SpawnItemEx('TOB_SmallExplosion');
        stop;
    }
}
