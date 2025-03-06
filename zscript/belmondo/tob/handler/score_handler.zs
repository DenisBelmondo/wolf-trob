class TOB_ScoreHandler_Referee abstract
{
    abstract void Init();
    abstract int GetPointsForClassName(Name className);
}

class TOB_ScoreHandler_Referee_TOB : TOB_ScoreHandler_Referee
{
    private Dictionary _pointsMap;

    private void _InitScoreMap()
    {
        _pointsMap = Dictionary.Create();

        _pointsMap.Insert("TOB_Guard"     , "100");
        _pointsMap.Insert("TOB_Dog"       , "200");
        _pointsMap.Insert("TOB_RifleGuard", "200");
        _pointsMap.Insert("TOB_Officer"   , "400");
        _pointsMap.Insert("TOB_Mutant"    , "700");
        _pointsMap.Insert("TOB_SSGuard"   , "500");
    }

    override void Init()
    {
        _InitScoreMap();
    }

    override int GetPointsForClassName(Name className)
    {
        if (!_pointsMap)
        {
            _InitScoreMap();
        }

        let scoreStr = _pointsMap.At(className);

        if (scoreStr)
        {
            return scoreStr.ToInt();
        }

        Class<Actor> cls = className;
        let classDefaults = GetDefaultByType(cls);

        let backupScore = classDefaults.score;
        if (backupScore <= 0)
        {
            backupScore = (classDefaults.health * exp(-(classDefaults.health / 1000)) * 4);
        }

        return backupScore;
    }
}

class TOB_ScoreHandler : StaticEventHandler
{
    //
    // fields
    //

    private TOB_ScoreHandler_Referee _referee;

    //
    // methods
    //

    //
    // virtuals
    //

    virtual TOB_ScoreHandler_Referee GetReferee()
    {
        if (!_referee)
        {
            _referee = new('TOB_ScoreHandler_Referee_TOB');
        }

        return _referee;
    }

    //
    // overrides
    //

    override void WorldThingDied(WorldEvent e)
    {
        // don't want the player to get score for killing themselves
        if (e.thing == e.inflictor)
        {
            return;
        }

        Actor realInflictor = e.inflictor;

        if (realInflictor && !(realInflictor is 'PlayerPawn'))
        {
            realInflictor = realInflictor.target;
        }

        // HACK: dying monsters still have their killer as their target even
        //       if they weren't alerted to said target first.
        if (!realInflictor)
        {
            realInflictor = e.thing.target;
        }

        if (realInflictor && realInflictor is 'PlayerPawn')
        {
            PlayerPawn(realInflictor).score += GetReferee().GetPointsForClassName(e.thing.GetClassName());
        }
    }
}
