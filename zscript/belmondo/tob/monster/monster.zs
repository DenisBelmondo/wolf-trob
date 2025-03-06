class TOB_Monster : TOB_Actor abstract
{
    virtual void Look()
    {
        A_Look();
    }

    virtual void Wander()
    {
        A_Wander();
    }

    virtual void LookAndWander()
    {
        Look();
        Wander();
    }

    virtual void Chase()
    {
        A_Chase();
    }

    virtual void Pain()
    {
        A_Pain();
    }

    virtual void Scream()
    {
        A_Scream();
    }

    virtual void ScreamAndUnblock()
    {
        Scream();
        A_NoBlocking();
    }

    virtual void Thud()
    {
        flincher.Flinch((0.05, -0.1));
        A_StartSound("misc/body_hard", CHAN_AUTO);
    }

    override void Die(Actor source, Actor inflictor, int dmgFlags, Name meansOfDeath)
    {
        super.Die(source, inflictor, dmgFlags, meansOfDeath);
        scale.x *= randompick[TOB_Monster_DeathFlip](-1, 1);
    }

    default
    {
        Monster;
    }
}
