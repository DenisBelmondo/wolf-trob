class TOB_Toaster abstract play
{
    static void Toast(Actor a)
    {
        a.A_SetTranslation('TOB_Crispy');
    }
}

class TOB_ToastHandler : EventHandler
{
    override void WorldThingDamaged(WorldEvent e)
    {
        super.WorldThingDamaged(e);

        if (e.thing && (e.thing.bIsMonster || e.thing is 'PlayerPawn')
                    && ((e.damageType == 'Fire'     && !e.thing.FindState('Death.Fire'    , true))
                     || (e.damageType == 'Electric' && !e.thing.FindState('Death.Electric', true)))
                    &&  e.thing.health <= 0
                    && !e.thing.bNoBlood /*
                    &&  e.thing.InStateSequence(e.thing.curState,
                                                e.thing.ResolveState('Death'))*/)
        {
            TOB_Toaster.Toast(e.thing);
        }
    }
}
