class TOB_DualPistolRound : Ammo
{
    default
    {
        Inventory.MaxAmount 8;
        +Inventory.IGNORESKILL;
    }
}

class TOB_DualPistols : TOB_Pistol
{
    default
    {
        TOB_ReloadingWeapon.SubAmmo2Type 'TOB_DualPistolRound';
        TOB_ReloadingWeapon.SubAmmo2Use 1;

        -TOB_ReloadingWeapon.SUBAMMO2OPTIONAL;
    }

    states
    {
    Ready:
        TNT1 A 0 {
            A_Overlay(3, 'RightHand_Ready');
            A_Overlay(4, 'LeftHand_Ready');
            A_OverlayFlags(4, PSPF_FLIP, true);
            A_OverlayOffset(3, 50, 0, WOF_ADD);
            A_OverlayOffset(4, -100, 0, WOF_ADD);
        }
        TNT1 A 1 A_TOBWeaponReady();
        wait;
    RightHand_Ready:
        PSTG A 1;
        loop;
    LeftHand_Ready:
        PSTG A 1;
        loop;
    Fire:
        TNT1 A 1 {
        }
        goto Ready + 1;
    }
}
