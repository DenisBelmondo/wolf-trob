class TOB_PortableMedkitWeapon : TOB_Weapon
{
    Weapon prevWeapon;

    override State GetAtkState(bool hold)
    {
        if (owner.health >= owner.GetSpawnHealth())
        {
            if (prevWeapon)
            {
                owner.player.pendingWeapon = prevWeapon;
            }

            return super.GetReadyState();
        }

        return super.GetAtkState(hold);
    }

    default
    {
        Tag "Portable Medkit";
        Inventory.Icon "WPMKA0";
        Weapon.UpSound "inventory/portable_medkit/lower";
        +Weapon.CHEATNOTWEAPON;
    }

    states
    {
    Ready:
        WWMK A 1 A_TOBWeaponReady();
        loop;
    Select:
        WWMK A 1 A_Raise(12);
        loop;
    Deselect:
        WWMK A 1 A_Lower(12);
        loop;
    Fire:
        "####" "#" 0 A_StartSound("inventory/portable_medkit/open", CHAN_WEAPON);
        // lower weapon
        "####" "######" 1 A_WeaponOffset(0, WEAPONBOTTOM / 6, WOF_ADD);
    Syringe_Master:
        // bring up arm
        WSYR A 1 A_WeaponOffset(-64, WEAPONTOP + 64);
        "####" "##" 1 A_WeaponOffset(24, -24, WOF_ADD);
        "####" "#" 1 A_WeaponOffset(16, -16, WOF_ADD);
        "####" "#" 1 A_WeaponOffset(8, -8, WOF_ADD);

        // TODO: symbolize layer number
        "####" "#" 0 A_Overlay(1002, 'Overlay_HandWithSyringe');

        // wait for overlay
        "####" "#" 18 A_WeaponOffset(0, WEAPONTOP);

        // lower
        "####" "######" 1 A_WeaponOffset(0, 24, WOF_ADD);

        // done
        "####" "#" 0 A_ClearOverlays(1002, 1002);
        // "####" "#" 0 A_Jump(256, 'Select');
        // goto Ready;
    WrapBandage_Master:
        WWRP A 0 A_WeaponOffset(0, WEAPONBOTTOM);
        "####" "#" 0 A_StartSound("inventory/bandage/bg", CHAN_6);

        "####" "####" 1 A_WeaponOffset(0, WEAPONBOTTOM / -4, WOF_ADD);
        "####" "#" 1 A_WeaponOffset(8, -4, WOF_ADD);
        "####" "#" 1 A_WeaponOffset(4, -2, WOF_ADD);
        "####" "#" 1 A_WeaponOffset(4, 0, WOF_ADD);
        "####" "#" 1 A_WeaponOffset(8, 4, WOF_ADD);
        "####" "#" 1 A_WeaponOffset(12, 6, WOF_ADD);
        "####" "######" 1 A_WeaponOffset(WEAPONBOTTOM / 6, WEAPONBOTTOM, WOF_ADD);

        "####" "#" 0 A_WeaponOffset(0, WEAPONBOTTOM);
        "####" "####" 1 A_WeaponOffset(0, WEAPONBOTTOM / -4, WOF_ADD);
        "####" "#" 1 A_WeaponOffset(8, -4, WOF_ADD);
        "####" "#" 1 A_WeaponOffset(4, -2, WOF_ADD);
        "####" "#" 1 A_WeaponOffset(4, 0, WOF_ADD);
        "####" "#" 1 A_WeaponOffset(8, 4, WOF_ADD);
        "####" "#" 1 A_WeaponOffset(12, 6, WOF_ADD);
        "####" "######" 1 A_WeaponOffset(WEAPONBOTTOM / 6, WEAPONBOTTOM, WOF_ADD);

        "####" "#" 0 A_WeaponOffset(0, WEAPONBOTTOM);
        "####" "####" 1 A_WeaponOffset(0, WEAPONBOTTOM / -4, WOF_ADD);
        "####" "#" 1 A_WeaponOffset(8, -4, WOF_ADD);
        "####" "#" 1 A_WeaponOffset(4, -2, WOF_ADD);
        "####" "#" 1 A_WeaponOffset(4, 0, WOF_ADD);
        "####" "#" 1 A_WeaponOffset(8, 4, WOF_ADD);
        "####" "#" 1 A_WeaponOffset(12, 6, WOF_ADD);
        "####" "######" 1 A_WeaponOffset(WEAPONBOTTOM / 6, WEAPONBOTTOM, WOF_ADD);

        "####" "#" 0 A_WeaponOffset(0, WEAPONBOTTOM);
        "####" "#" 0 A_StartSound("inventory/bandage/wrap", CHAN_AUTO);
        "####" "####" 1 A_WeaponOffset(0, WEAPONBOTTOM / -4, WOF_ADD);
        "####" "#" 1 A_WeaponOffset(8, -4, WOF_ADD);
        "####" "##" 1 A_WeaponOffset(16, -16, WOF_ADD);
        "####" "#" 6 A_WeaponOffset(-4, 8, WOF_ADD);
        "####" "######" 1 A_WeaponOffset(6, WEAPONBOTTOM / 6, WOF_ADD);

        "####" "#" 0 A_WeaponOffset(0, WEAPONBOTTOM);
        "####" "#" 0 A_StopSound(CHAN_6);
        "####" "#" 0 {
            health = player.health = health + 25;
            A_StartSound("inventory/medkit/use", CHAN_UI);
            A_SetBlend("White", 0.5, 17);

            A_TakeInventory('TOB_PortableMedkit', 1);

            if (!CountInv('TOB_PortableMedkit'))
            {
                if (self is 'PlayerPawn' && player && invoker.prevWeapon)
                {
                    PlayerPawn(self).player.pendingWeapon = invoker.prevWeapon;
                }

                A_TakeInventory('TOB_PortableMedkitWeapon');
                return ResolveState('Null');
            }

            return ResolveState(null);
        }
        "####" "#" 0 A_Jump(256, 'Select');
        goto Ready;
    Overlay_HandWithSyringe:
        WSYR B 1 A_OverlayOffset(1002, 64, WEAPONTOP + 64);
        "####" "##" 1 A_OverlayOffset(1002, -24, -24, WOF_ADD);
        "####" "#" 1 A_OverlayOffset(1002, -16, -16, WOF_ADD);
        "####" "#" 1 A_OverlayOffset(1002, -8, -8, WOF_ADD);
        "####" "#" 4 A_OverlayOffset(1002, 0, WEAPONTOP);
        "####" "####" 1 A_OverlayOffset(1002, -24, 24, WOF_ADD);

        "####" "#" 0 A_StartSound("inventory/syringe/insert", CHAN_AUTO);
        "####" "#" 0 A_StartSound("*pain100", CHAN_VOICE);

        "####" "###" 1 A_WeaponOffset(random[TOB_Weapon_Shake](-4, 4), WEAPONTOP + random[TOB_Weapon_Shake](-6, 6));
        "####" "#" 1 A_WeaponOffset(0, WEAPONTOP);
        "####" "#" 1;
        wait;
    }
}
