class TOB_MusicHandlerTrackList
{
    Array<string> tracks;

    virtual TOB_MusicHandlerTrackList Init()
    {
        static const string staticTracks[] = {
            "XDEATH",
            "XEVIL",
            "GETTHEM",
            "XGETYOU",
            "GOINGAFT",
            "XFUNKIE",
            "NAZI_RAP",
            "POW",
            "SEARCHN",
            "SUSPENSE",
            "XTIPTOE",
            "XTOWER2",
            "CORNER",
            "DUNGEONS",
            "POUNDING",
            "TWELFTH",
            "ZEROHOUR"
        };

        for (let i = 0; i < staticTracks.Size(); i++) {
            tracks.Push(staticTracks[i]);
        }

        return self;
    }
}

class TOB_MusicHandler : EventHandler
{
    private TOB_MusicHandlerTrackList _trackList;
    private bool _enabled;
    private string _lastTrack;
    private transient CVar _musicCvar;

    private bool _ShouldChangeMusic()
    {
        return _enabled
            && gamestate != GS_TITLELEVEL
            && _musicCvar
            && _musicCvar.GetBool();
    }

    bool IsEnabled()
    {
        return _enabled;
    }

    void SetEnabled(bool enabled)
    {
        _enabled = enabled;
    }

    protected virtual TOB_MusicHandlerTrackList GetTrackList()
    {
        return _trackList;
    }

    protected virtual string GetTrack()
    {
        let trackIdx = random[TOB_MusicHandler](0, _trackList.tracks.Size() - 1);
        let track = _trackList.tracks[trackIdx];

        // avoid repetition

        if (track == _lastTrack)
        {
            trackIdx = (trackIdx + 1) % _trackList.tracks.Size();
        }

        track = _trackList.tracks[trackIdx];

        return track;
    }

    override void OnRegister()
    {
        _enabled = true;
        _trackList = new('TOB_MusicHandlerTrackList').Init();
    }

    override void WorldLoaded(WorldEvent e)
    {
        _musicCvar = CVar.FindCVar('tob_music');

        if (_ShouldChangeMusic())
        {
            S_ChangeMusic(GetTrack());
        }
    }
}
