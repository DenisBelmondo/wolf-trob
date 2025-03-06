class TOB_TeslaGun : TOB_Weapon
{
    mixin TOB_Wolf3DSizedActorMixin;

    const LAYER_GLOBE        = -999;
    const LAYER_COILS        = -998;
    const LAYER_COILS_EFFECT = -997;

    private float _rotPerTic;

    action void A_TeslaBolt(float pAngle, float pPitch)
    {
        A_RailAttack(5, 0, false, "", "E7E7FF", RGF_SILENT
                                                    | RGF_NOPIERCING
                                                    | RGF_FULLBRIGHT
                                                    | RGF_EXPLICITANGLE,
                                                maxdiff: 10,
                                                puffType: 'TOB_TeslaPuff',
                                                // spread_xy: frandom(-22, 22),
                                                spread_xy: pAngle,
                                                // spread_z: frandom(-22, 22),
                                                spread_z: pPitch,
                                                duration: 1,
                                                driftspeed: 0);
    }

    action void A_TeslaFire()
    {
        double max = 40.0;

        for (double i = 0.0; i < max; i += 1.0)
        {
            double a = -45.0 + ((i / max) * 90.0);

            FTranslatedLineTarget lineTarget;
            let p = AimLineAttack(angle + a, 1024, lineTarget, ALF_CHECK3D|ALF_NOFRIENDS);

            let actor = lineTarget.lineTarget;

            if (!actor)
            {
                continue;
            }

            if (actor.bIsMonster)
            {
                A_TeslaBolt(a, p);
            }
        }
    }

    action void A_InitOverlays()
    {
        A_Overlay(LAYER_COILS, 'Overlay_Coils', false);
        A_OverlayFlags(LAYER_COILS, PSPF_PIVOTPERCENT, true);
        A_OverlayPivot(LAYER_COILS, 0.5, 0.5);

        A_Overlay(LAYER_GLOBE, 'Overlay_Globe', false);

        A_Overlay(LAYER_COILS_EFFECT, 'Overlay_Coils_Effect', false);
        A_OverlayFlags(LAYER_COILS_EFFECT, PSPF_ALPHA
                                               | PSPF_FORCEALPHA
                                               | PSPF_FORCEALPHA
                                               | PSPF_PIVOTPERCENT,
                                            true);
        A_OverlayRenderstyle(LAYER_COILS_EFFECT, STYLE_Add);
        A_OverlayAlpha(LAYER_COILS_EFFECT, 0.9);
        A_OverlayPivot(LAYER_COILS_EFFECT, 0.5, 0.5);
    }

    override void DoEffect()
    {
        super.DoEffect();

        // doing this via A_OverlayRotate caused some weird fucking artifacts
        // related to lerping

        let pp = TOB_Util.GetPlayerOwnerForInventory(self);
        if (!pp)
        {
            return;
        }

        let player = pp.player;
        if (!player)
        {
            return;
        }

        // don't want to rotate layer if this weapon isn't selected
        if (player.readyWeapon != self)
        {
            return;
        }

        _rotPerTic += 0.5;
        _rotPerTic = clamp(_rotPerTic, -20.0, -5.0);

        let coils = player.FindPSprite(LAYER_COILS);
        if (!coils)
        {
            return;
        }

        coils.interpolateTic = true;
        coils.rotation += _rotPerTic;

        let coileffect = player.FindPSprite(LAYER_COILS_EFFECT);
        if (!coileffect)
        {
            return;
        }

        coileffect.rotation = coils.rotation;
    }

    override void BeginPlay()
    {
        super.BeginPlay();

        _rotPerTic = -5;
    }

    default
    {
        Tag "Tesla Gun";
        Inventory.PickupMessage "Tesla gun";
        Weapon.AmmoType1 'TOB_BatteryAmmo';
        Weapon.AmmoUse1 1;

        +Weapon.AMMO_OPTIONAL;
    }

    states
    {
    Ready:
        TSLG A 1 A_TOBWeaponReady();
        loop;
    Deselect:
        TSLG A 1 A_Lower();
        loop;
    Select:
        TNT1 A 0 A_InitOverlays();
        TSLG A 1 A_Raise();
        wait;
    Fire:
        "####" "######" 1 {
            invoker._rotPerTic -= 1.0;
            A_WeaponOffset(0, -1, WOF_ADD);
        }
    Hold:
        "####" "######" 1 {
            invoker._rotPerTic -= 1.0;
        }
        "####" B 1 {
            A_TeslaFire();
            A_StartSound("Weapons/Tesla/Fire", CHAN_WEAPON);
            A_WeaponOffset(0, 2, WOF_ADD);
            A_Flash(105, 72, 'Flash');
            invoker._rotPerTic -= 1.0;
        }
        "####" A 1;
        "####" B 1 Bright A_TeslaFire();
        "####" A 1;
        "####" B 1 Bright A_TeslaFire();
        "####" AAAAA 1 {
            A_WeaponOffset(random(-2, 2), WEAPONTOP + 2 + random(-2, 2));
            invoker._rotPerTic -= 1.0;
        }
        "####" "##" 1 {
            A_WeaponOffset(0, -1, WOF_ADD);
            invoker._rotPerTic -= 1.0;
        }
        "####" "#" 6 A_WeaponReady(WRF_NOFIRE);
        "####" "#" 1 A_ReFire();
        goto Ready;
    Spawn:
        PSTW A -1;
        stop;
    Overlay_Coils:
        TSLO A 1;
        loop;
    Overlay_Coils_Effect:
        TNT1 A 1 A_SetTics(random[TOB_TeslaGun_CoilZap](5, 70));
        TSLO C 2 Bright A_StartSound("weapons/tesla/idle", CHAN_AUTO);
        TNT1 A 2;
        TSLO D 2 Bright;
        TNT1 A 2;
        TSLO C 2 Bright;
        TNT1 A 2;
        TSLO E 2 Bright;
        TNT1 A 2;
        TSLO D 2 Bright;
        TNT1 A 2;
        TSLO E 2 Bright;
        loop;
    Overlay_Globe:
        TSLO B 1;
        loop;
    Flash:
        TSLH A 1 Bright A_Light(3);
        TNT1 A 1;
        TSLH B 1 Bright A_Light(1);
        goto FlashDone;
    }
}
