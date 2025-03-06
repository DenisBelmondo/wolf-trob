class TOB_Gusher : Inventory
{
    states
    {
    Use:
        TNT1 A 4 { TOB_Util.SpawnBloodExplosion(invoker.owner); }
        loop;
    }
}
