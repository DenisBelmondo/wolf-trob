class TOB_Weapon : Weapon abstract
{
    mixin TOB_BasicGrenadeThrowerMixin;
    mixin TOB_PillTakerMixin;
    mixin TOB_BJKicker;

    const DEFAULT_FLASH_LAYER = -PSP_FLASH;

    static const StateLabel flashLabels[] = {
        'Flash1',
        'Flash2'
    };

    //
    // members
    //

    int flashTics;
    int readyFlags;
    string realPickupMsg;

    //
    // properties
    //

    property flashTics: flashTics;

    //
    // methods
    //

    void TOBFireBullets(double spreadHorz = 0, double spreadVert = 0,
                                               int numBullets = 1,
                                               int dmgMultiplier = 4,
                                               int closeDmg = 15,
                                               int farDmg = 7,
                                               double closeDist = 128,
                                               Class<Actor> puffType
                                                   = 'BulletPuff',
                                               int flags = FBF_USEAMMO)
    {
        let owner = PlayerPawn(owner);

        if (flags & FBF_USEAMMO)
        {
            if (!DepleteAmmo(false, true))
            {
                return;
            }
        }

        for (let i = 0; i < numBullets; i++)
        {
            let damage = farDmg;
            let angle = owner.angle;

            let target = owner.AimTarget();
            if (target)
            {
                angle = owner.AngleTo(target);

                if (owner.Distance2D(target) < closeDist)
                {
                    damage = closeDmg;
                }
            }

            if (flags & FBF_EXPLICITANGLE)
            {
                angle = spreadHorz;
            }
            else
            {
                angle += frandom(-spreadHorz, spreadHorz);
            }

            damage = random(0, damage) * dmgMultiplier;

            let attackZOffset = owner.attackZOffset;
            let slope = owner.BulletSlope() + frandom(-spreadVert, spreadVert);

            if (damage == 0)
            {
                FLineTraceData data;

                let hit = owner.LineTrace(angle, PLAYERMISSILERANGE, slope, TRF_NOSKY|TRF_THRUACTORS, owner.height / 2 + attackZOffset, data: data);

                if (hit)
                {
                    owner.SpawnPuff(puffType, data.hitLocation - owner.AngleToVector(angle), angle + 180, angle + 180, 0);
                    owner.A_SprayDecal('BulletChip', offset: -data.hitDir, direction: data.hitDir);
                }

                continue;
            }

            owner.LineAttack(angle, PLAYERMISSILERANGE, slope, damage, 'Hitscan', puffType, offsetz: attackZOffset);
            owner.PlayAttacking2();
        }
    }

    //
    // action functions
    //

    action void A_Flash(double muzzleX = 160, double muzzleY = 120, StateLabel label = null, int layer = DEFAULT_FLASH_LAYER, int extraFlags = 0)
    {
        if (!label)
        {
            label = invoker.ChooseFlashLabel();
        }

        A_Overlay(layer, label, false);
        A_OverlayFlags(layer, PSPF_ALPHA|PSPF_FORCEALPHA|PSPF_RENDERSTYLE|PSPF_FORCESTYLE|extraFlags, true);
        A_OverlayOffset(layer, muzzleX, muzzleY);
        A_OverlayRenderStyle(layer, STYLE_Add);
    }

    action void A_TOBFireBullets(double spreadHorz = 0, double spreadVert = 0,
                                                        int numBullets = 1,
                                                        int dmgMultiplier = 4,
                                                        int closeDmg = 15,
                                                        int farDmg = 7,
                                                        double closeDist = 128,
                                                        Class<Actor> puffType
                                                            = 'BulletPuff',
                                                        int flags = FBF_USEAMMO)
    {
        invoker.TOBFireBullets(spreadHorz, spreadVert, numBullets, dmgMultiplier, closeDmg, farDmg, closeDist, puffType, flags);
    }

    action void A_TOBWeaponReady(int flags = 0)
    {
        A_WeaponReady(invoker.readyFlags | flags);
    }

    //
    // virtual methods
    //

    virtual StateLabel ChooseFlashLabel()
    {
        return flashLabels[random[TOB_Weapon_Flash](0, flashLabels.Size() - 1)];
    }

    virtual void InitReadyFlags()
    {
        readyFlags |= WRF_ALLOWZOOM;
    }

    //
    // overrides
    //

    override void BeginPlay()
    {
        super.BeginPlay();
        InitReadyFlags();
    }

    override State GetDownState()
    {
        if (owner)
        {
            owner.A_StartSound("weapon/lower", CHAN_AUTO);
        }

        return super.GetDownState();
    }

    override State GetUpState()
    {
        let pp = TOB_Util.GetPlayerOwnerForInventory(self);
        if (!pp || !pp.player)
        {
            return super.GetUpState();
        }

        let psp = pp.player.FindPSprite(PSP_WEAPON);
        psp.x = 0;

        return super.GetUpState();
    }

    override string PickupMessage()
    {
        if (realPickupMsg == "")
        {
            return pickupMsg;
        }

        return realPickupMsg;
    }

    override void PlayUpSound(Actor origin)
    {
        origin.A_StartSound(upSound, CHAN_AUTO);
    }

    default
    {
        Weapon.BobStyle 'Alpha';
        Weapon.BobSpeed 2.5;
        Weapon.BobRangeX 0.75;
        Weapon.BobRangeY 0.3;
        Weapon.KickBack 0;
        TOB_Weapon.FlashTics 1;
    }

    states
    {
    Ready:
        TNT1 A 1 A_WeaponReady();
        loop;
    Flash1:
        MZF1 A 0;
        goto Flash;
    Flash2:
        MZF2 A 0;
        goto Flash;
    Flash:
        "####" "#" 0 Bright A_SetTics(invoker.flashTics);
    FlashDone:
        TNT1 A 0 A_Light(0);
        TNT1 A 0 A_ClearOverlays(DEFAULT_FLASH_LAYER, DEFAULT_FLASH_LAYER);
        stop;
    }
}
