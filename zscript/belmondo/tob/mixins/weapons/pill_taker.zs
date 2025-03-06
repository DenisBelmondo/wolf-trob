mixin class TOB_PillTakerMixin
{
    states
    {
    TOB_TakePill:
        "####" "####" 1 A_WeaponOffset(0, 32);
        TNT1 A 0 A_WeaponOffset(-32, 128);
        VPIL AAAA 1 A_WeaponOffset(8, -24, WOF_ADD);
        "####" "#" 2 A_WeaponOffset(0, 32);
        VPIL AAAA 1 A_WeaponOffset(random[TOB_PillTakerMixin](-4, 4), random[TOB_PillTakerMixin](-4, 4), WOF_ADD);
        VPIL ABCDE 1 {
            A_WeaponOffset(16, 16, WOF_ADD);
            A_SetPitch(pitch - 1);
        }
        "####" "#" 7 A_StartSound("inventory/pill/swallow", CHAN_VOICE);
        "####" "##" 1 {
            A_WeaponOffset(-24, 16, WOF_ADD);
            A_SetPitch(pitch + 1);
        }
        TNT1 A 0 {
            A_WeaponOffset(0, WEAPONBOTTOM);

            let pill = TOB_Pill(FindInventory('TOB_Pill'));
            if (pill)
            {
                pill.UseOneFrom(PlayerPawn(self));
            }

            return ResolveState('Select');
        }
        goto Ready;
    }
}
