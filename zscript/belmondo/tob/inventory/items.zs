class TOB_PSpriteAnimatingItem : Inventory abstract
{
    abstract void UseOneFrom(Actor a, bool takeInv = true);
    abstract StateLabel GetPSpriteStateLabel();

    virtual StateProvider GetPSpriteStateProvider()
    {
        let pp = TOB_Util.GetPlayerOwnerForInventory(self);
        if (!pp || !pp.player)
        {
            return null;
        }

        return pp.player.readyWeapon;
    }

    virtual State GetPSpriteState()
    {
        let sp = GetPSpriteStateProvider();
        if (!sp)
        {
            return null;
        }

        let sl = GetPSpriteStateLabel();
        if (!sl)
        {
            return null;
        }

        let st = sp.FindState(sl);
        if (!st)
        {
            return null;
        }

        return st;
    }

    override bool Use(bool pickup)
    {
        let pp = TOB_Util.GetPlayerOwnerForInventory(self);
        if (!pp || !pp.player)
        {
            return false;
        }

        let sp = GetPSpriteStateProvider();
        if (!sp)
        {
            return false;
        }

        let sl = GetPSpriteStateLabel();
        if (!sl)
        {
            return false;
        }

        if (pp.player.weaponState & WF_WEAPONREADY)
        {
            pp.player.SetPSprite(PSP_WEAPON, sp.FindState(sl));
        }

        return false;
    }
}

class TOB_Helmet : BasicArmorBonus
{
    mixin TOB_AmountInPickupMessage;

    default
    {
        Tag "Steel Helmet";
        Inventory.MaxAmount 0;
        Inventory.PickupMessage "Light armor";
        Inventory.PickupSound "inventory/helmet/pickup";
        Armor.SaveAmount 2;
        Armor.MaxSaveAmount 200;
        Armor.SavePercent 33.335;

        +COUNTITEM;
        +Inventory.AUTOACTIVATE;
        +Inventory.ALWAYSPICKUP;
    }

    states
    {
    Spawn:
        STHM A -1;
        stop;
    }
}

class TOB_FlakJacket : BasicArmorPickup
{
    mixin TOB_AmountInPickupMessage;

    default
    {
        Tag "Flak Jacket";
        Inventory.PickupMessage "\cdLight armor";
        Inventory.PickupSound "inventory/armor/pickup";
        Inventory.Icon 'FLAKA0';
        Armor.SavePercent 33.335;
        Armor.SaveAmount 100;
    }

    states
    {
    Spawn:
        FLAK A -1;
        stop;
    }
}

class TOB_MegaArmor : BasicArmorPickup
{
    mixin TOB_AmountInPickupMessage;

    default
    {
        Tag "Grosse Armor";
        Inventory.PickupMessage "\cyHeavy armor";
        Inventory.PickupSound "inventory/grosse/pickup";
        Inventory.Icon 'WGARA0';
        Armor.SavePercent 50;
        Armor.SaveAmount 200;
    }

    states
    {
    Spawn:
        WGAR A -1;
        stop;
    }
}

class TOB_ExtraLife : Inventory
{
    default
    {
        Tag "Extra Life";
        RenderStyle "Add";
        Inventory.Amount 1;
        Inventory.MaxAmount 9;
        Inventory.PickupMessage "Extra life!";
        Inventory.PickupSound "inventory/extralife/pickup";
    }

    states
    {
    Spawn:
        WXTR ABC 5 Bright;
        loop;
    }
}

class TOB_FloorPlans : MapRevealer
{
    default
    {
        Tag "Floor Plans";
        Inventory.MaxAmount 0;
        Inventory.PickupMessage "Floor plans";
        Inventory.PickupSound "inventory/floorplans/pickup";
        +COUNTITEM;
        +Inventory.ALWAYSPICKUP;
    }

    states
    {
    Spawn:
        WFPN A -1;
        stop;
    }
}

class TOB_Health : Health abstract
{
    override string PickupMessage()
    {
        return String.Format("+%d health", Amount);
    }
}

/*
class TOB_Wine : HealthPickup
{
    default
    {
        Tag "Bottle of Wine";
        Health 10;
        Inventory.Icon 'WWINA0';
        Inventory.MaxAmount 2;
        Inventory.PickupMessage "Bottle of wine";
        Inventory.PickupSound "inventory/wine/pickup";
        Inventory.UseSound "inventory/wine/use";

        HealthPickup.AutoUse 1;
    }

    states
    {
    Spawn:
        WWIN A -1;
        stop;
    }
} */

class TOB_Pill : TOB_PSpriteAnimatingItem
{
    override StateLabel GetPSpriteStateLabel()
    {
        return 'TOB_TakePill';
    }

    override void UseOneFrom(Actor a, bool takeInv)
    {
        a.health = a.player.health = 100;
        a.A_StartSound(default.useSound, CHAN_UI);
        a.A_SetBlend("White", 0.5, 17);

        if (takeInv)
        {
            a.TakeInventory('TOB_Pill', 1);
        }
    }

    override bool Use(bool pickup)
    {
        if (owner.health < owner.GetMaxHealth())
        {
            super.Use(pickup);
        }
        else
        {
            owner.A_StartSound("misc/noway", CHAN_UI);
        }

        return false;
    }

    default
    {
        Tag "Super Pill";
        Health 100;
        Inventory.Icon 'WPILA0';
        Inventory.Amount 1;
        Inventory.MaxAmount 1;
        Inventory.PickupMessage "Super pill";
        Inventory.PickupSound "inventory/pill/pickup";
        Inventory.UseSound "inventory/pill/use";

        +Inventory.INVBAR;
    }

    states
    {
    Spawn:
        WPIL A -1;
        stop;
    Use:
        TNT1 A -1;
        stop;
    }
}

class TOB_DogFood : TOB_Health
{
    default
    {
        Inventory.Amount 4;
        Inventory.MaxAmount 100;
        Inventory.PickupMessage "Dog food";
        Inventory.PickupSound "inventory/dogfood/pickup";
    }

    states
    {
    Spawn:
        WDFD A -1;
        stop;
    }
}

class TOB_Dinner : TOB_Health
{
    private String _pickupMessage;

    override String PickupMessage()
    {
        return _pickupMessage;
    }

    override bool TryPickup(in out Actor other)
    {
        let targetHealth = ((((other.health + amount) / 20) + 1) * 20);

        if (targetHealth > other.GetMaxHealth())
        {
            targetHealth = other.health + amount;
        }

        let healAmount = targetHealth - other.health;

        prevHealth = other.player != null ? other.player.health : other.health;
        _pickupMessage = String.Format("+%d health", healAmount);

        // P_GiveBody adds one new feature, applied only if it is possible to pick up negative health:
        // Negative values are treated as positive percentages, ie Amount -100 means 100% health, ignoring max amount.

        if (other.health < other.GetMaxHealth())
        {
            other.health += healAmount;

            if (other.player)
            {
                other.player.health += healAmount;
            }

            GoAwayAndDie();

            return true;
        }

        return false;
    }

    default
    {
        Inventory.Amount 10;
        Inventory.PickupMessage "Hot meal";
        Inventory.PickupSound "inventory/dinner/pickup";
    }

    states
    {
    Spawn:
        WDNR A -1;
        stop;
    }
}

class TOB_BigDinner : TOB_Dinner
{
    mixin TOB_Wolf3DSizedActorMixin;

    states
    {
    Spawn:
        WBDN A -1;
        stop;
    }
}

class TOB_Medkit : TOB_Health
{
    mixin TOB_Wolf3DSizedActorMixin;

    default
    {
        Inventory.Amount 25;
        Inventory.PickupMessage "First aid kit";
        Inventory.PickupSound "inventory/firstaid/pickup";
    }

    states
    {
    Spawn:
        WMED A -1;
        stop;
    }
}

class TOB_PortableMedkit : HealthPickup
{
    override bool Use(bool pickup)
    {
        if (owner.health >= owner.GetSpawnHealth())
        {
            owner.A_StartSound("misc/noway", CHAN_UI);
            return false;
        }

        if (owner.player.readyWeapon && owner.player.readyWeapon is 'TOB_PortableMedkitWeapon')
        {
            return false;
        }

        let w = TOB_PortableMedkitWeapon(owner.player.mo.FindInventory('TOB_PortableMedkitWeapon'));
        if (!w)
        {
            w = TOB_PortableMedkitWeapon(owner.player.mo.GiveInventoryType('TOB_PortableMedkitWeapon'));
        }

        w.prevWeapon = owner.player.readyWeapon;
        owner.player.pendingWeapon = w;

        return false;
    }

    default
    {
        Health 25;
        Tag "Portable Medkit";
        Inventory.Icon 'WPMKA0';
        Inventory.MaxAmount 10;
        Inventory.PickupMessage "Portable medkit";
        Inventory.PickupSound "inventory/medkit/pickup";
        Inventory.UseSound "inventory/medkit/use";

        HealthPickup.AutoUse 1;

        +COUNTITEM;
    }

    states
    {
    Spawn:
        WPMK A -1;
        stop;
    }
}

class TOB_Backpack : BackpackItem
{
    default
    {
        Inventory.PickupMessage "Backpack";
        Inventory.PickupSound "inventory/backpack/pickup";

        +COUNTITEM;
    }

    states
    {
    Spawn:
        WBKP A -1;
        stop;
    }
}

class TOB_GrenadeItem : TOB_PSpriteAnimatingItem
{
    override StateLabel GetPSpriteStateLabel()
    {
        return 'TOB_ThrowGrenade';
    }

    override void UseOneFrom(Actor a, bool takeInv)
    {
        Actor grenadeActor, a2;

        [grenadeActor, a2] = a.SpawnPlayerMissile('TOB_Grenade', noAutoAim: true);
        grenadeActor.vel.z += 5;

        if (takeInv)
        {
            a.TakeInventory('TOB_GrenadeItem', 1);
        }

        a.A_StartSound("weapons/grenade/throw", CHAN_AUTO);
        a.A_AlertMonsters();
    }

    default
    {
        Tag "Frag Grenade";
        Inventory.Icon "WGNPA0";
        Inventory.Amount 1;
        Inventory.DefMaxAmount;
        Inventory.PickupMessage "Frag grenade";
        Inventory.PickupSound "inventory/grenade/pickup";

        +Inventory.INVBAR;
    }

    states
    {
    Spawn:
        WGNP A -1;
        stop;
    Use:
        TNT1 A -1;
        stop;
    }
}

class TOB_TeslaGrenadeItem : TOB_PSpriteAnimatingItem
{
    override StateLabel GetPSpriteStateLabel()
    {
        return 'TOB_ThrowTeslaGrenade';
    }

    override void UseOneFrom(Actor a, bool takeInv)
    {
        Actor grenadeActor, a2;

        [grenadeActor, a2] = a.SpawnPlayerMissile('TOB_TeslaGrenade', noAutoAim: true);
        grenadeActor.vel.z += 5;

        if (takeInv)
        {
            a.TakeInventory('TOB_TeslaGrenadeItem', 1);
        }

        a.A_StartSound("weapons/grenade/throw", CHAN_AUTO);
        a.A_AlertMonsters();
    }

    default
    {
        Tag "Tesla Grenade";
        Inventory.Icon "TGRNA0";
        Inventory.Amount 1;
        Inventory.DefMaxAmount;
        Inventory.PickupMessage "Tesla grenade";
        Inventory.PickupSound "inventory/grenade/pickup";

        +Inventory.INVBAR;
    }

    states
    {
    Spawn:
        TGRN A -1;
        stop;
    Use:
        TNT1 A -1;
        stop;
    }
}

class TOB_PowerFlight : PowerFlight
{
    override void DoEffect()
    {
        super.DoEffect();

        let pp = TOB_Util.GetPlayerOwnerForInventory(self);
        if (!pp)
        {
            return;
        }

        let pi = pp.player;
        if (!pi)
        {
            return;
        }

        let psp = pi.FindPSprite(9999);

        if (!psp)
        {
            pi.SetPSprite(9999, FindState('Fly', true));

            psp = pi.FindPSprite(9999);

            if (psp)
            {
                psp.bAddWeapon = false;
                psp.bAddBob = false;
                psp.scale *= 1.5;
                psp.hAlign |= PSPA_CENTER;
                psp.vAlign |= PSPA_CENTER;
            }
        }

        pp.A_StartSound("inventory/heliofly/use", CHAN_7, CHANF_LOOPING);
    }

    override void DetachFromOwner()
    {
        let pp = TOB_Util.GetPlayerOwnerForInventory(self);
        if (!pp)
        {
            return;
        }

        let pi = pp.player;
        if (!pi)
        {
            return;
        }

        let psp = pi.FindPSprite(9999);

        if (psp)
        {
            pi.SetPSprite(9999, FindState('Null'));
        }

        owner.A_StopSound(CHAN_7);

        super.DetachFromOwner();
    }

    default
    {
        DefaultStateUsage SUF_ACTOR|SUF_OVERLAY|SUF_WEAPON;
    }

    states
    {
    Fly:
        HFLY BC 3;
        loop;
    }
}

/*
class TOB_HelioFly : PowerupGiver
{
    default
    {
        Tag "Helicopter Backpack";
        Inventory.PickupMessage "Helicopter backpack";
        Inventory.PickupSound "inventory/heliofly/pickup";
        Powerup.Type "TOB_PowerFlight";

        +COUNTITEM;
    }

    states
    {
    Spawn:
        HBPK A -1;
        stop;
    }
} */

class TOB_ArtiTorch : ArtiTorch
{
    default
    {
        Inventory.PickupFlash '';
        -FLOATBOB;
    }
}

class TOB_StoppingPower : ArtiTomeOfPower
{
    /*
    override bool Use(bool pickup)
    {
        let used = super.Use(pickup);
        let pp = TOB_Util.GetPlayerOwnerForInventory(self);

        if (!pp || !pp.player)
        {
            return used;
        }

        let weap = player.readyWeapon;

        if (!weap || !weap.sisterWeaponType)
        {
            return used;
        }

        let sister = weap.sisterWeapon;

        if (!sister)
        {
            return used;
        }

        let sisterReadyState = sister.GetReadyState();

        if (weap.GetReadyState() != sisterReadyState)
        {
            player.readyWeapon = sister;
            player.SetPsprite(PSP_WEAPON, sisterReadyState);
        }

        return used;
    } */

    default
    {
        Tag "Weapon Upgrade";
        Inventory.PickupMessage "Weapon upgrade";
        Inventory.PickupSound "inventory/wupgrade/pickup";
        Inventory.PickupFlash '';

        +COUNTITEM;
        -FLOATBOB;
    }

    states
    {
    Spawn:
        WUPG A -1;
        stop;
    }
}
