class TOB_Util abstract
{
    static double GetArea(Array<double> x, Array<double> y)
    {
        if (x.Size() != y.Size())
        {
            ThrowAbortException("x.Size() != y.Size()");
        }

        double area = 0.0;

        let n = x.Size();
        let j = n - 1;

        for (let i = 0; i < n; i++)
        {
            area += (x[j] + x[i]) * (y[j] - y[i]);
            j = i;
        }

        return abs(area) / 2.0;
    }

    static double SectorGetArea(Sector sec)
    {
        Array<double> x, y;

        for (let i = 0; i < sec.lines.Size(); i++)
        {
            x.Push(sec.lines[i].v1.p.x);
            y.Push(sec.lines[i].v1.p.y);
        }

        return TOB_Util.GetArea(x, y);
    }

    static string GetPickupMessageForInventory(Inventory inv, string tag = "")
    {
        if (!tag)
        {
            tag = "";
        }

        if (tag == "")
        {
            tag = inv.pickupMsg;
        }

        if (tag == "")
        {
            tag = inv.GetTag();
        }

        if (tag == "")
        {
            tag = inv.GetClassName();
        }

        let amt = inv.amount;

        if (inv is 'Ammo' && !inv.bIgnoreSkill)
        {
            let amo = Ammo(inv);

            // most of this is from:
            // "wadsrc/static/zscript/actors/inventory/ammo.zs"

            double dropAmmoFactor = G_SkillPropertyFloat(SKILLP_AmmoFactor);
            // Default drop amount is half of regular amount * regular ammo multiplication
            if (dropAmmoFactor == -1)
            {
                dropAmmoFactor = 1;
            }

            amt = int(amo.amount * dropAmmoFactor);
        }

        if (inv is 'BasicArmor')
        {
            amt = BasicArmor(inv).actualSaveAmount;
        }

        if (inv is 'BasicArmorBonus')
        {
            amt = BasicArmorBonus(inv).saveAmount;
        }

        if (inv is 'BasicArmorPickup')
        {
            amt = BasicArmorPickup(inv).saveAmount;
        }

        return String.Format("+%d %s", amt, tag);
    }

    static PlayerPawn GetPlayerOwnerForInventory(Inventory inv)
    {
        let owner = inv.owner;

        if (!owner || !(owner is 'PlayerPawn'))
        {
            return null;
        }

        return PlayerPawn(owner);
    }

    static play Actor SpawnBloodExplosion(Actor onWhich)
    {
        Actor a;
        bool b;

        [b, a] = onWhich.A_SpawnItemEx(
            'TOB_BloodExplosion',
            frandom(-onWhich.radius / 2, onWhich.radius / 2),
            frandom(-onWhich.radius / 2, onWhich.radius / 2),
            onWhich.default.height / 2
                + frandom[TOB_Util_SpawnBloodExplosion](
                    -onWhich.default.height / 2,
                    onWhich.default.height / 2
                ),
            flags: SXF_USEBLOODCOLOR);

        return a;
    }
}
