#include "zscript/belmondo/tracers/fast_projectile.zs"

class TOB_Bullet : Db_Tracers_FastProjectile
{
    protected Vector3 startPos;

    virtual double GetDistanceTravelled()
    {
        return (pos - startPos).Length();
    }

    virtual int GetBaseDamage()
    {
        let dmg = random(3, 10);

        switch (skill)
        {
        case 0:
            dmg = random(1, 4);
            break;
        case 1:
            dmg = random(1, 8);
            break;
        }

        return dmg;
    }

    virtual int GetAttenuatedDamage(int baseDamage, double distance)
    {
        let dmg = baseDamage;

        if (distance < 128)
        {
            dmg <<= 2;
        }
        else if (distance < 256)
        {
            dmg <<= 1;
        }

        return dmg;
    }

    virtual int GetFinalDamage()
    {
        return GetAttenuatedDamage(GetBaseDamage(), GetDistanceTravelled());
    }

    override void PostBeginPlay()
    {
        super.PostBeginPlay();

        startPos = pos;
    }

    override bool CanCollideWith(Actor other, bool passive)
    {
        if (!other.bShootable)
        {
            return false;
        }

        return super.CanCollideWith(other, passive);
    }

    override int SpecialMissileHit(Actor victim)
    {
        if (victim == target)
        {
            return -1;
        }

        let damage = GetFinalDamage();

        if (victim.bShootable && !victim.bNoBlood)
        {
            victim.BloodSplatter(pos, angle);
        }

        victim.DamageMobj(self, target, damage, 'Hitscan');

        return -1;
    }

    default
    {
        Db_Tracers_FastProjectile.PuffType 'TOB_Puff';

        +SEEKERMISSILE;
        +NODAMAGETHRUST;
        +MTHRUSPECIES;
    }

    states
    {
    Spawn:
        TNT1 A 1 NoDelay A_JumpIfTracerCloser(96, 1);
        loop;
        "####" "#" -1 A_StartSound("weapons/whizz");
        stop;
    Death:
        TNT1 A -1 {
            let bpuff = Spawn(mPuffType, pos, ALLOW_REPLACE);

            let st = bpuff.FindState('Crash');
            if (st)
            {
                bpuff.SetState(st);
            }

            Destroy();
        }
        stop;
    XDeath:
        TNT1 A -1 {
            A_StartSound("misc/flesh_bullet");
            Destroy();
        }
        stop;
    }
}

class TOB_AccurateBullet : TOB_Bullet
{
    override double GetDistanceTravelled()
    {
        return super.GetDistanceTravelled() * 2.0 / 3.0;
    }

    default
    {
        Db_Tracers_FastProjectile.PuffType 'TOB_MediumPuff';
    }
}

class TOB_BossBullet : TOB_AccurateBullet
{
    default
    {
        Db_Tracers_FastProjectile.PuffType 'TOB_BigPuff';
        Db_Tracers_FastProjectile.Length 48.0;
    }
}

class TOB_RifleBullet : TOB_BossBullet
{
    override int GetBaseDamage()
    {
        return super.GetBaseDamage() * 3;
    }
}
