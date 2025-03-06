mixin class TOB_BasicGrenadeThrowerMixin
{
    states
    {
    TOB_ThrowGrenade:
        "####" "####" 1 A_WeaponOffset(0, 32, WOF_ADD);
        WTND AAAA 1 A_WeaponOffset(0, -32, WOF_ADD);
        WTNE ABCC 1 A_WeaponOffset(0, 4, WOF_ADD);
        WTNE C 4 A_StartSound("weapons/grenade/pin", CHAN_AUTO);
        TNT1 A 0 A_WeaponOffset(0, 32);
        WTND B 2 A_WeaponOffset(32, -16, WOF_ADD);
        WTND B 4 A_WeaponOffset(-8, 4, WOF_ADD);
        "####" "####" 1 A_WeaponOffset(32, 8, WOF_ADD);
        TNT1 A 1 {
            A_WeaponOffset(0, 32);

            let grit = TOB_GrenadeItem(FindInventory('TOB_GrenadeItem'));
            if (grit)
            {
                grit.UseOneFrom(PlayerPawn(self));
            }
        }
        WTND C 1 A_WeaponOffset(-80, 24, WOF_ADD);
        WTND C 1 A_WeaponOffset(-80, 24, WOF_ADD);
        WTND D 1 A_WeaponOffset(-64, 24, WOF_ADD);
        WTND E 1 A_WeaponOffset(-16, 8, WOF_ADD);
        WTND E 2 A_WeaponOffset(-8, 4, WOF_ADD);
        WTND E 3 A_WeaponOffset(8, -4, WOF_ADD);
        "####" "####" 1 A_WeaponOffset(48, 32, WOF_ADD);
        TNT1 A 5 A_WeaponOffset(0, WEAPONBOTTOM);
        goto TOB_BasicGrenadeThrowerMixin_End;
    TOB_ThrowTeslaGrenade:
        "####" "####" 1 A_WeaponOffset(0, 32, WOF_ADD);
        WTGG AAAA 1 A_WeaponOffset(0, -32, WOF_ADD);
        "####" ABCD 1 A_WeaponOffset(0, 4, WOF_ADD);
        WTGG A 4 A_StartSound("weapons/grenade/pin", CHAN_AUTO);
        TNT1 A 0 A_WeaponOffset(0, 32);
        "####" "#" 0 A_StartSound("weapons/tesla/idle", CHAN_AUTO);
        "####" "#" 0 A_Overlay(PSP_WEAPON + 2, 'TOB_ThrowTeslaGrenade_Overlay');
        WTGG A 2 A_WeaponOffset(32, -16, WOF_ADD);
        WTGG A 4 A_WeaponOffset(-8, 4, WOF_ADD);
        "####" "####" 1 A_WeaponOffset(32, 8, WOF_ADD);
        TNT1 A 1 {
            A_WeaponOffset(0, 32);

            let grit = TOB_TeslaGrenadeItem(FindInventory('TOB_TeslaGrenadeItem'));

            if (grit)
            {
                grit.UseOneFrom(PlayerPawn(self));
            }
        }
        WTND C 1 A_WeaponOffset(-80, 24, WOF_ADD);
        WTND C 1 A_WeaponOffset(-80, 24, WOF_ADD);
        WTND D 1 A_WeaponOffset(-64, 24, WOF_ADD);
        WTND E 1 A_WeaponOffset(-16, 8, WOF_ADD);
        WTND E 2 A_WeaponOffset(-8, 4, WOF_ADD);
        WTND E 3 A_WeaponOffset(8, -4, WOF_ADD);
        "####" "####" 1 A_WeaponOffset(48, 32, WOF_ADD);
        TNT1 A 5 A_WeaponOffset(0, WEAPONBOTTOM);
        goto TOB_BasicGrenadeThrowerMixin_End;
    TOB_ThrowTeslaGrenade_Overlay:
        WTGF A 1 Bright;
        WTGF C 1 Bright;
        WTGF B 1 Bright;
        WTGF D 1 Bright;
        stop;
    TOB_BasicGrenadeThrowerMixin_End:
        TNT1 A 0 {
            return ResolveState('Select');
        }
        goto Ready;
    }
}
