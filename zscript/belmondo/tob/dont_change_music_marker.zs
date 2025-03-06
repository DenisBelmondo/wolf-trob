class TOB_DontChangeMusicMarker : Actor
{
    default
    {
        +NOINTERACTION;
    }

    override void BeginPlay()
    {
        super.BeginPlay();

        let handler = EventHandler.Find('TOB_MusicHandler');
        if (handler && handler is 'TOB_MusicHandler')
        {
            TOB_MusicHandler(handler).SetEnabled(false);
        }
    }
}
