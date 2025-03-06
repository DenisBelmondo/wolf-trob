class TOB_GameInfoHandler : EventHandler
{
    static TOB_GameInfo Find()
    {
        let ti = ThinkerIterator.Create('TOB_GameInfo', Thinker.STAT_INFO);
        TOB_GameInfo t;

        for (t = TOB_GameInfo(ti.Next()); ti.Next(); t = TOB_GameInfo(ti.Next()));

        return t;
    }

    virtual Class<TOB_GameInfo> GetGameInfoClass()
    {
        return 'TOB_GameInfo';
    }

    override void WorldLoaded(WorldEvent e)
    {
        TOB_GameInfo(new(GetGameInfoClass())).Init();
    }
}

class TOB_GameInfo : Thinker
{
    const DEFAULT_TICS_UNTIL_BLEEDOUT = 70;
    const DEFAULT_BLEEDOUT_NTH_TICK = 7;
    const DEFAULT_BLEEDOUT_MULTIPLE = 20;

    TOB_GameInfo Init()
    {
        ChangeStatNum(STAT_INFO);
        return self;
    }

    virtual int GetTicsUntilBleedout()
    {
        return DEFAULT_TICS_UNTIL_BLEEDOUT;
    }

    virtual int GetBleedoutNthTick()
    {
        return DEFAULT_BLEEDOUT_NTH_TICK;
    }

    virtual int GetBleedoutMultiple()
    {
        return DEFAULT_BLEEDOUT_MULTIPLE;
    }
}
