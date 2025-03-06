mixin class TOB_BleedoutPlayerMixin
{
    const TOB_BleedoutPlayerMixin__TICS_UNTIL_BLEEDOUT = 70;
    const TOB_BleedoutPlayerMixin__BLEEDOUT_NTH_TICK = 7;
    const TOB_BleedoutPlayerMixin__BLEEDOUT_NTH_MULTIPLE = 20;

    int TOB_BleedoutPlayerMixin__prevHealth;
    int TOB_BleedoutPlayerMixin__bleedoutTimer;

    //
    // stateful methods
    //

    void TOB_BleedoutPlayerMixin__ResetBleedoutTimer()
    {
        TOB_BleedoutPlayerMixin__bleedoutTimer
            = TOB_BleedoutPlayerMixin__TICS_UNTIL_BLEEDOUT;
    }

    void TOB_BleedoutPlayerMixin__TickBleedoutTimer()
    {
        TOB_BleedoutPlayerMixin__bleedoutTimer--;
        TOB_BleedoutPlayerMixin__bleedoutTimer = clamp(
            TOB_BleedoutPlayerMixin__bleedoutTimer,
            0,
            TOB_BleedoutPlayerMixin__TICS_UNTIL_BLEEDOUT);
    }

    //
    // engine callback shit
    //

    void TOB_BleedoutPlayerMixin__AfterBeginPlay()
    {
        TOB_BleedoutPlayerMixin__bleedoutTimer = 0;
    }

    void TOB_BleedoutPlayerMixin__AfterPostBeginPlay()
    {
        if (player)
        {
            TOB_BleedoutPlayerMixin__prevHealth = player.health;
        }
    }

    void TOB_BleedoutPlayerMixin__BeforeTick()
    {
        // i'm hit!
        // check for state of prevHealh from previous frame

        if (TOB_BleedoutPlayerMixin__prevHealth > player.health)
        {
            TOB_BleedoutPlayerMixin__ResetBleedoutTimer();
        }

        TOB_BleedoutPlayerMixin__prevHealth = player.health;
    }

    void TOB_BleedoutPlayerMixin__AfterTick()
    {
        if (TOB_BleedoutPlayerMixin__prevHealth < player.health)
        {
            TOB_BleedoutPlayerMixin__ResetBleedoutTimer();
        }

        TOB_BleedoutPlayerMixin__TickBleedoutTimer();

        if (TOB_BleedoutPlayerMixin__CanBleedOut())
        {
            TOB_BleedoutPlayerMixin__BleedOut();
        }
    }

    //
    // virtuals
    //

    virtual bool TOB_BleedoutPlayerMixin__CanBleedOut()
    {
        return player
            && player.playerState != PST_DEAD
            && TOB_BleedoutPlayerMixin__bleedoutTimer <= 0
            && player.mo.health < GetMaxHealth()
            && player.mo.health % TOB_BleedoutPlayerMixin__BLEEDOUT_NTH_MULTIPLE
            && level.MapTime % TOB_BleedoutPlayerMixin__BLEEDOUT_NTH_TICK == 0;
    }

    virtual void TOB_BleedoutPlayerMixin__BleedOut()
    {
        health = ++player.health;
    }
}
