class TOB_Boss : TOB_Monster
{
    mixin TOB_BulletShooterMixin;
    mixin TOB_Wolf3DSizedActorMixin;

    private transient CVar _weebModeCVar;

    action void A_BossThud()
    {
        A_BossDeath();
        invoker.Thud();
        A_Quake(1, 7, 0, 1024, "");
    }

    override void Thud()
    {
        super.Thud();
        A_StartSound("misc/bigbody_hard", CHAN_AUTO);
    }

    override void BeginPlay()
    {
        super.BeginPlay();
        _weebModeCVar = CVar.FindCVar("tob_weebmode");
    }

    default
    {
        Radius 24;
        Height 64;
        MissileHeight 44;
    }

    states
    {
    Death:
        "####" "#" 0 {
            if (_weebModeCVar.GetBool())
            {
                return ResolveState('Death_Anime');
            }

            return ResolveState('Death_Normal');
        }
        "####" "#" -1;
        stop;
    Death_Anime:
        // so the blood sprays towards the target, who is most likely the killer
        "####" "#" 1 A_FaceTarget();
        "####" "#" 17 ScreamAndUnblock();
        "####" "#" 0 A_StartSound("misc/anime_blood", CHAN_7);
        "####" "####################" 4 { TOB_Util.SpawnBloodExplosion(invoker); }
        "####" "#" 2;
        "####" "#" 4 A_StopSound(CHAN_7);
        "####" "#" 0 {
            return ResolveState('Death_Normal');
        }
        stop;
    }
}
