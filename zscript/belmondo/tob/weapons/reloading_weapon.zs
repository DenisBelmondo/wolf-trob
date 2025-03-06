class TOB_ReloadingWeapon : TOB_Weapon abstract
{
    private int _subAmmoFlags;

    Ammo subAmmo1, subAmmo2;

    int subAmmo1Give, subAmmo2Give;
    property subAmmo1Give: subAmmo1Give;
    property subAmmo2Give: subAmmo2Give;

    Class<Ammo> subAmmo1Type, subAmmo2Type;
    property subAmmo1Type: subAmmo1Type;
    property subAmmo2Type: subAmmo2Type;

    int subAmmo1Use, subAmmo2Use;
    property subAmmo1Use: subAmmo1Use;
    property subAmmo2Use: subAmmo2Use;

    flagdef subAmmo1Optional: _subAmmoFlags, 0;
    flagdef subAmmo2Optional: _subAmmoFlags, 1;

    State reloadState, reloadStateAlt, reloadStateBoth;

    int Reload(int amt = 0, int fireMode = Weapon.PrimaryFire)
    {
        let pp = TOB_Util.GetPlayerOwnerForInventory(self);
        if (!pp || !pp.player)
        {
            return 0;
        }

        Class<Ammo> superAmmoType = ammoType1;
        Ammo superAmmo = ammo1;

        Class<Ammo> subAmmoType = subAmmo1Type;
        Ammo subAmmo = subAmmo1;

        if (fireMode == Weapon.AltFire)
        {
            superAmmoType = ammoType2;
            superAmmo = ammo2;

            subAmmoType = subAmmo2Type;
            subAmmo = subAmmo2;
        }

        let requestedAmount = amt;
        // no amount specified
        if (requestedAmount <= 0)
        {
            requestedAmount = subAmmo.maxAmount - subAmmo.amount;
        }

        // if there is less in the reserve than requested
        requestedAmount = min(requestedAmount, superAmmo.amount);
        AddAmmo(pp, subAmmoType, requestedAmount);

        superAmmo.amount -= requestedAmount;
        if (superAmmo.amount < 0)
        {
            superAmmo.amount = 0;
        }

        return requestedAmount;
    }

    action int A_Reload(int fireMode = Weapon.PrimaryFire, int amt = 0)
    {
        return invoker.Reload(fireMode, amt);
    }

    // virtual bool CanReload(Ammo subAmmo, Ammo superAmmo, PSprite ps, State reloadState, int reloadButton = BT_RELOAD)
    // {
    //     if (!subAmmo || !superAmmo || !ps || !reloadState)
    //     {
    //         return false;
    //     }

    //     let pp = TOB_Util.GetPlayerOwnerForInventory(self);
    //     if (!pp || !pp.player)
    //     {
    //         return false;
    //     }

    //     let allowedToReload = subAmmo.amount < subAmmo.maxAmount;
    //     let pressedReload = (pp.player.cmd.buttons & reloadButton);

    //     return superAmmo.amount > 0
    //         && ((pressedReload && allowedToReload) || (subAmmo.amount <= 0))
    //         && !ps.curState.InStateSequence(reloadState)
    //         && (pp.player.weaponState & WF_WEAPONREADY);
    // }

    virtual State CacheReloadState(int fireMode = Weapon.PrimaryFire)
    {
        switch (fireMode)
        {
        case Weapon.PrimaryFire:
            reloadState = FindState('Reload');
            return reloadState;
        case Weapon.AltFire:
            reloadStateAlt = FindState('AltReload');
            return reloadStateAlt;
        case Weapon.EitherFire:
            reloadStateBoth = FindState('BothReload');
            return reloadStateBoth;
        }

        return null;
    }

    virtual bool CanReload(int fireMode = Weapon.PrimaryFire)
    {
        bool primaryCanReload;
        bool secondaryCanReload;

        if (ammo1)
        {
            primaryCanReload = ammo1.amount > 0;
            primaryCanReload &= subAmmo1.amount < subAmmo1.maxAmount;
        }

        if (ammo2)
        {
            secondaryCanReload = ammo2.amount > 0;
            secondaryCanReload &= subAmmo2.amount < subAmmo2.maxAmount;
        }

        let pp = TOB_Util.GetPlayerOwnerForInventory(self);
        if (pp && pp.player && pp.player.readyWeapon)
        {
            let isInReadyState = pp.player.GetPSprite(PSP_WEAPON).curState.InStateSequence(super.GetReadyState());

            primaryCanReload &= !!(pp.player.weaponState & WF_WEAPONREADY) && isInReadyState;
            secondaryCanReload &= !!(pp.player.weaponState & WF_WEAPONREADY) && isInReadyState;
        }

        switch (fireMode)
        {
        case Weapon.PrimaryFire:
            return primaryCanReload;
        case Weapon.AltFire:
            return secondaryCanReload;
        }

        return primaryCanReload || secondaryCanReload;
    }

    virtual bool CheckSubAmmo(int fireMode, bool autoSwitch = true, bool requireAmmo = false, int amt = -1)
    {
        if (fireMode == Weapon.PrimaryFire && bSubAmmo1Optional)
        {
            return true;
        }

        if (fireMode == Weapon.AltFire && bSubAmmo2Optional)
        {
            return true;
        }

        Ammo superAmmo = ammo1;
        Class<Ammo> subAmmoType = subAmmo1Type;
        Ammo subAmmo = subAmmo1;
        int subAmmoUse = subAmmo1Use;

        if (fireMode == Weapon.AltFire)
        {
            superAmmo = ammo2;
            subAmmoType = subAmmo2Type;
            subAmmo = subAmmo2;
            subAmmoUse = subAmmo2Use;
        }

        if (!superAmmo || !subAmmo)
        {
            return false;
        }

        let amt = amt;
        if (amt < 0)
        {
            amt = subAmmoUse;
        }

        if (subAmmo.amount < amt && superAmmo.amount <= 0)
        {
            let pp = TOB_Util.GetPlayerOwnerForInventory(self);
            let ausw = pp && autoSwitch;

            if (superAmmo.amount <= 0)
            {
                if (ausw)
                {
                    pp.PickNewWeapon(null);
                }

                return false;
            }
        }

        return true;
    }

    virtual bool DepleteSubAmmo(int fireMode = Weapon.PrimaryFire, bool checkEnough = true, int amt = -1)
    {
        Class<Ammo> subAmmoType = subAmmo1Type;
        Ammo subAmmo = subAmmo1;
        int subAmmoUse = subAmmo1Use;

        if (fireMode == Weapon.AltFire)
        {
            subAmmoType = subAmmo2Type;
            subAmmo = subAmmo2;
            subAmmoUse = subAmmo2Use;
        }

        let amt = amt;
        if (amt < 0)
        {
            amt = subAmmoUse;
        }

        subAmmo.amount -= amt;
        if (subAmmo.amount < 0)
        {
            subAmmo.amount = 0;
        }

        return true;
    }

    virtual State GetReloadState(int fireMode = Weapon.PrimaryFire)
    {
        switch (fireMode)
        {
        case Weapon.PrimaryFire:
            return reloadState;
        case Weapon.AltFire:
            return reloadStateAlt;
        case Weapon.EitherFire:
            return reloadStateBoth;
        }

        return null;
    }

    virtual int PressedReload()
    {
        let pp = TOB_Util.GetPlayerOwnerForInventory(self);
        if (pp)
        {
            return pp.player.cmd.buttons & BT_RELOAD;
        }

        return false;
    }

    virtual bool MustReload(int fireMode = Weapon.PrimaryFire)
    {
        if (fireMode == Weapon.EitherFire)
        {
            let primaryMustReload = MustReload(Weapon.PrimaryFire);
            let secondaryMustReload = MustReload(Weapon.AltFire);

            if (primaryMustReload || secondaryMustReload)
            {
                return true;
            }
        }

        if (fireMode == Weapon.AltFire)
        {
            return subAmmo2.amount <= 0;
        }

        return subAmmo1.amount <= 0;
    }

    override void AttachToOwner(Actor other)
    {
        super.AttachToOwner(other);

        readonly<Ammo> a1 = null;
        readonly<Ammo> a2 = null;

        if (subAmmo1Type && subAmmo1Give < 0)
        {
            a1 = GetDefaultByType(subAmmo1Type);
            subAmmo1 = AddAmmo(owner, subAmmo1Type, a1.maxAmount);
        }

        if (subAmmo2Type && subAmmo2Give < 0)
        {
            a2 = GetDefaultByType(subAmmo2Type);
            subAmmo2 = AddAmmo(owner, subAmmo2Type, a2.maxAmount);
        }
    }

    override void BeginPlay()
    {
        super.BeginPlay();

        reloadState = CacheReloadState();
        reloadStateAlt = CacheReloadState(Weapon.AltFire);
        reloadStateBoth = CacheReloadState(Weapon.EitherFire);
    }

    override void DoEffect()
    {
        super.DoEffect();

        let pp = TOB_Util.GetPlayerOwnerForInventory(self);
        if (!pp || !pp.player || !pp.player.readyWeapon || self != pp.player.readyWeapon)
        {
            return;
        }

        let psp = pp.player.GetPSprite(PSP_WEAPON);
        if (!psp || !psp.curState)
        {
            return;
        }

        let reloadState = FindState('Reload');
        let isInReloadState = psp.curState.InStateSequence(reloadState);

        if (isInReloadState)
        {
            pp.player.weaponState &= ~(WF_WEAPONREADY | WF_WEAPONREADYALT);
        }

        if (CanReload() && (MustReload() || PressedReload()))
        {
            if (!isInReloadState)
            {
                pp.player.SetPSprite(PSP_WEAPON, reloadState);
            }
        }
    }

    // override void DoEffect()
    // {
    //     super.DoEffect();

    //     let pp = TOB_Util.GetPlayerOwnerForInventory(self);
    //     if (!pp || !pp.player)
    //     {
    //         return;
    //     }

    //     if (!pp.player.readyWeapon || pp.player.readyWeapon != self)
    //     {
    //         return;
    //     }

    //     let ps = pp.player.GetPSprite(PSP_WEAPON);
    //     let reloadState1 = FindState('Reload');
    //     let reloadState2 = FindState('AltReload');

    //     if (CanReload(subAmmo1, ammo1, ps, reloadState1))
    //     {
    //         ps.SetState(reloadState1);
    //     }
    //     else if (CanReload(subAmmo2, ammo2, ps, reloadState2))
    //     {
    //         ps.SetState(reloadState2);
    //     }
    // }

    override State GetAltAtkState(bool hold)
    {
        if (!subAmmo2 || subAmmo2.amount <= 0)
        {
            return GetReadyState();
        }

        return super.GetAltAtkState(hold);
    }

    override State GetAtkState(bool hold)
    {
        if (!subAmmo1 || subAmmo1.amount <= 0)
        {
            return GetReadyState();
        }

        return super.GetAtkState(hold);
    }

    // keep in mind this does not run every single frame
    override State GetReadyState()
    {
        if (CanReload() && MustReload())
        {
            return FindState('Reload');
        }

        return super.GetReadyState();
    }

    default
    {
        TOB_ReloadingWeapon.SubAmmo1Give -1;
        TOB_ReloadingWeapon.SubAmmo2Give -1;
    }
}
