class TOB_Clip : Ammo
{
    mixin TOB_AmountInPickupMessage;

    default
    {
        Tag "Light Ammo";
        Ammo.BackpackAmount 8;
        Ammo.BackpackMaxAmount 400;
        Inventory.Icon 'graphics/belmondo/tob/g_bullet.png';
        Inventory.PickupMessage "\cfLight \ckammo";
        Inventory.Amount 8;
        Inventory.MaxAmount 200;
        Inventory.PickupSound "inventory/ammo/pickup";
    }

    states
    {
    Spawn:
        WCLP A -1;
        stop;
    }
}

class TOB_BigClip : TOB_Clip
{
    default
    {
        Inventory.Amount 16;
    }

    states
    {
    Spawn:
        WCP2 A -1;
        stop;
    }
}

class TOB_ClipBox : TOB_Clip
{
    default
    {
        Inventory.Amount 40;
        Inventory.PickupSound "inventory/ammobox/pickup";
    }

    states
    {
    Spawn:
        WCPB A -1;
        stop;
    }
}

class TOB_StripperClip : Ammo
{
    mixin TOB_AmountInPickupMessage;

    default
    {
        Tag "Heavy Ammo";
        Inventory.PickupMessage "\caHeavy \ckammo";
        Inventory.Amount 5;
        Inventory.MaxAmount 50;
        Ammo.BackpackAmount 5;
        Ammo.BackpackMaxAmount 100;
        Inventory.Icon 'graphics/belmondo/tob/g_rbullet.png';
        Inventory.PickupSound "inventory/ammo/pickup";
    }

    states
    {
    Spawn:
        WSCP A -1;
        stop;
    }
}

class TOB_StripperClipBox : TOB_StripperClip
{
    default
    {
        Inventory.Amount 25;
        Inventory.PickupSound "inventory/ammobox/pickup";
    }

    states
    {
    Spawn:
        WSCB A -1;
        stop;
    }
}

class TOB_AssaultClip : Ammo
{
    mixin TOB_AmountInPickupMessage;

    default
    {
        Tag "Assault Ammo";
        Inventory.PickupMessage "\cyAssault \ckammo";
        Inventory.Amount 15;
        Inventory.MaxAmount 150;
        Inventory.PickupSound "inventory/ammo/pickup";
        Ammo.BackpackAmount 15;
        Ammo.BackpackMaxAmount 300;
        Inventory.Icon 'graphics/belmondo/tob/g_kurz.png';
    }

    states
    {
    Spawn:
        ACLP A -1;
        stop;
    }
}

class TOB_AssaultClipBox : TOB_AssaultClip
{
    default
    {
        Inventory.Amount 30;
        Inventory.PickupSound "inventory/ammobox/pickup";
    }

    states
    {
    Spawn:
        ACBX A -1;
        stop;
    }
}

class TOB_RocketAmmo : Ammo
{
    mixin TOB_Wolf3DSizedActorMixin;
    mixin TOB_AmountInPickupMessage;

    default
    {
        Tag "Rockets";
        Inventory.PickupMessage "Rockets";
        Inventory.Amount 1;
        Inventory.MaxAmount 10;
        Inventory.PickupSound "inventory/ammo/pickup";
        Ammo.BackpackAmount 5;
        Ammo.BackpackMaxAmount 20;
        Inventory.Icon 'graphics/belmondo/tob/g_rocket.png';
    }

    states
    {
    Spawn:
        RAMO A -1;
        stop;
    }
}

class TOB_RocketBox : TOB_RocketAmmo
{
    mixin TOB_Wolf3DSizedActorMixin;

    default
    {
        Inventory.Amount 5;
        Inventory.PickupSound "inventory/ammobox/pickup";
    }

    states
    {
    Spawn:
        WRBX A -1;
        stop;
    }
}

class TOB_FuelAmmo : Ammo
{
    mixin TOB_AmountInPickupMessage;

    default
    {
        Tag "Fuel";
        Inventory.PickupMessage "Fuel";
        Inventory.Amount 25;
        Inventory.MaxAmount 100;
        Inventory.PickupSound "inventory/ammo/pickup";
        Ammo.BackpackAmount 25;
        Ammo.BackpackMaxAmount 200;
        Inventory.Icon 'graphics/belmondo/tob/g_fuel.png';
    }

    states
    {
    Spawn:
        JCAN A -1;
        stop;
    }
}

class TOB_FuelBox : TOB_FuelAmmo
{
    default
    {
        Inventory.Amount 50;
        Inventory.PickupSound "inventory/ammobox/pickup";
    }

    states
    {
    Spawn:
        FTNK A -1;
        stop;
    }
}

class TOB_BatteryAmmo : Ammo
{
    mixin TOB_AmountInPickupMessage;

    default
    {
        Tag "Battery";
        Inventory.PickupMessage "Battery";
        Inventory.Amount 20;
        Inventory.MaxAmount 300;
        Inventory.PickupSound "inventory/ammo/pickup";
        Ammo.BackpackAmount 20;
        Ammo.BackpackMaxAmount 600;
        Inventory.Icon 'graphics/belmondo/tob/g_fuel.png';

        +BRIGHT;
    }

    states
    {
    Spawn:
        TAMO A -1;
        stop;
    }
}

class TOB_BatteryBox : TOB_BatteryAmmo
{
    default
    {
        Inventory.Amount 100;
        Inventory.PickupSound "inventory/ammobox/pickup";
    }

    states
    {
    Spawn:
        TBOX A -1;
        stop;
    }
}
