class TOB_ChaingunPuff : TOB_BigPuff
{
    default
    {
        DamageType 'Hitscan.TOB_Chaingun';
        -NOEXTREMEDEATH;
        +BLOODSPLATTER;
    }
}

class TOB_Chaingun : TOB_Weapon
{
    mixin TOB_Wolf3DSizedActorMixin;

    static const StateLabel[] flashLabels = {
        'Flash1',
        'Flash2',
        'Flash3',
        'Flash4'
    };

    action void A_PlayChaingunSound()
    {
        invoker.PlayChaingunSound();
    }

    action void A_FireChaingun(bool useAmmo = true)
    {
        invoker.FireChaingun(useAmmo);
    }

    virtual void PlayChaingunSound()
    {
        owner.A_StartSound("weapons/chaingun/fire", CHAN_WEAPON, CHANF_LOOPING);
        owner.A_StartSound("weapons/chaingun/fx", CHAN_7);
    }

    virtual void FireChaingun(bool useAmmo = true)
    {
        TOBFireBullets(5.6, 5.6, closeDmg: 30, farDmg: 14, puffType: 'TOB_ChaingunPuff', flags: useAmmo ? FBF_USEAMMO : 0);
        owner.angle += frandom(-3, 3);
        owner.A_Recoil(0.25 * cos(pitch));
    }

    override void AttachToOwner(Actor other)
    {
        super.AttachToOwner(other);
        other.A_StartSound("inventory/dana", CHAN_ITEM, CHANF_LOCAL|CHANF_NOSTOP);
    }

    override State GetDownState()
    {
        A_StopSound(CHAN_WEAPON);
        return super.GetDownState();
    }

    override StateLabel ChooseFlashLabel()
    {
        return flashLabels[random[TOB_Weapon_Flash](0, flashLabels.Size() - 1)];
    }

    default
    {
        Tag "Chaingun";
        Inventory.PickupMessage "Chaingun";
        Weapon.AmmoType1 'TOB_StripperClip';
        Weapon.AmmoUse1 1;
        Weapon.AmmoGive1 20;
        Weapon.BobStyle 'Inverse';
        Weapon.BobSpeed 2.5;
        Weapon.BobRangeX 0.125;
        Weapon.BobRangeY 0.4;
        Weapon.UpSound "weapons/chaingun/select";
    }

    states
    {
    Ready:
        CHNG A 0;
        "####" "#" 1 A_TOBWeaponReady();
        loop;
    Deselect:
        TNT1 A 0 A_StopSound(CHAN_WEAPON);
        CHNG A 1 A_Lower();
        wait;
    Select:
        CHNG A 1 A_Raise();
        loop;
    Fire:
        "####" "#" 0 A_StartSound("weapons/chaingun/spin_0", CHAN_WEAPON);
        CHNG AA 1 A_WeaponOffset(0, -4, WOF_ADD);
        CHNG BB 1 A_WeaponOffset(0, -2, WOF_ADD);
        CHNG BC 3;
        CHNG DA 2;
        CHNG BCDA 1;
    Hold:
        "####" "#" 0 A_JumpIfNoAmmo('Hold_SpinDown');

        "####" "#" 0 A_Light(random(1, 2));
        CHNF A 1 Bright A_Flash(162, 114, 'Flash');
        "####" "#" 0 A_Light(0);

        "####" "#" 0 A_FireChaingun(true);
        "####" "#" 0 A_WeaponOffset(random(-3, 3), WEAPONTOP - 12 + random(2, 4));
        "####" "#" 0 A_PlayChaingunSound();
        "####" "#" 0 A_Flash(164);
        CHNG B 1;

        "####" "#" 0 A_Light(random(1, 2));
        CHNF B 1 Bright A_Flash(162, 114);
        "####" "#" 0 A_Light(0);

        "####" "#" 0 A_FireChaingun(false);
        "####" "#" 0 A_WeaponOffset(random(-3, 3), WEAPONTOP - 12 + random(2, 4));
        "####" "#" 0 A_PlayChaingunSound();
        CHNG D 1;

        "####" "#" 0 A_JumpIfNoAmmo('Hold_SpinDown');

        "####" "#" 0 A_Light(random(1, 2));
        CHNF A 1 Bright A_Flash(162, 114, 'Flash');
        "####" "#" 0 A_Light(0);

        "####" "#" 0 A_FireChaingun(true);
        "####" "#" 0 A_WeaponOffset(random(-3, 3), WEAPONTOP - 12 + random(2, 4));
        "####" "#" 0 A_PlayChaingunSound();
        "####" "#" 0 A_Flash(164);
        CHNG B 1;

        "####" "#" 0 A_Light(random(1, 2));
        CHNF B 1 Bright A_Flash(162, 114);
        "####" "#" 0 A_Light(0);

        "####" "#" 0 A_FireChaingun(false);
        "####" "#" 0 A_WeaponOffset(random(-3, 3), WEAPONTOP - 12 + random(2, 4));
        "####" "#" 0 A_PlayChaingunSound();
        CHNG D 1;

        "####" "#" 0 A_JumpIfNoAmmo('Hold_SpinDown');

        "####" "#" 0 A_Light(random(1, 2));
        CHNF A 1 Bright A_Flash(162, 114, 'Flash');
        "####" "#" 0 A_Light(0);

        "####" "#" 0 A_FireChaingun(true);
        "####" "#" 0 A_WeaponOffset(random(-3, 3), WEAPONTOP - 12 + random(2, 4));
        "####" "#" 0 A_PlayChaingunSound();
        "####" "#" 0 A_Flash(164);
        CHNG B 1;

        "####" "#" 0 A_Light(random(1, 2));
        CHNF B 1 Bright A_Flash(162, 114);
        "####" "#" 0 A_Light(0);

        "####" "#" 0 A_FireChaingun(false);
        "####" "#" 0 A_WeaponOffset(random(-3, 3), WEAPONTOP - 12 + random(2, 4));
        "####" "#" 0 A_PlayChaingunSound();
        CHNG D 1;

        "####" "#" 0 A_JumpIfNoAmmo('Hold_SpinDown');

        "####" "#" 0 A_Light(random(1, 2));
        CHNF A 1 Bright A_Flash(162, 114, 'Flash');
        "####" "#" 0 A_Light(0);

        "####" "#" 0 A_FireChaingun(true);
        "####" "#" 0 A_WeaponOffset(random(-3, 3), WEAPONTOP - 12 + random(2, 4));
        "####" "#" 0 A_PlayChaingunSound();
        "####" "#" 0 A_Flash(164);
        CHNG B 1;

        "####" "#" 0 A_Light(random(1, 2));
        CHNF B 1 Bright A_Flash(162, 114);
        "####" "#" 0 A_Light(0);

        "####" "#" 0 A_FireChaingun(false);
        "####" "#" 0 A_WeaponOffset(random(-3, 3), WEAPONTOP - 12 + random(2, 4));
        "####" "#" 0 A_PlayChaingunSound();
        CHNG D 1;

        CHNG A 1 A_ReFire();
    Hold_SpinDown:
        "####" "#" 0 A_WeaponOffset(0, WEAPONTOP - 12);
        "####" "#" 0 A_StopSound(CHAN_WEAPON);
        "####" "#" 0 A_StartSound("weapons/chaingun/spin_1", CHAN_WEAPON);

        CHNG BCDABCDABBCCCDDDAAAABBBBCCCCDDDD 1 A_ReFire();
        CHNG AA 1 A_WeaponOffset(0, 4, WOF_ADD);
        CHNG AA 1 A_WeaponOffset(0, 2, WOF_ADD);

        "####" "#" 0 A_StopSound(CHAN_WEAPON);
        goto Ready;
    Flash:
        MZF3 B 1 Bright;
        goto FlashDone;
    Flash1:
        MZF6 A 1 Bright;
        goto FlashDone;
    Flash2:
        MZF6 B 1 Bright;
        goto FlashDone;
    Flash3:
        MZF6 C 1 Bright;
        goto FlashDone;
    Flash4:
        MZF6 D 1 Bright;
        goto FlashDone;
    Spawn:
        CHNW A -1;
        stop;
    }
}
