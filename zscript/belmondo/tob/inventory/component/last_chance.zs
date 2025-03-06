#include "./component.zs"

class TOB_LastChanceBleed : Powerup
{
    mixin TOB_RespawnPowerupMixin;

    default
    {
        Powerup.ColorMap 0.5, 0.5, 0.5;
        Powerup.Duration 0x7FFFFFFF;
    }
}

class TOB_LastChance : Inventory
{
    mixin TOB_Component;

    bool latched;

    virtual void DoLastChance()
    {
        Console.Printf("Low health!");
        owner.A_StartSound("misc/low_health", CHAN_AUTO, CHANF_LOCAL|CHANF_UI, 1.0, ATTN_NONE);
        owner.GiveInventoryType('TOB_RespawnInvulnerability');
        owner.GiveInventoryType('TOB_RespawnInvisibility');
        owner.GiveInventoryType('TOB_LastChanceBleed');
        owner.A_SetBlend("Red", 1.0, 17);

        if (owner.player)
        {
            owner.player.cheats &= ~CF_BUDDHA;
        }
    }

    override void PostBeginPlay()
    {
        super.BeginPlay();
        latched = false;
    }

    override void AttachToOwner(Actor other)
    {
        super.AttachToOwner(other);

        if (!other.player)
        {
            return;
        }

        other.player.cheats |= CF_BUDDHA;
    }

    override void DoEffect()
    {
        super.DoEffect();

        if (!tob_sv_lastchance)
        {
            return;
        }

        if (owner.player && owner.player.health <= 1 && !latched)
        {
            latched = true;
            DoLastChance();
        }

        // TODO: make the 20 in this condition respect the bleedout nth multiple
        if (owner.player && owner.player.health > 20 && latched)
        {
            latched = false;
            owner.player.cheats |= CF_BUDDHA;
            owner.TakeInventory('TOB_LastChanceBleed', 1);
            owner.A_SetBlend("White", 1.0, 17);
        }
    }
}
