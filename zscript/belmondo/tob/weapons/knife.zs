class TOB_KnifePuff : Tob_Particle
{
    default
    {
        SeeSound "weapons/knife/slash";
        AttackSound "weapons/knife/miss";
        DamageType 'Knife';

        +PUFFONACTORS;
    }

    states
    {
    Crash:
        TNT1 AAAA 0 A_SpawnParticle(
            "LightGrey",
            SPF_RELPOS|SPF_RELVEL|SPF_RELANG|SPF_NOTIMEFREEZE,
            10, 4,
            random(-10, 10),
            vely: frandom(-2, 2), velz: frandom(1, 4),
            accelz: -0.5,
            sizestep: -0.1
        );
        TNT1 A -1;
        stop;
    }
}

class TOB_Knife : TOB_Weapon
{
    default
    {
        Tag "Knife";
        Scale 0.66666666;
        Inventory.PickupMessage "Knife";
        Weapon.UpSound "weapons/knife/select";

        +Weapon.NOALERT;
        +Weapon.WIMPY_WEAPON;
        +Weapon.NOAUTOFIRE;
    }

    states
    {
    Ready:
        WKFG A 1 A_TOBWeaponReady();
        loop;
    Deselect:
        WKFG A 1 A_Lower(24);
        loop;
    Select:
        WKFG A 1 A_Raise(24);
        loop;
    Fire:
        "####" "#" 0 A_AlertMonsters(128);
        WKFG AA 1 A_WeaponOffset(4, 4, WOF_ADD);
        WKFG AA 1 A_WeaponOffset(2, 2, WOF_ADD);
        TNT1 A 0 A_WeaponOffset(0, WEAPONTOP);
    Hold:
        TNT1 A 0 A_StartSound("weapons/knife/fire", CHAN_WEAPON);
        WKFG BB 1 A_WeaponOffset(-12, -12, WOF_ADD);
        WKFG C 1 A_WeaponOffset(4, 4, WOF_ADD);
        TNT1 A 0 A_CustomPunch(10, true, puffType: 'TOB_KnifePuff', range: 96);
        WKFG D 1;
        WKFG DD 1 A_WeaponOffset(1, 1, WOF_ADD);
        WKFG BB 1 A_WeaponOffset(2, 2, WOF_ADD);
        WKFG A 1 A_WeaponOffset(4, 4, WOF_ADD);
        TNT1 A 0 A_WeaponOffset(0, WEAPONTOP);
        goto Ready;
    Spawn:
        WKFW A -1;
        stop;
    }
}
