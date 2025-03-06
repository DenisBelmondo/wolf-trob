class Db_MathF abstract version("3.2")
{
    const PI = 3.14159265359;
    const DEG2RAD = PI / 180.;
    const RAD2DEG = 180. / PI;

    static float Square(float v)
    {
        return v * v;
    }

    static float Lerp(float v0, float v1, float t)
    {
        return (1 - t) * v0 + t * v1;
    }

    static float Sign(float v)
    {
        return (v > 0) - (v < 0);
    }
}

class DB_Math abstract version("3.2")
{
    static float Cross2(Vector2 v1, Vector2 v2)
    {
        return v1.x * v2.y - v1.y * v2.x;
    }

    static float LengthSquared2(Vector2 v)
    {
        return v.x * v.x + v.y * v.y;
    }

    static float Length2(Vector2 v)
    {
        return sqrt(v.x * v.x + v.y * v.y);
    }

    static Vector2 Normalize2(Vector2 v)
    {
        float l = sqrt(v.x * v.x + v.y * v.y);
        v.x /= l;
        v.y /= l;

        return v;
    }

    static float AngleBetween2(Vector2 v1, Vector2 v2)
    {
        return atan2(Cross2(v1, v2), v1 dot v2);
    }

    static Vector2 Slide2(Vector2 v, Vector2 normal)
    {
        return v - (normal * (v dot normal));
    }

    static Vector2 Lerp2(Vector2 v1, Vector2 v2, float t)
    {
        return (Db_MathF.Lerp(v1.x, v2.x, t), Db_MathF.Lerp(v1.y, v2.y, t));
    }

    static Vector3 Lerp3(Vector3 v1, Vector3 v2, float t)
    {
        return (Db_MathF.Lerp(v1.x, v2.x, t), Db_MathF.Lerp(v1.y, v2.y, t), Db_MathF.Lerp(v1.z, v2.z, t));
    }

    static Vector3 Normalize3(Vector3 v)
    {
        let ls = LengthSquared3(v);

        if (!ls)
        {
            return (0, 0, 0);
        }

        let l = sqrt(ls);
        return (v.x / l, v.y / l, v.z / l);
    }

    static float LengthSquared3(Vector3 v)
    {
        return Db_MathF.Square(v.x) + Db_MathF.Square(v.y) + Db_MathF.Square(v.z);
    }

    static float Length3(Vector3 v)
    {
        return sqrt(LengthSquared3(v));
    }

    static float DistanceSquared3(Vector3 v1, Vector3 v2)
    {
        return LengthSquared3(v2 - v1);
    }

    static float Distance3(Vector3 v1, Vector3 v2)
    {
        return sqrt(DistanceSquared3(v1, v2));
    }
}
