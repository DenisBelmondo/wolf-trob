class TOB_EnemyUniform : Inventory
{
    default
    {
        Tag "Enemy Uniform";
        Inventory.PickupMessage "Enemy uniform";
        Inventory.PickupSound "inventory/uniform/pickup";
        +Inventory.ALWAYSPICKUP;
    }

    states
    {
    Spawn:
        WUNF A -1;
        stop;
    }
}

mixin class TOB_RespawnPowerupMixin
{
    default
    {
        Powerup.Duration -3;
    }
}

class TOB_RespawnInvulnerability : Powerup
{
    mixin TOB_RespawnPowerupMixin;

    override void InitEffect()
    {
        super.InitEffect();
        owner.bNoDamage = true;
    }

    override void EndEffect()
    {
        super.EndEffect();
        owner.bNoDamage = owner.default.bNoDamage;
    }
}

class TOB_RespawnInvisibility : PowerInvisibility
{

    mixin TOB_RespawnPowerupMixin;

    default
    {
        Powerup.Mode "Translucent";
    }
}
