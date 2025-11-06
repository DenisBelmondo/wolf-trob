class TOB_StatusScreenContext ui
{
    StatusScreen mStatusScreen;
    Font mFont;

    TOB_StatusScreenContext Init(StatusScreen pStatusScreen, Font pFont)
    {
        mStatusScreen = pStatusScreen;
        mFont = pFont;

        return self;
    }
}

class TOB_StatusScreenState ui
{
    private bool _accelerated;
    protected bool canSkip;
    readonly<TOB_StatusScreenContext> ctx;
    bool shouldDraw;

    TOB_StatusScreenState Init(readonly<TOB_StatusScreenContext> ctx)
    {
        self.ctx = ctx;
        canSkip = true;
        _Init();

        return self;
    }

    bool CanBeSkipped()
    {
        return canSkip;
    }

    TOB_StatusScreenState SetCanSkip(bool b)
    {
        canSkip = b;
        return self;
    }

    virtual void _Init()
    {
    }

    virtual void Tick()
    {
    }

    virtual void Skip()
    {
        _accelerated = true;
    }

    virtual bool IsDone() const
    {
        return _accelerated;
    }
}

class TOB_StatusScreenCounter : TOB_StatusScreenState
{
    readonly<int> counterLimit;
    int counterFrequencyTics;    
    int counterIncrement;
    int counterCurrent;

    bool CounterIsDone()
    {
        return counterCurrent >= counterLimit;
    }

    TOB_StatusScreenCounter InitCounter(int limit, int increment = 3, int frequencyTics = 3)
    {
        counterLimit = limit;
        counterIncrement = increment;
        counterFrequencyTics = frequencyTics;

        return self;
    }

    override void Tick()
    {
        super.Tick();
        
        if (!CounterIsDone() && ctx.mStatusScreen.bcnt & counterFrequencyTics)
        {
            counterCurrent += counterIncrement;
            counterCurrent = clamp(counterCurrent, -counterLimit, counterLimit);
        }
    }

    override void Skip()
    {
        super.Skip();
        counterCurrent = counterLimit;
    }

    override bool IsDone()
    {
        return super.IsDone() || CounterIsDone();
    }
}

class TOB_TimeStatusState : TOB_StatusScreenCounter
{
    readonly<int> totalSeconds;
    readonly<int> totalMinutes;
    readonly<int> parSeconds;
    readonly<int> parMinutes;

    override void _Init()
    {
        super._Init();

        totalSeconds = Thinker.Tics2Seconds(ctx.mStatusScreen.wbs.totalTime);
        totalSeconds %= 60;
        totalMinutes = totalSeconds / 60;
        parSeconds = Thinker.Tics2Seconds(ctx.mStatusScreen.wbs.parTime);
        parMinutes = parSeconds / 60;
        InitCounter(totalSeconds);
    }
}

class TOB_StatusScreen : StatusScreen
{
    TOB_StatusScreenContext ctx;
    Array<TOB_StatusScreenState> statusScreenStateQueue;
    Array<TOB_StatusScreenCounter> percentageCounters;
    TOB_TimeStatusState timeStatusState;
    TOB_StatusScreenCounter killsStatusState;
    TOB_StatusScreenCounter itemsStatusState;
    TOB_StatusScreenCounter secretsStatusState;
    TOB_StatusScreenCounter fadeOutStatusScreenState;
    TOB_StatusScreenCounter waitAfterFadeOutScreenState;
    TOB_StatusScreenCounter fadeInStatusScreenState;
    int currentStateIndex;

    static int CalcPercentage(int p, int b)
    {
        return b == 0 ? 100 : p * 100 / b;
    }

    TOB_StatusScreenCounter Wait(int tics)
    {
        return TOB_StatusScreenCounter(new('TOB_StatusScreenCounter').InitCounter(tics).Init(ctx));
    }

    TOB_StatusScreenState WaitForInput()
    {
        return new('TOB_StatusScreenState').Init(ctx);
    }

    void OnStatusStateFinished(TOB_StatusScreenState sss)
    {
        if (sss == waitAfterFadeOutScreenState)
        {
            fadeOutStatusScreenState.shouldDraw = false;
            timeStatusState.shouldDraw = false;

            for (let i = 0; i < percentageCounters.Size(); i++)
            {
                percentageCounters[i].shouldDraw = false;
            }
        }
    }

    override void InitStats()
    {
        super.InitStats();

        Font fnt = 'BIGFONT';
        
        ctx = new('TOB_StatusScreenContext').Init(self, fnt);

        timeStatusState = TOB_TimeStatusState(new('TOB_TimeStatusState').Init(ctx));

        killsStatusState = TOB_StatusScreenCounter(
            new('TOB_StatusScreenCounter')
                .InitCounter(CalcPercentage(Plrs[me].skills, wbs.maxKills))
                .Init(ctx)
        );

        itemsStatusState = TOB_StatusScreenCounter(
            new('TOB_StatusScreenCounter')
                .InitCounter(CalcPercentage(Plrs[me].sitems, wbs.maxItems))
                .Init(ctx)
        );

        secretsStatusState = TOB_StatusScreenCounter(
            new('TOB_StatusScreenCounter')
                .InitCounter(CalcPercentage(Plrs[me].ssecret, wbs.maxSecret))
                .Init(ctx)
        );

        fadeOutStatusScreenState = TOB_StatusScreenCounter(
            new('TOB_StatusScreenCounter')
                .InitCounter(gameTicRate / 4, 1)
                .Init(ctx)
                .SetCanSkip(false)
        );

        waitAfterFadeOutScreenState = TOB_StatusScreenCounter(new('TOB_StatusScreenCounter').InitCounter(gameTicRate / 2).Init(ctx));

        fadeInStatusScreenState = TOB_StatusScreenCounter(
            new('TOB_StatusScreenCounter')
                .InitCounter(gameTicRate / 4, 1)
                .Init(ctx)
                .SetCanSkip(false)
        );

        percentageCounters.Push(killsStatusState);
        percentageCounters.Push(itemsStatusState);
        percentageCounters.Push(secretsStatusState);

        statusScreenStateQueue.Push(Wait(gameTicRate));
        statusScreenStateQueue.Push(timeStatusState);
        statusScreenStateQueue.Push(Wait(gameTicRate));
        statusScreenStateQueue.Push(killsStatusState);
        statusScreenStateQueue.Push(Wait(gameTicRate));
        statusScreenStateQueue.Push(itemsStatusState);
        statusScreenStateQueue.Push(Wait(gameTicRate));
        statusScreenStateQueue.Push(secretsStatusState);
        statusScreenStateQueue.Push(WaitForInput());
        statusScreenStateQueue.Push(fadeOutStatusScreenState);
        statusScreenStateQueue.Push(waitAfterFadeOutScreenState);
        statusScreenStateQueue.Push(fadeInStatusScreenState);
    }

    override void UpdateStats()
    {
        super.UpdateStats();

        let statusState = statusScreenStateQueue[currentStateIndex];

        statusState.shouldDraw = true;
        statusState.Tick();

        if (statusState.IsDone())
        {
            let oldState = statusState;

            currentStateIndex += 1;
            currentStateIndex = clamp(currentStateIndex, 0, statusScreenStateQueue.Size() - 1);
            OnStatusStateFinished(oldState);
        }
    }

    override bool OnEvent(InputEvent e)
    {
        let currentState = statusScreenStateQueue[currentStateIndex];

        if (e.type == InputEvent.Type_KeyDown && currentState.CanBeSkipped())
        {
            currentState.Skip();
        }

        return super.OnEvent(e);
    }

    override void DrawStats()
    {
        super.DrawStats();

        let labelY = 0;

        if (timeStatusState.shouldDraw)
        {
            DrawText(ctx.mFont, Font.CR_UNTRANSLATED, 0, labelY, String.Format("%02d:%02d", timeStatusState.counterCurrent / 60, timeStatusState.counterCurrent));
            labelY += ctx.mFont.GetHeight();
            DrawText(ctx.mFont, Font.CR_UNTRANSLATED, 0, labelY, String.Format("%02d:%02d", timeStatusState.parMinutes, timeStatusState.parSeconds));
            labelY += ctx.mFont.GetHeight();
        }

        for (let i = 0; i < percentageCounters.Size(); i++)
        {
            let currentCounterState = percentageCounters[i];

            if (!currentCounterState.shouldDraw)
            {
                continue;
            }

            DrawText(ctx.mFont, Font.CR_UNTRANSLATED, 0, labelY, String.Format("%3d%%", currentCounterState.counterCurrent));
            labelY += ctx.mFont.GetHeight();
        }

        if (fadeOutStatusScreenState.shouldDraw)
        {
            Screen.Dim(Color(0, 0, 0), fadeOutStatusScreenState.counterCurrent / double(fadeOutStatusScreenState.counterLimit), 0, 0, Screen.GetWidth(), Screen.GetHeight());
        }

        if (fadeInStatusScreenState.shouldDraw)
        {
            DrawText(ctx.mFont, Font.CR_UNTRANSLATED, 0, 0, "Get Psyched!");
            Screen.Dim(Color(0, 0, 0), 1 - fadeInStatusScreenState.counterCurrent / double(fadeInStatusScreenState.counterLimit), 0, 0, Screen.GetWidth(), Screen.GetHeight());
        }
    }
}
