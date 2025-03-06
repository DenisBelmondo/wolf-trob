class TOB_MachineGunRound : Ammo
{
    default
    {
        Inventory.MaxAmount 30;
        +Inventory.IGNORESKILL;
    }
}

class TOB_MachineGun : TOB_ReloadingWeapon
{
    const LAYER_HAND = -2;

    action void A_FireMachineGun()
    {
        invoker.FireMachineGun();
    }

    action void A_PlayMachineGunSound()
    {
        invoker.PlayMachineGunSound();
    }

    virtual void PlayMachineGunSound()
    {
        owner.A_StartSound("weapons/machinegun/fire", CHAN_WEAPON);
    }

    virtual void FireMachineGun()
    {
        TOBFireBullets(1.5, 0.75, farDmg: 5, closeDist: 192, puffType: 'TOB_Puff');
        DepleteSubAmmo();
    }

    default
    {
        Tag "Machine Gun";
        Inventory.PickupMessage "Machine Gun";
        Weapon.AmmoGive1 30;
        Weapon.AmmoType1 'TOB_Clip';
        Weapon.UpSound "weapons/machinegun/select";
        TOB_ReloadingWeapon.SubAmmo1Type 'TOB_MachineGunRound';
        TOB_ReloadingWeapon.SubAmmo1Use 1;
    }

    states
    {
    Ready:
        MCHG A 1 A_TOBWeaponReady();
        loop;
    Deselect:
        MCHG A 1 A_Lower(24);
        loop;
    Select:
        MCHG A 1 A_Raise(12);
        loop;
    Fire:
        MCHG AA 1 A_WeaponOffset(0, -6, WOF_ADD);
    Hold:
        "####" "#" 0 A_Light(random[TOB_MachineGun](1, 2));
        MCHF A 2 Bright A_Flash(160, 104);

        "####" "#" 0 A_FireMachineGun();
        "####" "#" 0 A_PlayMachineGunSound();
        "####" "#" 0 A_Light(0);
        MCHG B 2 A_WeaponOffset(random[TOB_MachineGun](-2, 2), WEAPONTOP + random[TOB_MachineGun](1, 3) - 12);

        "####" "#" 0;
        MCHG C 2 A_ReFire();
        MCHG AA 1 A_WeaponOffset(0, 6, WOF_ADD);
        goto Ready;
    Reload:
        "####" "#" 0 A_StartSound("weapons/machinegun/clipout", CHAN_AUTO);
        MCHG A 1 A_WeaponOffset(0, 32, WOF_INTERPOLATE);
        MCHG A 1 A_WeaponOffset(1, 42, WOF_INTERPOLATE);
        MCHG A 1 A_WeaponOffset(3, 48, WOF_INTERPOLATE);

        MCHR A 1 A_WeaponOffset(9, 49, WOF_INTERPOLATE);
        MCHR A 1 A_WeaponOffset(17, 45, WOF_INTERPOLATE);
        MCHR A 1 A_WeaponOffset(25, 38, WOF_INTERPOLATE);
        MCHR A 1 A_WeaponOffset(32, 28, WOF_INTERPOLATE);
        MCHR A 1 A_WeaponOffset(39, 18, WOF_INTERPOLATE);
        MCHR A 1 A_WeaponOffset(44, 8, WOF_INTERPOLATE);

        "####" "#" 0 A_Overlay(LAYER_HAND, 'Reload_Hand');
        "####" "#" 0 A_WeaponOffset(48, 0, WOF_INTERPOLATE);
        MCHR A 12;

        "####" "#" 0 A_Reload();
        MCHR A 1 A_WeaponOffset(44, 8, WOF_INTERPOLATE);
        MCHR A 1 A_WeaponOffset(39, 18, WOF_INTERPOLATE);
        MCHR A 1 A_WeaponOffset(32, 28, WOF_INTERPOLATE);
        MCHR A 1 A_WeaponOffset(25, 38, WOF_INTERPOLATE);
        MCHR A 1 A_WeaponOffset(17, 45, WOF_INTERPOLATE);
        MCHR A 1 A_WeaponOffset(9, 49, WOF_INTERPOLATE);

        "####" "#" 0 A_ClearOverlays(LAYER_HAND, LAYER_HAND);
        MCHG A 1 A_WeaponOffset(3, 48, WOF_INTERPOLATE);
        MCHG A 1 A_WeaponOffset(1, 42, WOF_INTERPOLATE);
        goto Ready;
    Reload_Hand:
        "####" "#" 0 A_OverlayOffset(LAYER_HAND, 0, 128);
        "####" "#" 0 A_StartSound("weapons/machinegun/clipin", CHAN_AUTO);
        MCHR "BBBBBBBBB" 1 A_OverlayOffset(LAYER_HAND, 0, -13, WOF_ADD);
        "####" "#" 0 A_OverlayOffset(LAYER_HAND, 0, 0, WOF_INTERPOLATE);
        MCHR B 2 A_WeaponOffset(0, -8, WOF_ADD);
        MCHR B -1 A_WeaponOffset(0, 8, WOF_ADD);
        stop;
    AltFire:
        MGRG A 1 A_TOBWeaponReady();
        loop;
    Spawn:
        MCHW A -1;
        stop;
    }
}

//
// DUAL MACHINE GUN TEST SHIT AHHHHHH
//

class TOB_DualMachineGuns : TOB_MachineGun
{
    //
    // constants
    //

    const TOB_PSP_RIGHT = PSP_WEAPON + 3;
    const TOB_PSP_LEFT  = PSP_WEAPON + 2;

    //
    // actions
    //

    action State A_DualReFire(int fireMode = Weapon.PrimaryFire)
    {
        let button = BT_ATTACK;
        let wst = WF_WEAPONREADY;
        let st = ResolveState('Dual_Hold');

        if (fireMode == Weapon.AltFire)
        {
            button = BT_ALTATTACK;
            let wst = WF_WEAPONREADYALT;
            st = ResolveState('Dual_AltHold');
        }

        if ((player.weaponState & wst) && (player.buttons & button))
        {
            return st;
        }

        return ResolveState(null);
    }

    //
    // overrides
    //

    override void DoEffect()
    {
        super.DoEffect();

        let pp = TOB_Util.GetPlayerOwnerForInventory(self);
        if (!pp || !pp.player || !pp.player.readyWeapon || self != pp.player.readyWeapon)
        {
            return;
        }

        let primaryCanFire = (pp.player.weaponState & WF_WEAPONREADY)
            && !pp.player.GetPSprite(TOB_PSP_LEFT).curState.InStateSequence(ResolveState('Dual_Fire'));

        if (primaryCanFire && (pp.player.buttons & BT_ATTACK))
        {
            pp.player.SetPSprite(TOB_PSP_LEFT, ResolveState('Dual_Fire'));
        }

        let altCanFire = (pp.player.weaponState & WF_WEAPONREADYALT)
            && !pp.player.GetPSprite(TOB_PSP_RIGHT).curState.InStateSequence(ResolveState('Dual_AltFire'));

        if (altCanFire && (pp.player.buttons & BT_ALTATTACK))
        {
            pp.player.SetPSprite(TOB_PSP_RIGHT, ResolveState('Dual_AltFire'));
        }
    }

    //
    // decorate
    //

    default
    {
        Weapon.AmmoGive2 30;
        Weapon.AmmoType2 'TOB_Clip';
        TOB_ReloadingWeapon.SubAmmo2Type 'TOB_MachineGunRound';
        TOB_ReloadingWeapon.SubAmmo2Use 1;
    }

    states
    {
    Ready:
        TNT1 A 0 A_Overlay(TOB_PSP_RIGHT, 'Dual_AltReady', true);
        TNT1 A 0 A_Overlay(TOB_PSP_LEFT, 'Dual_Ready', true);
        TNT1 A 0 A_OverlayFlags(TOB_PSP_LEFT, PSPF_FLIP|PSPF_MIRROR, true);
        TNT1 A 1 A_TOBWeaponReady();
        wait;
    Dual_AltReady:
        MCHH A 1;
        loop;
    Dual_Ready:
        MCHI A 1;
        loop;
    Fire:
    AltFire:
        goto Ready;
    Dual_AltFire:
        MCHH AA 1 A_OverlayOffset(TOB_PSP_RIGHT, 0.25, 0.25, WOF_ADD);
        MCHH AA 1 A_OverlayOffset(TOB_PSP_RIGHT, 0.5, 0.5, WOF_ADD);
        MCHH AAAA 1 A_OverlayOffset(TOB_PSP_RIGHT, 1, 1, WOF_ADD);
    Dual_AltHold:
        "####" "#" 0 A_FireMachineGun();
        "####" "#" 0 A_PlayMachineGunSound();
        "####" "#" 0 A_Light(randompick(1, 2));
        "####" "#" 0 A_Flash(216, 96, layer: DEFAULT_FLASH_LAYER);
        MCHH BB 1 A_OverlayOffset(TOB_PSP_RIGHT, random[TOB_MachineGun](-4, 4), random[TOB_MachineGun](-4, 4));
        "####" "#" 0 A_Light(0);
        "####" A 2 A_OverlayOffset(TOB_PSP_RIGHT, 0, 0);
        "####" "####" 1 A_DualReFire(Weapon.AltFire);
        goto Dual_AltReady;
    Dual_Fire:
        MCHI AA 1 A_OverlayOffset(TOB_PSP_LEFT, 0.25, 0.25, WOF_ADD);
        MCHI AA 1 A_OverlayOffset(TOB_PSP_LEFT, 0.5, 0.5, WOF_ADD);
        MCHI AAAA 1 A_OverlayOffset(TOB_PSP_LEFT, 1, 1, WOF_ADD);
    Dual_Hold:
        "####" "#" 0 A_FireMachineGun();
        "####" "#" 0 A_PlayMachineGunSound();
        "####" "#" 0 A_Light(randompick(1, 2));
        "####" "#" 0 A_Flash(216, 96, layer: DEFAULT_FLASH_LAYER + 1, extraFlags: PSPF_MIRROR);
        MCHI BB 1 A_OverlayOffset(TOB_PSP_LEFT, random[TOB_MachineGun](-4, 4), random[TOB_MachineGun](-4, 4));
        "####" "#" 0 A_Light(0);
        "####" A 2 A_OverlayOffset(TOB_PSP_LEFT, 0, 0);
        "####" "####" 1 A_DualReFire();
        goto Dual_Ready;
    Reload:
        TNT1 A 8 A_Overlay(TOB_PSP_LEFT, 'Dual_Reload', false);
        TNT1 A 0 A_Overlay(TOB_PSP_RIGHT, 'Dual_AltReload', false);
        TNT1 A 35 A_OverlayFlags(TOB_PSP_LEFT, PSPF_FLIP|PSPF_MIRROR, true);
        goto Ready;
    Dual_Reload:
        "####" "#" 0 A_StartSound("weapons/machinegun/clipout", CHAN_AUTO);
        MCHG A 1 A_OverlayOffset(TOB_PSP_LEFT, 0, 32 - 32, WOF_INTERPOLATE);
        MCHG A 1 A_OverlayOffset(TOB_PSP_LEFT, 1, 42 - 32, WOF_INTERPOLATE);
        MCHG A 1 A_OverlayOffset(TOB_PSP_LEFT, 3, 48 - 32, WOF_INTERPOLATE);

        MCHR A 1 A_OverlayOffset(TOB_PSP_LEFT, 9, 49 - 32, WOF_INTERPOLATE);
        MCHR A 1 A_OverlayOffset(TOB_PSP_LEFT, 17, 45 - 32, WOF_INTERPOLATE);
        MCHR A 1 A_OverlayOffset(TOB_PSP_LEFT, 25, 38 - 32, WOF_INTERPOLATE);
        MCHR A 1 A_OverlayOffset(TOB_PSP_LEFT, 32, 28 - 32, WOF_INTERPOLATE);
        MCHR A 1 A_OverlayOffset(TOB_PSP_LEFT, 39, 18 - 32, WOF_INTERPOLATE);
        MCHR A 1 A_OverlayOffset(TOB_PSP_LEFT, 44, 8 - 32, WOF_INTERPOLATE);

        "####" "#" 0 A_Overlay(LAYER_HAND, 'Reload_Hand');
        "####" "#" 0 A_OverlayOffset(TOB_PSP_LEFT, 48, 0 - 32, WOF_INTERPOLATE);
        MCHR A 12;

        "####" "#" 0 A_Reload();
        MCHR A 1 A_OverlayOffset(TOB_PSP_LEFT, 44, 8 - 32, WOF_INTERPOLATE);
        MCHR A 1 A_OverlayOffset(TOB_PSP_LEFT, 39, 18 - 32, WOF_INTERPOLATE);
        MCHR A 1 A_OverlayOffset(TOB_PSP_LEFT, 32, 28 - 32, WOF_INTERPOLATE);
        MCHR A 1 A_OverlayOffset(TOB_PSP_LEFT, 25, 38 - 32, WOF_INTERPOLATE);
        MCHR A 1 A_OverlayOffset(TOB_PSP_LEFT, 17, 45 - 32, WOF_INTERPOLATE);
        MCHR A 1 A_OverlayOffset(TOB_PSP_LEFT, 9, 49 - 32, WOF_INTERPOLATE);

        "####" "#" 0 A_ClearOverlays(LAYER_HAND, LAYER_HAND);
        MCHG A 1 A_OverlayOffset(TOB_PSP_LEFT, 3, 48 - 32, WOF_INTERPOLATE);
        MCHG A 1 A_OverlayOffset(TOB_PSP_LEFT, 1, 42 - 32, WOF_INTERPOLATE);

        MCHG A 0 A_OverlayOffset(TOB_PSP_LEFT, 0, 0, WOF_INTERPOLATE);
        goto Dual_Ready;
    Dual_AltReload:
        "####" "#" 0 A_StartSound("weapons/machinegun/altclipout", CHAN_AUTO);
        MCHG A 1 A_OverlayOffset(TOB_PSP_RIGHT, 0, 32 - 32, WOF_INTERPOLATE);
        MCHG A 1 A_OverlayOffset(TOB_PSP_RIGHT, 1, 42 - 32, WOF_INTERPOLATE);
        MCHG A 1 A_OverlayOffset(TOB_PSP_RIGHT, 3, 48 - 32, WOF_INTERPOLATE);

        MCHR A 1 A_OverlayOffset(TOB_PSP_RIGHT, 9, 49 - 32, WOF_INTERPOLATE);
        MCHR A 1 A_OverlayOffset(TOB_PSP_RIGHT, 17, 45 - 32, WOF_INTERPOLATE);
        MCHR A 1 A_OverlayOffset(TOB_PSP_RIGHT, 25, 38 - 32, WOF_INTERPOLATE);
        MCHR A 1 A_OverlayOffset(TOB_PSP_RIGHT, 32, 28 - 32, WOF_INTERPOLATE);
        MCHR A 1 A_OverlayOffset(TOB_PSP_RIGHT, 39, 18 - 32, WOF_INTERPOLATE);
        MCHR A 1 A_OverlayOffset(TOB_PSP_RIGHT, 44, 8 - 32, WOF_INTERPOLATE);

        "####" "#" 0 A_Overlay(LAYER_HAND, 'Dual_AltReload_Hand');
        "####" "#" 0 A_OverlayOffset(TOB_PSP_RIGHT, 48, 0 - 32, WOF_INTERPOLATE);
        MCHR A 12;

        "####" "#" 0 A_Reload();
        MCHR A 1 A_OverlayOffset(TOB_PSP_RIGHT, 44, 8 - 32, WOF_INTERPOLATE);
        MCHR A 1 A_OverlayOffset(TOB_PSP_RIGHT, 39, 18 - 32, WOF_INTERPOLATE);
        MCHR A 1 A_OverlayOffset(TOB_PSP_RIGHT, 32, 28 - 32, WOF_INTERPOLATE);
        MCHR A 1 A_OverlayOffset(TOB_PSP_RIGHT, 25, 38 - 32, WOF_INTERPOLATE);
        MCHR A 1 A_OverlayOffset(TOB_PSP_RIGHT, 17, 45 - 32, WOF_INTERPOLATE);
        MCHR A 1 A_OverlayOffset(TOB_PSP_RIGHT, 9, 49 - 32, WOF_INTERPOLATE);

        "####" "#" 0 A_ClearOverlays(LAYER_HAND, LAYER_HAND);
        MCHG A 1 A_OverlayOffset(TOB_PSP_RIGHT, 3, 48 - 32, WOF_INTERPOLATE);
        MCHG A 1 A_OverlayOffset(TOB_PSP_RIGHT, 1, 42 - 32, WOF_INTERPOLATE);

        MCHG A 0 A_OverlayOffset(TOB_PSP_RIGHT, 0, 0, WOF_INTERPOLATE);
        goto Dual_AltReady;
    Dual_AltReload_Hand:
        "####" "#" 0 A_OverlayOffset(LAYER_HAND, 0, 128);
        "####" "#" 0 A_StartSound("weapons/machinegun/altclipin2", CHAN_AUTO);
        MCHR "BBBBBBBBB" 1 A_OverlayOffset(LAYER_HAND, 0, -13, WOF_ADD);
        "####" "#" 0 A_OverlayOffset(LAYER_HAND, 0, 0, WOF_INTERPOLATE);
        MCHR B 2 A_WeaponOffset(0, -8, WOF_ADD);
        MCHR B -1 A_WeaponOffset(0, 8, WOF_ADD);
        stop;
    }
}
