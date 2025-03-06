class TOB_StatusScreenState ui
{
    //
    // fields
    //

    bool isLast;
    int ticsLeft;
    TOB_StatusScreen statusScreen;
    TOB_StatusScreenState next;

    TOB_StatusScreenState Then(TOB_StatusScreenState next)
    {
        self.next = next;
        return self;
    }

    TOB_StatusScreenState Wait(int tics)
    {
        ticsLeft = tics;
        return self;
    }

    TOB_StatusScreenState Finish()
    {
        isLast = true;
        return self;
    }

    //
    // virtual methods
    //

    protected virtual void _Init() {}

    virtual void Draw() {}

    virtual TOB_StatusScreenState Init(TOB_StatusScreen statusScreen)
    {
        self.statusScreen = statusScreen;
        _Init();

        return self;
    }

    virtual bool IsDone()
    {
        return false;
    }

    virtual void Tick()
    {
        ticsLeft = clamp(ticsLeft - 1, 0, ticsLeft);
    }
}

class TOB_InitialStatusScreen : TOB_StatusScreenState
{
    TextureID bjTex;
    Vector2 bjTexSize;

    float labelX;
    float timeStatsX;
    float percentagesX;
    float timeY;
    float parY;
    float killsY;
    float itemsY;
    float secretsY;

    override void _Init()
    {
        let currentY = 8;

        bjTex = TexMan.CheckForTexture('g_bji_0');
        bjTexSize = TexMan.GetScaledSize(bjTex);

        labelX = 8;
        timeStatsX = 8 + 128;
        percentagesX = 320 - statusScreen.mFont.StringWidth("000%") - 8;

        currentY = (statusScreen.mFont.GetHeight() + 2) * 4;
        timeY = currentY;

        currentY += statusScreen.mFont.GetHeight() + 2;
        parY = currentY;

        currentY = 200 - statusScreen.mFont.GetHeight() - 8;
        secretsY = currentY;

        currentY -= statusScreen.mFont.GetHeight() + 2;
        itemsY = currentY;

        currentY -= statusScreen.mFont.GetHeight() + 2;
        killsY = currentY;
    }

    override void Draw()
    {
        let cursor = (8, 8);

        statusScreen.DrawText(statusScreen.mFont, Font.CR_RED, cursor.x, cursor.y, "Floor");
        cursor.y += statusScreen.mFont.GetHeight() + 2;
        statusScreen.DrawText(statusScreen.mFont, Font.CR_RED, cursor.x, cursor.y, "Completed");

        statusScreen.DrawTexture(bjTex, 320 - bjTexSize.x - 8, 8);
    }

    override bool IsDone()
    {
        return ticsLeft <= 0;
    }
}

class TOB_TimeStatsScreen : TOB_InitialStatusScreen
{
    override void Draw()
    {
        super.Draw();

        statusScreen.DrawText(statusScreen.mFont, Font.CR_RED, labelX, timeY, "Time");
        statusScreen.DrawText(statusScreen.mFont, Font.CR_RED, timeStatsX, timeY, "00:00");

        statusScreen.DrawText(statusScreen.mFont, Font.CR_RED, labelX, parY, "Par");
        statusScreen.DrawText(statusScreen.mFont, Font.CR_RED, timeStatsX, parY, "00:00");
    }
}

class TOB_KillsStatsScreen : TOB_TimeStatsScreen
{
    override void Draw()
    {
        super.Draw();

        statusScreen.DrawText(statusScreen.mFont, Font.CR_RED, labelX, killsY, "Kills");
        statusScreen.DrawText(statusScreen.mFont, Font.CR_RED, percentagesX, killsY, "100%");
    }
}

class TOB_ItemsStatsScreen : TOB_KillsStatsScreen
{
    override void Draw()
    {
        super.Draw();

        statusScreen.DrawText(statusScreen.mFont, Font.CR_RED, labelX, itemsY, "Items");
        statusScreen.DrawText(statusScreen.mFont, Font.CR_RED, percentagesX, itemsY, "100%");
    }
}

class TOB_SecretsStatsScreen : TOB_ItemsStatsScreen
{
    override void Draw()
    {
        super.Draw();

        statusScreen.DrawText(statusScreen.mFont, Font.CR_RED, labelX, secretsY, "Secrets");
        statusScreen.DrawText(statusScreen.mFont, Font.CR_RED, percentagesX, secretsY, "100%");
    }
}

class TOB_SecretsFadeToBlack : TOB_SecretsStatsScreen
{
    const FADE_DURATION_TICS = 35 / 3;

    float fadeTics;

    override void _Init()
    {
        super._Init();

        fadeTics = 0;
    }

    override void Tick()
    {
        super.Tick();

        fadeTics += 1;
    }

    override void Draw()
    {
        super.Draw();

        Screen.Dim(Color(0, 0, 0), fadeTics / FADE_DURATION_TICS, 0, 0, Screen.GetWidth(), Screen.GetHeight());
    }
}

class TOB_GetPsyched : TOB_StatusScreenState
{
    const FADE_DURATION_TICS = 35 / 3;

    float fadeTics;

    TextureID psychedTex;
    Vector2 psychedTexSize;

    override void _Init()
    {
        super._Init();

        fadeTics = FADE_DURATION_TICS;

        psychedTex = TexMan.CheckForTexture('graphics/belmondo/tob/g_psyched.png');
        psychedTexSize = TexMan.GetScaledSize(psychedTex);
    }

    override void Tick()
    {
        super.Tick();

        fadeTics -= 1;
    }

    override void Draw()
    {
        super.Draw();

        statusScreen.DrawTexture(psychedTex, 160 - psychedTexSize.x / 2, 100 - psychedTexSize.y / 2);
        Screen.Dim(Color(0, 0, 0), fadeTics / FADE_DURATION_TICS, 0, 0, Screen.GetWidth(), Screen.GetHeight());
    }
}

class TOB_StatusScreen : StatusScreen
{
    Font mFont;
    TOB_StatusScreenState statusScreenState;

    override void InitStats()
    {
        mFont = 'BIGFONT';

        statusScreenState = (
            new('TOB_InitialStatusScreen')
                .Init(self)
                .Wait(gameTicRate)
                .Then(new('TOB_TimeStatsScreen')
                          .Init(self)
                          .Wait(gameTicRate)
                .Then(new('TOB_KillsStatsScreen')
                          .Init(self)
                          .Wait(gameTicRate)
                .Then(new('TOB_ItemsStatsScreen')
                          .Init(self)
                          .Wait(gameTicRate)
                .Then(new('TOB_SecretsStatsScreen')
                          .Init(self)
                          .Wait(gameTicRate)
                .Then(new('TOB_SecretsFadeToBlack')
                          .Init(self)
                          .Wait(gameTicRate)
                .Then(new('TOB_GetPsyched')
                          .Init(self)
                          .Wait(gameTicRate)
                          .Finish()))))))
        );
    }

    override void UpdateStats()
    {
        if (statusScreenState.IsDone())
        {
            if (statusScreenState.next)
            {
                statusScreen.PlaySound("intermission/nextstage");
                statusScreenState = statusScreenState.next;
            }

            if (statusScreenState.isLast)
            {
                curState = ShowNextLoc;
            }
        }

        statusScreenState.Tick();
    }

    override void DrawStats()
    {
        statusScreenState.Draw();
    }
}
