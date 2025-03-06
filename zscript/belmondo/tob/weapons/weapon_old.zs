    // action void A_TOBFireBullets(double spreadHorz = 0, double spreadVert = 0,
    //                                                     int numBullets = 1,
    //                                                     int dmgMultiplier = 4,
    //                                                     int closeDmg = 15,
    //                                                     int farDmg = 7,
    //                                                     double closeDist = 128,
    //                                                     Class<Actor> puffType
    //                                                         = 'BulletPuff',
    //                                                     int flags = FBF_USEAMMO)
    // {
    //     let player = player;

    //     if (!player)
    //     {
    //         return;
    //     }

    //     let weapon = player.readyWeapon;

    //     if (!weapon)
    //     {
    //         return;
    //     }

    //     if ((flags & FBF_USEAMMO) && weapon && stateInfo && stateInfo.mStateType == STATE_PSprite)
    //     {
    //         if (!weapon.DepleteAmmo(false, true))
    //         {
    //             return;
    //         }
    //     }

    //     for (let i = 0; i < numBullets; i++)
    //     {
    //         let damage = farDmg;
    //         let angle = self.angle;

    //         let target = AimTarget();

    //         if (target)
    //         {
    //             angle = AngleTo(target);

    //             if (Distance2D(target) < closeDist)
    //             {
    //                 damage = closeDmg;
    //             }
    //         }

    //         if (flags & FBF_EXPLICITANGLE)
    //         {
    //             angle = spreadHorz;
    //         }
    //         else
    //         {
    //             angle += frandom(-spreadHorz, spreadHorz);
    //         }

    //         damage = random(0, damage) * dmgMultiplier;

    //         let attackZOffset = 0;

    //         if (self is 'PlayerPawn')
    //         {
    //             attackZOffset = PlayerPawn(self).attackZOffset;
    //         }

    //         let slope = BulletSlope() + frandom(-spreadVert, spreadVert);

    //         if (damage == 0)
    //         {
    //             FLineTraceData data;

    //             let hit = LineTrace(angle, PLAYERMISSILERANGE, slope, TRF_NOSKY|TRF_THRUACTORS, height / 2 + attackZOffset, data: data);

    //             if (hit)
    //             {
    //                 SpawnPuff(puffType, data.HitLocation - AngleToVector(angle), angle + 180, angle + 180, 0);
    //                 A_SprayDecal('BulletChip', offset: -data.hitDir, direction: data.hitDir);
    //             }

    //             continue;
    //         }

    //         LineAttack(angle, PLAYERMISSILERANGE, slope, damage, 'Hitscan', puffType, offsetz: attackZOffset);
    //         player.mo.PlayAttacking2();
    //     }
    // }
