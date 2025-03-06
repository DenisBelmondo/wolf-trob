class TOB_NaziSpawner : RandomSpawner abstract
{
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
}
