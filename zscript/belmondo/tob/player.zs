#include "zscript/belmondo/tob/player_nashmove.zs"
#include "zscript/belmondo/tob/player_bleedout.zs"
#include "zscript/belmondo/tob/inventory/component/last_chance.zs"

class TOB_Player : PlayerPawn
{
    mixin TOB_NashMovePlayerMixin;

    override void Tick()
    {
        if (!player || !player.mo || player.mo != self)
        {
            super.Tick();
            return;
        }

        TOB_NashMoveMixin__BeforeTick();

        super.Tick();
    }

    // override int DamageMobj(Actor inflictor, Actor source, int damage, Name mod, int flags, double angle)
    // {
    //     let result = super.DamageMobj(inflictor, source, damage, mod, flags, angle);

    //     if (health <= 1)
    //     {
    //         Console.Printf("Low health!");
    //         A_StartSound("misc/low_health", CHAN_AUTO, CHANF_LOCAL|CHANF_UI, 1.0, ATTN_NONE);
    //         GiveInventoryType('TOB_RespawnInvulnerability');
    //         GiveInventoryType('TOB_RespawnInvisibility');
    //     }

    //     return result;
    // }

    override void DeathThink()
    {
        super.DeathThink();

        if (CountInv('TOB_ExtraLife') && (player.cmd.buttons & BT_USE))
        {
            // part 1: revive (loosely replicates the resurrect cheat)

            Revive();
            player.playerState = PST_LIVE;
            player.health = default.health;
            // player.health = TOB_BleedoutPlayerMixin__BLEEDOUT_NTH_MULTIPLE;
            viewHeight = default.viewHeight;
            RestoreRenderStyle();
            A_SetSize(default.radius, default.height);
            special1 = 0;
            SetState(spawnState);

            if (player.readyWeapon)
            {
                player.pendingWeapon = player.readyWeapon;
                BringUpWeapon();
            }

            if (player.morphTics != 0)
            {
                Unmorph(self, 0, true);
            }

            // part 2: teleport (stole this from ArtiTeleport)

            // Vector3 dest;
            // int destAngle;

            // if (deathmatch)
            // {
            //     [dest, destAngle] = level.PickDeathmatchStart();
            // }
            // else
            // {
            //     [dest, destAngle] = level.PickPlayerStart(PlayerNumber());
            // }

            // dest.Z = ONFLOORZ;
            // Teleport(dest, destAngle, TELF_SOURCEFOG | TELF_DESTFOG);

            Teleport(pos, angle, TELF_DESTFOG);
            GiveInventoryType('TOB_RespawnInvulnerability');
            GiveInventoryType('TOB_RespawnInvisibility');
            TakeInventory('TOB_ExtraLife', 1);
        }
    }

    default
    {
        Speed 1;
        Health 100;
        Radius 16;
        Height 56;
        Mass 100;
        PainChance 255;
        Scale 1.1;
        Player.ForwardMove 1.5, 1.5;
        Player.SideMove 1.5, 1.5;
        Player.ColorRange 112, 127;
        Player.ColorSet 0, "Gray", 80, 111, 98;
        Player.DisplayName "Blazkowicz";
        Player.SoundClass "TOB_BJ";
        Player.Face "BJF";
        Player.Portrait "g_bji_0";
        Player.StartItem 'TOB_Clip', 48;
        Player.StartItem 'TOB_Pistol';
        Player.StartItem 'TOB_Knife';
        Player.StartItem 'TOB_Bleedout';
        Player.StartItem 'TOB_LastChance';
        Player.WeaponSlot 1, 'TOB_Knife';
        Player.WeaponSlot 2, 'TOB_Pistol', 'TOB_MachineGun'/*, 'TOB_DualPistols'*/;
        Player.WeaponSlot 3, 'TOB_MachineGun', 'TOB_Rifle';
        Player.WeaponSlot 4, 'TOB_Chaingun', 'TOB_AssaultRifle';
        Player.WeaponSlot 5, 'TOB_Bazooka', 'TOB_FlameThrower';
        Player.WeaponSlot 6, 'TOB_FlameThrower', 'TOB_Bazooka';
        Player.WeaponSlot 7, 'TOB_Chaingun', 'TOB_TeslaGun';
        Player.WeaponSlot 8, 'TOB_PortableMedkitWeapon';
    }

    states
    {
    Spawn:
        WJBZ A -1;
        loop;
    See:
        WJBZ ABCD 4;
        loop;
    Missile:
        WJBZ F 12;
        goto Spawn;
    Melee:
        WJBZ G 6 Bright;
        goto Spawn;
    Pain:
        WJBZ HI 0; // precache
        WJBZ H 0 {
            invoker.frame += invoker.health & 1;
        }
        WJBZ "#" 4;
        WJBZ "#" 4 A_Pain();
        goto Spawn;
    XDeath:
    Death:
        WJBZ J 10 {
            A_PlayerScream();
            A_NoBlocking();
        }
        WJBZ KL 10;
        WJBZ M -1;
        stop;
    }
}
