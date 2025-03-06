class TOB_Actor : Actor
{
    TOB_Flincher flincher;

    override void PostBeginPlay()
    {
        super.PostBeginPlay();
        flincher = TOB_Flincher(GiveInventoryType('TOB_Flincher'));
    }

    override int DamageMobj(Actor inflictor, Actor source, int damage, Name mod, int flags, double angle)
    {
        let r = super.DamageMobj(inflictor, source, damage, mod, flags, angle);

        if (flincher)
        {
            flincher.Flinch((frandompick(-0.4, 0.4), 0.0), 3);
        }

        return r;
    }
}
