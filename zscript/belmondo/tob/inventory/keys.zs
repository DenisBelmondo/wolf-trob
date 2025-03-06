class TOB_KeySparkleSpawner : Inventory
{
    override void DoEffect()
    {
        super.DoEffect();

        owner.A_StartSound("inventory/key/sparkle", flags: CHANF_LOOPING);

        if (level.mapTime % 7 == 0)
        {
            owner.A_SpawnItemEx('TOB_KeySparkle',
                frandom[TOB_KeySparkleSpawner](-owner.radius, owner.radius),
                frandom[TOB_KeySparkleSpawner](-owner.radius, owner.radius),
                frandom[TOB_KeySparkleSpawner](0, owner.height));
        }
    }
}

class TOB_Key : Key abstract
{
    override void BeginPlay()
    {
        super.BeginPlay();

        GiveInventoryType('TOB_KeySparkleSpawner');
    }

    default
    {
        Radius 20;
        Height 16;
        Inventory.PickupSound "inventory/key/pickup";

        +NOTDMATCH;
    }

    states
    {
    Spawn:
        "####" "#" 10;
        "####" "#" 10 Bright;
        loop;
    }
}

class TOB_RedBigKey : TOB_Key
{
    default
    {
        Inventory.PickupMessage "Red key";
    }

    states
    {
    Spawn:
        WHRK A 0;
        goto super::Spawn;
    }
}

class TOB_YellowBigKey : TOB_Key
{
    default
    {
        Species "KeyYellow";
        Inventory.PickupMessage "Gold key";
    }

    states
    {
    Spawn:
        WHYK A 0;
        goto super::Spawn;
    }
}

class TOB_GreenBigKey : TOB_Key
{
    default
    {
        Species "KeyGreen";
        Inventory.PickupMessage "Green key";
    }

    states
    {
    Spawn:
        WHGK A 0;
        goto super::Spawn;
    }
}

class TOB_BlueBigKey : TOB_Key
{
    default
    {
        Species "KeyBlue";
        Inventory.PickupMessage "Blue key";
    }

    states
    {
    Spawn:
        WHBK A 10;
        goto super::Spawn;
    }
}

class TOB_RedCard : TOB_Key
{
    default
    {
        Species "RedCard";
        Inventory.PickupMessage "Red keycard";
    }

    states
    {
    Spawn:
        WRCD A 0;
        goto super::Spawn;
    }
}

class TOB_YellowCard : TOB_Key
{
    default
    {
        Species "YellowCard";
        Inventory.PickupMessage "Yellow keycard";
    }

    states
    {
    Spawn:
        WYCD A 0;
        goto super::Spawn;
    }
}

class TOB_BlueCard : TOB_Key
{
    default
    {
        Species "BlueCard";
        Inventory.PickupMessage "Blue keycard";
    }

    states
    {
    Spawn:
        WBCD A 0;
        goto super::Spawn;
    }
}

class TOB_RedSkull : TOB_Key
{
    mixin TOB_Wolf3DSizedActorMixin;

    default
    {
        Species "RedSkull";
        Inventory.PickupMessage "Red skull key";
    }

    states
    {
    Spawn:
        WSKR A 0;
        goto super::Spawn;
    }
}

class TOB_YellowSkull : TOB_Key
{
    mixin TOB_Wolf3DSizedActorMixin;

    default
    {
        Species "YellowSkull";
        Inventory.PickupMessage "Yellow skull key";
    }

    states
    {
    Spawn:
        WSKY A 0;
        goto super::Spawn;
    }
}

class TOB_BlueSkull : TOB_Key
{
    mixin TOB_Wolf3DSizedActorMixin;

    default
    {
        Species "BlueSkull";
        Inventory.PickupMessage "Blue skull key";
    }

    states
    {
    Spawn:
        WSKB A 0;
        goto super::Spawn;
    }
}
