class TOB_PistolRound : Ammo
{
    default
    {
        Inventory.MaxAmount 8;
        +Inventory.IGNORESKILL;
    }
}

class TOB_Pistol : TOB_ReloadingWeapon
{
    const LAYER_HAND = -2;

    action void A_PlayPistolSound()
    {
        invoker.PlayPistolSound();
    }

    action void A_FirePistol()
    {
        invoker.FirePistol();
    }

    virtual void PlayPistolSound()
    {
        owner.A_StartSound("weapons/pistol/fire", CHAN_WEAPON);
    }

    virtual void FirePistol()
    {
        TOBFireBullets(2.8, 2.8, puffType: 'TOB_Puff');
        DepleteSubAmmo();
    }

    default
    {
        Tag "Pistol";
        Inventory.PickupMessage "Pistol";
        Weapon.AmmoGive1 8;
        Weapon.AmmoType1 'TOB_Clip';
        Weapon.UpSound "weapons/pistol/select";
        TOB_ReloadingWeapon.SubAmmo1Type 'TOB_PistolRound';
        TOB_ReloadingWeapon.SubAmmo1Use 1;

        +Weapon.WIMPY_WEAPON;
        +Weapon.NOAUTOFIRE;
        +TOB_ReloadingWeapon.SUBAMMO2OPTIONAL;
    }

    states
    {
    Ready:
        PSTG A 1 A_TOBWeaponReady();
        loop;
    Deselect:
        PSTG A 1 A_Lower(24);
        loop;
    Select:
        PSTG A 1 A_Raise(12);
        loop;
    Fire:
        PSTG A 0;
        "####" "##" 1 A_WeaponOffset(0, -6, WOF_ADD);
    Hold:
        PSTF A 0;
        "####" "#" 0 A_Light(random(1, 2));
        "####" "#" 0 A_Flash(160, 110);
        "####" A 1 Bright A_TOBWeaponReady();

        PSTG A 0;
        "####" "#" 0 A_Light(0);
        "####" "#" 0 A_FirePistol();
        "####" "#" 0 A_PlayPistolSound();
        "####" BB 1 A_TOBWeaponReady();

        "####" "#" 0 A_WeaponOffset(random(-4, 4), WEAPONTOP + random(0, -8));
        "####" CCDD 1 A_TOBWeaponReady();
        goto Ready;
    Reload:
        PSTG A 0;
        "####" C 0 A_StartSound("weapons/pistol/clipout", CHAN_AUTO);
        "####" "#" 1 A_WeaponOffset(0, 32, WOF_INTERPOLATE);
        "####" "#" 1 A_WeaponOffset(1, 42, WOF_INTERPOLATE);
        "####" "#" 1 A_WeaponOffset(3, 48, WOF_INTERPOLATE);

        PSTR A 0;
        "####" "#" 1 A_WeaponOffset(9, 49, WOF_INTERPOLATE);
        "####" "#" 1 A_WeaponOffset(17, 45, WOF_INTERPOLATE);
        "####" "#" 1 A_WeaponOffset(25, 38, WOF_INTERPOLATE);
        "####" "#" 1 A_WeaponOffset(32, 28, WOF_INTERPOLATE);
        "####" "#" 1 A_WeaponOffset(39, 18, WOF_INTERPOLATE);
        "####" "#" 1 A_WeaponOffset(44, 8, WOF_INTERPOLATE);

        "####" "#" 0 A_Overlay(LAYER_HAND, 'Reload_Hand');
        "####" "#" 0 A_WeaponOffset(48, 0, WOF_INTERPOLATE);
        "####" "#" 10;

        "####" "#" 0 A_Reload();
        "####" "#" 1 A_WeaponOffset(44, 8, WOF_INTERPOLATE);
        "####" "#" 1 A_WeaponOffset(39, 18, WOF_INTERPOLATE);
        "####" "#" 1 A_WeaponOffset(32, 28, WOF_INTERPOLATE);

        PSTG A 0;
        "####" D 1 A_WeaponOffset(25, 38, WOF_INTERPOLATE);
        "####" "#" 1 A_WeaponOffset(17, 45, WOF_INTERPOLATE);
        "####" "#" 1 A_WeaponOffset(9, 49, WOF_INTERPOLATE);
        "####" "#" 0 A_ClearOverlays(LAYER_HAND, LAYER_HAND);
        "####" A 1 A_WeaponOffset(3, 48, WOF_INTERPOLATE);
        "####" A 1 A_WeaponOffset(1, 42, WOF_INTERPOLATE);
        goto Ready;
    Reload_Hand:
        PSTR B 1 A_OverlayOffset(LAYER_HAND, -1 * 20, 3 * 20);
        "####" "#" 0 A_StartSound("weapons/pistol/clipin", CHAN_AUTO);
        "####" "###" 1 A_OverlayOffset(LAYER_HAND, 1 * 6, -3 * 6, WOF_ADD);
        "####" "#" 0 A_OverlayOffset(LAYER_HAND, 0, 0);
        "####" "#" 2 A_WeaponOffset(0, -6, WOF_ADD);
        "####" "#" -1 A_WeaponOffset(0, 6, WOF_ADD);
        stop;
    Spawn:
        PSTW A -1;
        stop;
    }
}
