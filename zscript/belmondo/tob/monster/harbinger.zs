class TOB_HarbingerMissile : Actor
{
    default
    {
        Scale 1.5;
        Radius 11;
        Height 8;
        Speed 20;
        Damage 20;
        Projectile;
        +RANDOMIZE;
    }

    states
    {
    Spawn:
        WFBL AB 4 Bright;
        loop;
    Death:
        WFBL CDEFGH 3 Bright;
        stop;
    }
}

class TOB_Harbinger : TOB_Monster
{
    private TOB_Flincher _flincher;
    private TOB_Gusher _gusher;

    override void BeginPlay()
    {
        super.BeginPlay();

        _flincher = TOB_Flincher(GiveInventoryType('TOB_Flincher'));
        _gusher = TOB_Gusher(GiveInventoryType('TOB_Gusher'));
    }

    default
    {
        Health 3000;
        Radius 28;
        Height 100;
        Mass 800;
        Speed 16;
        Damage 7;
        PainChance 25;
        BloodColor 'Green';
        SeeSound "TOB_Harbinger/Sight";
        DeathSound "TOB_Harbinger/Death";
        StencilColor "FF 99 00";
        Monster;
        +DROPOFF;
        +FLOORCLIP;
        +BOSS;
        +NORADIUSDMG;
        +DONTMORPH;
        +NOTARGET;
        +BOSSDEATH;
    }

    states
    {
    Spawn:
        HBGR A 10 A_Look();
        loop;
    See:
        "####" BCDA 7 A_Chase();
        loop;
    Melee:
    Missile:
        "####" F 7 Bright A_FaceTarget();
        "####" EEEEEEEE 2 Bright {
            if (invoker.GetRenderStyle() == STYLE_Stencil)
            {
                RestoreRenderStyle();
            }
            else
            {
                A_SetRenderStyle(invoker.alpha, STYLE_Stencil);
            }

            A_FaceTarget();
        }
        "####" "#" 0 RestoreRenderStyle();
        "####" F 3 Bright A_FaceTarget();
        "####" G 17 Bright {
            for (let i = 0; i < 3; i++) {
                A_SpawnProjectile('TOB_HarbingerMissile', angle: ((i - 1) / 3.0) * 45.0);
            }
        }
        goto See;
    Death:
        "####" H 2;
        "####" "#" 2 {
            A_StartSound("misc/anime_blood", CHAN_7);
            _gusher.SetState(_gusher.FindState('Use'));
            A_Scream();
        }
        "####" "###" 2 { _flincher.Flinch((0.1, 0), 1); }
        "####" "#" 17;
        "####" IIIII 2 {
            A_StartSound("misc/xdeath", CHAN_AUTO);
            _flincher.Flinch((0.1, 0), 1);
        }
        "####" "#" 25;
        "####" J 35 {
            A_StartSound("misc/xdeath", CHAN_AUTO);
            _flincher.Flinch((0.4, 0), 1);
        }
        "####" KK 2 { _flincher.Flinch((0.1, 0), 1); }
        "####" "#" 17 A_NoBlocking();
        "####" L -1 {
            A_StartSound("misc/bigbody_hard", CHAN_AUTO);
            A_BossDeath();
            A_Quake(2, 35, 0, 512, "");
            _flincher.Flinch((0.2, -0.3), 3);
            // _gusher.SetState(_gusher.ResolveState('Null'));
            TakeInventory('TOB_Gusher', -1);
        }
        stop;
    }
}
