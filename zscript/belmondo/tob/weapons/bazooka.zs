class TOB_Bazooka : TOB_Weapon
{
    mixin TOB_Wolf3DSizedActorMixin;

    action void A_PlayBazookaSound()
    {
        invoker.PlayBazookaSound();
    }

    action void A_FireBazooka()
    {
        invoker.FireBazooka();
    }

    virtual void FireBazooka()
    {
        // A_FireProjectile('TOB_BazookaRocket', useAmmo: true);
        owner.SpawnPlayerMissile('TOB_BazookaRocket');
        DepleteAmmo(false, true, 1);
    }

    virtual void PlayBazookaSound()
    {
        owner.A_StartSound("weapons/bazooka/fire", CHAN_WEAPON);
    }

    default
    {
        Tag "Rocket Launcher";
        Inventory.PickupMessage "Rocket Launcher";
        Weapon.AmmoType1 'TOB_RocketAmmo';
        Weapon.AmmoGive1 1;
        Weapon.AmmoUse1 1;
        Weapon.BobStyle 'Inverse';
        Weapon.BobSpeed 2.5;
        Weapon.BobRangeX 0.125;
        Weapon.BobRangeY 0.4;
        Weapon.SisterWeapon 'TOB_Leichenfaust';
        Weapon.UpSound "weapons/bazooka/select";
    }

    states
    {
    Ready:
        BZKG A 1 A_TOBWeaponReady();
        loop;
    Deselect:
        BZKG A 1 A_Lower(8);
        loop;
    Select:
        BZKG A 1 A_Raise(8);
        loop;
    Fire:
        BZKG AA 1 A_WeaponOffset(0, -2, WOF_ADD);
        BZKG AA 1 A_WeaponOffset(0, -2, WOF_ADD);
        BZKG A 3;
        TNT1 A 0 A_Light(2);
        BZKF A 3 Bright A_Flash(160, 114, 'Flash');
        TNT1 A 0 A_Light(1);
        TNT1 A 0 A_PlayBazookaSound();
        TNT1 A 0 A_ZoomFactor(0.99);
        TNT1 A 0 A_Recoil(1);
        BZKG BC 1;
        BZKG D 2;

        TNT1 A 0 A_FireBazooka();
        TNT1 A 0 A_ZoomFactor(1);
        TNT1 A 0 A_Light(0);
        TNT1 A 0 A_StartSound("weapons/bazooka/reload", CHAN_AUTO);

        BZKG C 7 A_WeaponOffset(0, 8, WOF_ADD);
        BZKG C 2 A_WeaponOffset(0, -2, WOF_ADD);
        BZKG D 5 A_WeaponOffset(0, 2, WOF_ADD);
        goto Ready;
    Flash:
        MZF5 A 1 Bright;
        TNT1 A 2;
        MZF5 B 1 Bright;

        // what the fuck did i put this here for again???
        // TNT1 A 0 A_OverlayPivotAlign(DEFAULT_FLASH_LAYER, PSPA_CENTER, PSPA_CENTER);
        TNT1 A 0 A_OverlayRenderStyle(DEFAULT_FLASH_LAYER, STYLE_Translucent);
        TNT1 A 0 A_OverlayAlpha(DEFAULT_FLASH_LAYER, 0.7);
        BZFS A 2 Bright;

        BZFS BC 1 Bright;
        BZFS DE 2;
        stop;
    Spawn:
        BZKW A -1;
        stop;
    }
}

class TOB_BazookaRocketShrapnel : TOB_Bullet
{
    default
    {
        Radius 16;
    }
}

class TOB_BazookaRocket : Actor
{
    action void A_TOB_BazookaTrail()
    {
        A_SpawnItemEx('TOB_RocketTrail', xofs: -Radius,
                                         yofs: frandom[TOB_BazookaRocketTrail](-2, 2),
                                         zofs: frandom[TOB_BazookaRocketTrail](-2, 2));
    }

    default
    {
        Radius 11;
        Height 8;
        Speed 66;
        Damage 100;
        Scale 0.8;

        Projectile;
        -BLOODSPLATTER;
    }

    states
    {
    Spawn:
        BRKT A 2 Bright NoDelay A_StartSound("weapons/bazooka/rocket/fly", CHAN_BODY, CHANF_LOOPING);
    Spawn_Loop:
        "####" "#" 3 Bright A_TOB_BazookaTrail();
        "####" "#" 3 A_TOB_BazookaTrail();
        loop;
    Death:
        TNT1 A -1 {
            // let frags = 10;

            /*for (let i = 0; i < frags; i++)
            {
                A_SpawnProjectile('TOB_BazookaRocketShrapnel', spawnHeight: 0, angle: (i / double(frags)) * 360.0, flags: CMF_TRACKOWNER|CMF_ABSOLUTEPITCH, pitch: random(-45, 0));
            }*/

            A_Explode(100, 256, XF_HURTSOURCE|XF_THRUSTZ, true, 32);
            A_StopSound(CHAN_BODY);
            A_Blast(BF_DONTWARN, strength: 128);
            A_SpawnItemEx('TOB_MushroomExplosion');
            A_QuakeEx(2, 2, 2, 10, 0, 2048, flags: QF_SCALEDOWN, falloff: 512);
        }
        stop;
    }
}

class TOB_Leichenfaust : TOB_Bazooka
{
    override void FireBazooka()
    {
        // A_FireProjectile('TOB_BazookaRocket', useAmmo: true);
        owner.SpawnPlayerMissile('TOB_LeichenfaustRocket');
        DepleteAmmo(false, true, 1);
    }

    override void PlayBazookaSound()
    {
        owner.A_StartSound("weapons/leichenfaust/fire", CHAN_WEAPON);
    }

    states
    {
    Flash:
        LFBX A 1 Bright;
        TNT1 A 2;
        LFBX ABCDEF 1 Bright;
        stop;
    }
}

class TOB_LeichenfaustRocket : Actor
{
    Vector3 lastVel;

    override void Tick()
    {
        if (IsFrozen())
        {
            return;
        }

        super.Tick();

        scale.x = clamp(scale.x + 0.1, scale.x, 2);
        scale.y = clamp(scale.y + 0.1, scale.y, 2);
    }

    default
    {
        RenderStyle 'Add';
        Gravity 0.5;
        Scale 0.5;
        Radius 10;
        Height 20;
        Speed 20;
        Damage 25;

        Projectile;
        +RIPPER;
        -NOGRAVITY;
    }

    states
    {
    Spawn:
        TNT1 A 0 NoDelay {
            vel.z += 6;
            lastVel = vel;
        }
    Spawn_Loop:
        LFSB AB 1 Bright {
            lastVel = vel;

            A_SpawnItemEx('TOB_LeichenfaustTrail', flags: SXF_TRANSFERSCALE);

            if (A_Explode(50, 256, XF_NOSPLASH, false))
            {
                vel = (0, 0, 0);
                target.A_StartSound("weapons/leichenfaust/hitmaker", CHAN_ITEM, CHANF_LOCAL);
                return ResolveState('Hit');
            }

            return ResolveState(null);
        }
        loop;
    Hit:
        TNT1 A 0 {
            scale *= 2;
        }
        LFSB ABAB 1 Bright;
        TNT1 A 0 {
            vel = lastVel;
            scale /= 2;
        }
        LFSB ABAB 1 Bright;
        goto Spawn_Loop;
    Death:
        TNT1 A -1 {
            A_Explode();
            A_SpawnItemEx('TOB_LeichenfaustExplosion');
        }
        stop;
    }
}
