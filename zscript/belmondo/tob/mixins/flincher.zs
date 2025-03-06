mixin class TOB_FlincherMixin
{
    int flinchTimer;

    void ResetFlinchTimer()
    {
        flinchTimer = 0;
    }

    void StartFlinchTimer(uint time)
    {
        flinchTimer = time;
    }
}
