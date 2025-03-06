mixin class Db_Tracers_Mixin
{
    protected Vector3 mFromPos;
    protected Vector3 mToPos;
    protected Class<Actor> mPuffType;
    protected double mLength;

    property PuffType: mPuffType;
    property Length: mLength;

    virtual Color GetColorAt(float t)
    {
        return Color(255, 112 + int(t * 255), 64);
    }

    virtual float GetSizeAt(float t)
    {
        return t * 4.8;
    }

    void Db_Tracers_Mixin_PostBeginPlay()
    {
        super.PostBeginPlay();

        mFromPos = mToPos = pos;
    }

    void Db_Tracers_Mixin_Tick()
    {
        if (!isFrozen())
        {
            mToPos = pos;
        }

        if (!IsFrozen()
            && Db_Math.DistanceSquared3(mFromPos, mToPos)
                > Db_MathF.Square(mLength))
        {
            mFromPos = mToPos + Db_Math.Normalize3(mFromPos - mToPos) * mLength;
        }

        if (IsFrozen())
        {
            return;
        }

        for (float t = 0.0; t < 1.0; t += 0.005)
        {
            let v = Db_Math.Lerp3(mFromPos, mToPos, t) - pos;
            A_SpawnParticle(GetColorAt(t), flags: SPF_FULLBRIGHT, lifetime: 1,
                            size: GetSizeAt(t), angle: 0, xoff: v.X, yoff: v.Y,
                            zoff: v.Z, velx: 0, vely: 0, velz: 0, accelx: 0,
                            accely: 0, accelz: 0, startAlphaF: 1);
        }
    }
}
