class TOB_Olaric_SpiritDecoration : Actor
{
    default
    {
        Alpha 0.15;
        Renderstyle 'Add';
        +NOINTERACTION;
        +FLOATBOB;
    }

    states
    {
    Spawn:
        WGST ABCD 5;
        loop;
    }
}

class TOB_Olaric_Spirit : Actor
{
    override int SpecialMissileHit(Actor victim)
    {
        if (victim is 'PlayerPawn')
        {
            let pv = PlayerPawn(victim);
            pv.A_SetBlend("Black", 1.0, 70);
        }

        return super.SpecialMissileHit(victim);
    }

    default
    {
        Radius 6;
        Height 8;
        Speed 20;
        Damage 8;
        Alpha 0.5;
        Renderstyle 'Add';
        Projectile;
        +BLOODLESSIMPACT;
        +RANDOMIZE;
        +SEEKERMISSILE;
    }

    states
    {
    Spawn:
        WGST ABCD 5 A_SeekerMissile(180, 90);
        loop;
    Death:
        TNT1 A -1;
        stop;
    }
}

class TOB_Olaric : TOB_Monster
{
    Array<Actor> spirits;
    float spiritAngle;
    float spiritAngleOffset;

    override void PostBeginPlay()
    {
        super.PostBeginPlay();

        for (let i = 0; i < 4; i++)
        {
            spirits.Push(Spawn('TOB_Olaric_SpiritDecoration', pos));
        }

        spiritAngle = 0;
        spiritAngleOffset = 360.0 / spirits.Size();
    }

    override void Tick()
    {
        super.Tick();

        if (isFrozen())
        {
            return;
        }

        spiritAngle += 5;

        if (spiritAngle > 360)
        {
            spiritAngle = 0;
        }

        for (let i = 0; i < spirits.Size(); i++)
        {
            Actor spirit = spirits[i];

            spirit.SetOrigin(
                pos + (cos(spiritAngle + spiritAngleOffset * i) * default.radius,
                       sin(spiritAngle + spiritAngleOffset * i) * default.radius,
                       default.height / 2 - 8),
                true);
        }
    }

    default
    {
        Tag "Flesh Golem";
        Health 1000;
        Radius 48;
        Height 64;
        Mass 1000;
        Speed 12;
        Scale 1.1;
    }

    states
    {
    Spawn:
        OLRC A 1 A_Look();
        loop;
    See:
        OLRC BB 4 A_Chase();
        OLRC C 6;
        OLRC DD 4 A_Chase();
        OLRC A 6;
        loop;
    Missile:
        OLRC E 10 A_FaceTarget();
        OLRC F 3 Bright A_FaceTarget();
        OLRC F 3 A_FaceTarget();
        OLRC F 3 Bright A_FaceTarget();
        OLRC F 3 A_FaceTarget();
        OLRC F 3 Bright A_FaceTarget();
        OLRC F 3 A_FaceTarget();
        OLRC F 3 Bright A_FaceTarget();
        OLRC F 3 A_FaceTarget();
        OLRC G 6 Bright A_FaceTarget();
        OLRC G 10 Bright A_SpawnProjectile('TOB_Olaric_Spirit');
        goto See;
    Pain:
        OLRC H 5 A_Pain();
        goto See;
    Death:
        OLRC H 20 ScreamAndUnblock();
        TNT1 A -1;
        stop;
    }
}
