mixin class TOB_BulletShooterMixin
{
    Class<Actor> bulletClass;
    property bulletClass: bulletClass;

    Sound shootSound;
    property shootSound: shootSound;

    virtual void PlayShootSound()
    {
        A_StartSound(shootSound, CHAN_WEAPON);
    }

    virtual void Shoot()
    {
        A_SpawnProjectile(bulletClass, missileHeight);
        PlayShootSound();
    }

    action void A_PlayShootSound()
    {
        invoker.PlayShootSound();
    }
}
