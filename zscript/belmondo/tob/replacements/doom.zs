#include "zscript/belmondo/tob/nazi_spawner.zs"

class TOB_Relpacements_HealthBonus : RandomSpawner replaces HealthBonus
{
    default
    {
        DropItem 'TOB_DogFood';
    }
}

class TOB_Relpacements_Stimpack : RandomSpawner replaces Stimpack
{
    default
    {
        DropItem 'TOB_BigDinner';
    }
}

class TOB_Relpacements_Medikit : RandomSpawner replaces Medikit
{
    default
    {
        DropItem 'TOB_Medkit';
    }
}

class TOB_Relpacements_ArmorBonus : RandomSpawner replaces ArmorBonus
{
    default
    {
        DropItem 'TOB_Helmet';
    }
}

class TOB_Relpacements_GreenArmor : RandomSpawner replaces GreenArmor
{
    default
    {
        DropItem 'TOB_FlakJacket';
    }
}

class TOB_Relpacements_BlueArmor : RandomSpawner replaces BlueArmor
{
    default
    {
        DropItem 'TOB_MegaArmor';
    }
}

class TOB_Relpacements_Allmap : RandomSpawner replaces Allmap
{
    default
    {
        DropItem 'TOB_FloorPlans';
    }
}

class TOB_Relpacements_RedCard : RandomSpawner replaces RedCard
{
    default
    {
        DropItem 'TOB_RedCard';
    }
}

class TOB_Relpacements_YellowCard : RandomSpawner replaces YellowCard
{
    default
    {
        DropItem 'TOB_YellowCard';
    }
}

class TOB_Relpacements_BlueCard : RandomSpawner replaces BlueCard
{
    default
    {
        DropItem 'TOB_BlueCard';
    }
}

class TOB_Relpacements_RedSkull : RandomSpawner replaces RedSkull
{
    default
    {
        DropItem 'TOB_RedSkull';
    }
}

class TOB_Relpacements_YellowSkull : RandomSpawner replaces YellowSkull
{
    default
    {
        DropItem 'TOB_YellowSkull';
    }
}

class TOB_Relpacements_BlueSkull : RandomSpawner replaces BlueSkull
{
    default
    {
        DropItem 'TOB_BlueSkull';
    }
}

class TOB_Relpacements_ExplosiveBarrel : RandomSpawner replaces ExplosiveBarrel
{
    default
    {
        DropItem 'TOB_ExplosiveBarrel';
    }
}

class TOB_Relpacements_Chainsaw : RandomSpawner replaces Chainsaw
{
    default
    {
        DropItem 'TOB_MachineGun';
    }
}

class TOB_Relpacements_Pistol : RandomSpawner replaces Pistol
{
    default
    {
        DropItem 'TOB_Pistol';
    }
}

class TOB_Relpacements_Shotgun : RandomSpawner replaces Shotgun
{
    default
    {
        DropItem 'TOB_Rifle';
    }
}

class TOB_Relpacements_SuperShotgun : RandomSpawner replaces SuperShotgun
{
    default
    {
        DropItem 'TOB_Chaingun';
    }
}

class TOB_Relpacements_Chaingun : RandomSpawner replaces Chaingun
{
    default
    {
        DropItem 'TOB_MachineGun';
    }
}

class TOB_Relpacements_RocketLauncher : RandomSpawner replaces RocketLauncher
{
    default
    {
        DropItem 'TOB_Bazooka';
    }
}

class TOB_Relpacements_PlasmaRifle : RandomSpawner replaces PlasmaRifle
{
    default
    {
        DropItem 'TOB_FlameThrower';
    }
}

class TOB_Relpacements_Clip : RandomSpawner replaces Clip
{
    default
    {
        DropItem 'TOB_Clip';
    }
}

class TOB_Relpacements_ClipBox : RandomSpawner replaces ClipBox
{
    default
    {
        DropItem 'TOB_ClipBox';
    }
}

class TOB_Relpacements_Shell : RandomSpawner replaces Shell
{
    default
    {
        DropItem 'TOB_StripperClip';
    }
}

class TOB_Relpacements_ShellBox : RandomSpawner replaces ShellBox
{
    default
    {
        DropItem 'TOB_StripperClipBox';
    }
}

class TOB_Relpacements_RocketAmmo : RandomSpawner replaces RocketAmmo
{
    default
    {
        DropItem 'TOB_RocketAmmo';
    }
}

class TOB_Relpacements_RocketBox : RandomSpawner replaces RocketBox
{
    default
    {
        DropItem 'TOB_RocketBox';
    }
}

class TOB_Relpacements_Cell : RandomSpawner replaces Cell
{
    default
    {
        DropItem 'TOB_FuelAmmo';
    }
}

class TOB_Relpacements_CellPack : RandomSpawner replaces CellPack
{
    default
    {
        DropItem 'TOB_FuelBox';
    }
}

class TOB_Relpacements_Backpack : RandomSpawner replaces Backpack
{
    default
    {
        DropItem 'TOB_Backpack';
    }
}

class TOB_Relpacements_BlurSphere : RandomSpawner replaces BlurSphere
{
    default
    {
        DropItem 'TOB_EnemyUniform';
    }
}

class TOB_Replacements_ZombieMan : TOB_NaziSpawner replaces ZombieMan
{
    default
    {
        DropItem 'TOB_Guard';
    }
}

class TOB_Replacements_ShotgunGuy : TOB_NaziSpawner replaces ShotgunGuy
{
    default
    {
        DropItem 'TOB_Rifleman';
    }
}

class TOB_Replacements_ChaingunGuy : TOB_NaziSpawner replaces ChaingunGuy
{
    default
    {
        DropItem 'TOB_SSGuard';
    }
}

class TOB_Replacements_DoomImp : RandomSpawner replaces DoomImp
{
    default
    {
        DropItem 'TOB_FireSkeleton';
    }
}


//
// TODO: make it so that a funny secret enemy spawns only on secret levels
//

class TOB_Replacements_WolfensteinSS : RandomSpawner replaces WolfensteinSS
{
    default
    {
        DropItem 'TOB_SSGuard';
    }
}

class TOB_Replacements_Cacodemon : RandomSpawner replaces Cacodemon
{
    default
    {
        DropItem 'TOB_FakeHitler';
    }
}

class TOB_Replacements_Demon : RandomSpawner replaces Demon
{
    default
    {
        DropItem 'TOB_Skeleton';
    }
}
