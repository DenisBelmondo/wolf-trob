mixin class TOB_Component
{
    default
    {
        Inventory.MaxAmount 1;

        +Inventory.AUTOACTIVATE;
        +Inventory.UNDROPPABLE;
        +Inventory.UNTOSSABLE;
    }
}
