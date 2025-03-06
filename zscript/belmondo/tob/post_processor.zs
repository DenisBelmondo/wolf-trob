class TOB_PostProcessor : LevelPostProcessor
{
    private Dictionary replacements;

    protected virtual Dictionary GetReplacements()
    {
        return replacements;
    }

    protected void Apply(Name checksum, string mapName)
    {
        /*for (let i = 0; i < GetThingCount(); i++)
        {
            if ((GetThingFlags(i) & MTF_COOPERATIVE) && !(GetThingFlags(i) & MTF_SINGLE))
            {
                SetThingFlags(i, GetThingFlags(i) | MTF_SINGLE);
            }
        }*/
    }
}
