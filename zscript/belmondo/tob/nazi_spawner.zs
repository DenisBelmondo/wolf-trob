class TOB_NaziSpawner : RandomSpawner abstract
{
    // TODO: refactor this out? maybe?

    Class<Actor> DamagingFloorSpawnClass;
    property DamagingFloorSpawnClass: DamagingFloorSpawnClass;

    override Name ChooseSpawn()
    {
        if (curSector && (curSector.flags & Sector.SECF_DAMAGEFLAGS))
        {
            let d = GetDefaultByType(DamagingFloorSpawnClass);
            let n = d.GetClassName();

            return n;
        }

        return super.ChooseSpawn();
    }

    override void PostSpawn(Actor spawned)
    {
        super.PostSpawn(spawned);

        if (spawned is 'TOB_Nazi')
        {
            let nazi = TOB_Nazi(spawned);

            if (!bAmbush)
            {
                nazi.SetAlertState(TOB_Nazi.EAlertState_Wandering);
                nazi.SetState(nazi.ResolveState('Idle'));
            }
        }
    }

    default
    {
        // TODO: hard dependency on "TOB_Skeleton"
        TOB_NaziSpawner.DamagingFloorSpawnClass 'TOB_Skeleton';
    }
}
