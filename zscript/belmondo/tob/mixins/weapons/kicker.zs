class TOB_KickStunner : Inventory
{
    const TIME = 17;

    int timer;
    State ownerPainState;

    override void AttachToOwner(Actor other)
    {
        super.AttachToOwner(other);

        timer = TIME;
        ownerPainState = owner.ResolveState('Pain');
        owner.A_Pain();

        let flincher = owner.FindInventory('TOB_Flincher');
        if (flincher)
        {
            TOB_Flincher(flincher).Flinch((0.6, 0.0), 4);
        }
    }

    override void DoEffect()
    {
        super.DoEffect();

        if (ownerPainState)
        {
            owner.SetState(ownerPainState, true);
        }

        if (timer-- <= 0)
        {
            owner.TakeInventory(GetClass(), 1);
        }
    }
}

class TOB_KickPuff : Actor
{
    override void PostBeginPlay()
    {
        super.PostBeginPlay();

        if (target)
        {
            target.vel.z += 5;
            target.Thrust(-10, angle);
            target.GiveInventoryType('TOB_KickStunner');
        }
    }

    default
    {
        AttackSound "weapons/kick";
        SeeSound "weapons/kick";

        +BLOODLESSIMPACT;
        +HITTARGET;
        +NODECAL;
        +PUFFONACTORS;
    }
}

mixin class TOB_BJKicker
{
    const LAYER_BOOT = 7;

    states
    {
    // TOB_Kick:
    Zoom:
        "####" "####" 1 A_WeaponOffset(0, WEAPONBOTTOM / 4.0, WOF_ADD);
        WKIK A 0 A_WeaponOffset(-48, WEAPONTOP + 95);
        "####" "####" 1 A_WeaponOffset(48 / 4.0, -95 / 4.0, WOF_ADD);
        "####" "#" 2;
        "####" B 1 {
            A_StartSound("weapons/kick_whoosh_0", CHAN_AUTO);
            A_CustomPunch(0, pufftype: 'TOB_KickPuff', range: 104);
            A_Overlay(LAYER_BOOT, 'TOB_Kick_Boot');
        }
        "####" C 1 A_ZoomFactor(0.95);
        "####" D 1 {
            A_WeaponOffset(0, 2, WOF_ADD);
            A_ZoomFactor(0.975);
        }
        "####" "#" 1 {
            A_WeaponOffset(0, 2, WOF_ADD);
            A_ZoomFactor(1.0);
        }
        "####" "#" 1  A_WeaponOffset(0, 2, WOF_ADD);
        "####" "#" 1 A_WeaponOffset(0, 2, WOF_ADD);
        "####" "####" 1 A_WeaponOffset(0, WEAPONBOTTOM / 4.0, WOF_ADD);
        TNT1 A 0 {
            A_ClearOverlays(LAYER_BOOT, LAYER_BOOT);
            A_WeaponOffset(0, WEAPONBOTTOM);
            return ResolveState('Select');
        }
        goto Ready;
    TOB_Kick_Boot:
        WKIB B 1;
        "####" C 1;
        "####" D -1;
        stop;
    }
}
