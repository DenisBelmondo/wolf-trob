class TOB_PlayerDeathHandler : EventHandler
{
    enum EState
    {
        DHS_NONE,
        DHS_JUSTDIED
    }

    private float _oldMusicVol;
    private int _musicState;
    protected float MusicalStingTimer;

    int GetMusicState()
    {
        return _musicState;
    }

    protected int GetMusicalStingTimerTicks()
    {
        return 13;
    }

    protected void ResetMusicalStingTimer()
    {
        MusicalStingTimer = GetMusicalStingTimerTicks();
    }

    protected bool CanDo(PlayerPawn playerMo)
    {
        return !multiplayer && Players[ConsolePlayer] == playerMo.player;
    }

    protected void StopMusic()
    {
        _oldMusicVol = level.MusicVolume;
        SetMusicVolume(0);
    }

    protected void ResumeMusic()
    {
        SetMusicVolume(_oldMusicVol);
    }

    protected void Trigger(PlayerPawn playerMo)
    {
        if (CanDo(playerMo))
        {
            ResetMusicalStingTimer();
            StopMusic();
            _musicState = DHS_JUSTDIED;
        }
    }

    protected void Reset(PlayerPawn playerMo)
    {
        if (CanDo(playerMo))
        {
            ResetMusicalStingTimer();
            ResumeMusic();
            _musicState = DHS_NONE;
        }
    }

    override void WorldThingDied(WorldEvent e)
    {
        if (e.Thing is 'PlayerPawn')
        {
            Trigger(PlayerPawn(e.Thing));
        }
    }

    override void WorldThingRevived(WorldEvent e)
    {
        if (e.Thing is 'PlayerPawn')
        {
            Reset(PlayerPawn(e.Thing));
        }
    }

    override void WorldTick()
    {
        MusicalStingTimer = clamp(--MusicalStingTimer, 0, GetMusicalStingTimerTicks());

        if (_musicState == DHS_JUSTDIED && MusicalStingTimer <= 0)
        {
            _musicState = DHS_NONE;
            S_StartSound("scary", CHAN_AUTO);
        }
    }
}
