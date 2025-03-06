class TOB_SoDHandler : StaticEventHandler
{
    private int _deathCount;

    protected virtual Class<PlayerPawn> GetPlayerClass()
    {
        return 'PlayerPawn';
    }

    override void OnRegister()
    {
        _deathCount = 0;
    }

    override void WorldLoaded(WorldEvent e)
    {
        _deathCount *= !e.IsReopen;
    }

    override void WorldThingDied(WorldEvent e)
    {
        _deathCount += e.Thing is GetPlayerClass();
    }
}
