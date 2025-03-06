class TOB_Flincher : Inventory
{
    State flinchState;
    Vector2 currentAmount;
    int currentDuration;
    int currentTimes;

    void Reset()
    {
        // must do this because sometimes the owner's sprite is flipped upon
        // death

        let newScale = owner.default.scale;
        newScale.x *= Db_MathF.Sign(owner.scale.x);
        newScale.y *= Db_MathF.Sign(owner.scale.y);
        owner.scale = newScale;
    }

    void RealFlinch()
    {
        if (owner)
        {
            // same with this
            let newScale = owner.scale;
            newScale.x += ((int(newScale.x > 0) * 2) - 1) * currentAmount.x;
            newScale.y += ((int(newScale.y > 0) * 2) - 1) * currentAmount.y;
            owner.scale = newScale;
        }

        tics = currentDuration;
    }

    void Flinch(Vector2 amount, int duration = 2)
    {
        currentAmount = amount;
        currentDuration = duration;

        if (flinchState && !InStateSequence(curState, flinchState))
        {
            SetState(flinchState);
        }
    }

    override void PostBeginPlay()
    {
        super.PostBeginPlay();
        flinchState = FindState('Flinch', true);
    }

    default
    {
        Inventory.MaxAmount 1;

        +Inventory.AUTOACTIVATE;
        +Inventory.UNDROPPABLE;
        +Inventory.UNTOSSABLE;
    }

    states
    {
    Ready:
        TNT1 A -1;
        stop;
    Flinch:
        TNT1 A 0 Reset();
        TNT1 A 2 RealFlinch();
        TNT1 A 0 Reset();
        goto Ready;
    }
}
