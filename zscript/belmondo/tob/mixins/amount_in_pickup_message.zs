mixin class TOB_AmountInPickupMessage
{
    override string PickupMessage()
    {
        return TOB_Util.GetPickupMessageForInventory(self, pickupMsg);
    }
}
