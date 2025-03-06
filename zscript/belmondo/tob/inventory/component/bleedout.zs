#include "./component.zs"

class TOB_Bleedout : Inventory
{
    mixin TOB_Component;

    const TICS_UNTIL_BLEEDOUT = 70;
    const BLEEDOUT_NTH_TICK = 7;
    const BLEEDOUT_NTH_MULTIPLE = 20;

    int prevHealth;
    int bleedoutTimer;

    //
    // stateful methods
    //

    void ResetBleedoutTimer()
    {
        bleedoutTimer = TICS_UNTIL_BLEEDOUT;
    }

    void TickBleedoutTimer()
    {
        bleedoutTimer--;
        bleedoutTimer = clamp(bleedoutTimer, 0, TICS_UNTIL_BLEEDOUT);
    }

    //
    // wrappers and helpers
    //

    void BeforeTick()
    {
        if (!owner.player)
        {
            return;
        }

        // i'm hit!
        // check for state of prevHealh from previous frame

        if (prevHealth > owner.player.health)
        {
            ResetBleedoutTimer();
        }

        prevHealth = owner.player.health;
    }

    void AfterTick()
    {
        if (!owner.player)
        {
            return;
        }

        if (prevHealth < owner.player.health)
        {
            ResetBleedoutTimer();
        }

        TickBleedoutTimer();

        if (CanBleedOut())
        {
            BleedOut();
        }
    }

    //
    // virtuals
    //

    virtual bool CanBleedOut()
    {
        return owner.player
            && owner.player.playerState != PST_DEAD
            && bleedoutTimer <= 0
            && owner.player.mo.health < owner.GetMaxHealth()
            && owner.player.mo.health % BLEEDOUT_NTH_MULTIPLE
            && level.MapTime % BLEEDOUT_NTH_TICK == 0;
    }

    virtual void BleedOut()
    {
        if (!owner.player)
        {
            return;
        }

        owner.health = ++owner.player.health;
    }

    //
    // engine callback shit
    //

    override void BeginPlay()
    {
        super.BeginPlay();

        bleedoutTimer = 0;
    }

    override void PostBeginPlay()
    {
        super.PostBeginPlay();

        if (owner.player)
        {
            prevHealth = owner.player.health;
        }
    }

    override void DoEffect()
    {
        BeforeTick();

        super.DoEffect();

        AfterTick();
    }
}
