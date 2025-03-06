class TOB_Flamethrower : TOB_Weapon
{
    mixin TOB_Wolf3DSizedActorMixin;

    protected action void A_FireFlameThrower(bool useAmmo = true)
    {
        let fire = A_FireProjectile('TOB_FlamethrowerFlame', useAmmo: useAmmo, spawnheight: 4);

        if (fire)
        {
            fire.vel += vel / 2.0;
        }
    }

    default
    {
        Tag "Flamethrower";
        Inventory.PickupMessage "Flamethrower";
        Weapon.AmmoType1 'TOB_FuelAmmo';
        Weapon.AmmoUse1 1;
        Weapon.AmmoGive1 25;
        Weapon.BobStyle 'Inverse';
        Weapon.BobSpeed 2.5;
        Weapon.BobRangeX 0.125;
        Weapon.BobRangeY 0.4;
        Weapon.UpSound "weapons/fthrow/select";
    }

    states
    {
    Ready:
        WFTG A 1 A_TOBWeaponReady();
        loop;
    Deselect:
        TNT1 A 0 A_StopSound(CHAN_WEAPON);
        WFTG A 1 A_Lower(8);
        wait;
    Select:
        WFTG A 1 A_Raise(8);
        loop;
    Fire:
        WFTG AA 1 A_WeaponOffset(0, -2, WOF_ADD);
        WFTG AA 1 A_WeaponOffset(0, -4, WOF_ADD);
        TNT1 A 0 A_StartSound("weapons/fthrow/start", CHAN_WEAPON);
        "####" "#" 0 A_Flash(160, 124, 'Flash1');
        TNT1 A 0 A_Light(2);
        WFTF A 2 Bright A_WeaponOffset(0, 1, WOF_ADD);
        TNT1 A 0 A_Light(1);
        WFTF B 2 Bright A_WeaponOffset(0, 1, WOF_ADD);
    Hold:
        TNT1 A 0 A_StartSound("weapons/fthrow/fire", CHAN_WEAPON, CHANF_LOOPING);
        "####" "#" 0 A_Flash(160, 124, 'Flash');
        TNT1 A 0 A_Light(2);
        WFTF A 2 Bright A_WeaponOffset(random(-2, 2), WEAPONTOP + random(1, 2) - 8);
        "####" "#" 0 A_FireFlameThrower(true);
        TNT1 A 0 A_Light(1);
        WFTF B 2 Bright A_WeaponOffset(random(-2, 2), WEAPONTOP + random(1, 2) - 8);
        "####" "#" 0 A_FireFlameThrower(false);
        TNT1 A 0 A_ReFire();
        TNT1 A 0 A_StartSound("weapons/fthrow/end", CHAN_WEAPON);
        TNT1 A 0 A_Light(0);
        WFTG AA 1 A_WeaponOffset(0, 2, WOF_ADD);
        WFTG AA 1 A_WeaponOffset(0, 3, WOF_ADD);
        goto Ready;
    Flash:
        FTFS AB 2 Bright;
        goto FlashDone;
    Flash1:
        FTFS C 2 Bright;
        goto FlashDone;
    Spawn:
        FLTW A -1;
        stop;
    }
}

class TOB_FlameThrowerFlameTrail : TOB_NoInteractionParticle
{
    default
    {
        Scale 0.33333333;
        RenderStyle 'Add';
    }

    states
    {
    Spawn:
        FTFL ABCDEFGHIJKLMNOPQRST 1 Bright {
            scale.x *= 1.05;
            scale.y *= 1.05;
        }
        stop;
    }
}

class TOB_FlameThrowerFlame : TOB_FlameThrowerFlameTrail
{
    default
    {
        Radius 12;
        Height 8;
        Damage 5;
        DamageType 'Fire';
        Speed 16;
        RenderStyle 'Add';
        Scale 0.18;
        Projectile;

        -NOINTERACTION;
        -BLOODSPLATTER;
        +BLOODLESSIMPACT;
        +NODAMAGETHRUST;
        +NOEXTREMEDEATH;
    }

    states
    {
    Spawn:
        FTFL ABCDEFGHIJ 2 Bright {
            scale += (Db_MathF.Sign(scale.x) * 0.01, Db_MathF.Sign(scale.y) * 0.01);
        }
        goto Death + 1;
    Death:
        "####" "#" 0 {
            for (let i = 0; i < 4; i++)
            {
                A_SpawnItemEx('TOB_FlameThrowerFlameTrail',
                              xvel: -1.0,
                              yvel: frandom[TOB_FlameThrowerFlameDeath](-2.0, 2.0),
                              zvel: frandom[TOB_FlameThrowerFlameDeath](-2.0, 2.0));
            }

            A_Explode(10, 128, XF_HURTSOURCE, false, 64, damageType: 'Fire');
        }
        FTFL KLMNOPQRST 2 Bright {
            scale += (Db_MathF.Sign(scale.x) * 0.01, Db_MathF.Sign(scale.y) * 0.01);
        }
        stop;
    }
}
