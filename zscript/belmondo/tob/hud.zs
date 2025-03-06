class TOB_StatusBar : BaseStatusBar
{
    DynamicValueInterpolator mHealthInterpolator,
                             mArmorInterpolator,
                             mAmmo1Interpolator,
                             mAmmo2Interpolator,
                             mScoreInterpolator;

    private HUDFont _bigFont,
                    _medFont,
                    _tinyFont;

    static HUDFont CreateMonospaceRightAlignedFromFont(Font fnt)
    {
        return HUDFont.Create(fnt, fnt.GetCharWidth("0"), Mono_CellRight, 1, 1);
    }

    static HUDFont CreateMonospaceRightAlignedFromName(Name fntName)
    {
        return CreateMonospaceRightAlignedFromFont(Font.GetFont(fntName));
    }

    Vector2 GetStringDimensions(Font fnt, String text, bool isMonospaced = false, int charWidth = -1)
    {
        let w = -1;
        let h = fnt.GetHeight();

        if (isMonospaced)
        {
            if (charWidth < 0)
            {
                return (fnt.GetCharWidth("0") * text.Length(), h);
            }

            return (charWidth * text.Length(), h);
        }

        return (fnt.StringWidth(text), h);
    }

    void DrawHealthWithoutArmor(Vector2 bottomLeft)
    {
        let healthAmount = cplayer.health;
        // let healthString = FormatNumber(healthAmount, 3, 3);
        let healthString = FormatNumber(mHealthInterpolator.GetValue(), 3, 3);

        bottomLeft.x += _bigFont.mFont.StringWidth(healthString);
        bottomLeft.y -= _bigFont.mFont.GetHeight();

        DrawString(_bigFont, healthString, bottomLeft, DI_TEXT_ALIGN_RIGHT, Font.CR_CYAN);
    }

    void DrawHealthWithArmor(Vector2 bottomLeft)
    {
        let pos = bottomLeft;

        let armor = cplayer.mo.FindInventory('BasicArmor');
        int armorAmount;
        let armorString = "";
        let armorTexture = TexMan.CheckForTexture("graphics/belmondo/tob/g_marmor.png");
        let armorTextureSize = TexMan.GetScaledSize(armorTexture);

        if (armor && armor.amount > 0)
        {
            armorAmount = armor.amount;
            // armorString = FormatNumber(armorAmount, 3, 3);
            armorString = FormatNumber(mArmorInterpolator.GetValue(), 3, 3);
            DrawTexture(armorTexture, pos, DI_ITEM_LEFT_BOTTOM);
            pos.x += armorTextureSize.x + _medFont.mFont.GetCharWidth("0") * 3 + 4;
            pos.y -= _medFont.mFont.GetHeight();
            DrawString(_medFont, armorString, pos, DI_TEXT_ALIGN_RIGHT, Font.CR_CYAN);
            pos.y -= 4;
        }

        let healthAmount = cplayer.health;
        // let healthString = FormatNumber(healthAmount, 3, 3);
        let healthString = FormatNumber(mHealthInterpolator.GetValue(), 3, 3);
        let healthTexture = TexMan.CheckForTexture("graphics/belmondo/tob/g_mhealth.png");
        let healthTextureSize = TexMan.GetScaledSize(healthTexture);

        pos.x = bottomLeft.x;
        DrawTexture(healthTexture, pos, DI_ITEM_LEFT_BOTTOM);

        pos.x += healthTextureSize.x + _medFont.mFont.GetCharWidth("0") * 3 + 4;
        pos.y -= _medFont.mFont.GetHeight();
        DrawString(_medFont, healthString, pos, DI_TEXT_ALIGN_RIGHT, Font.CR_CYAN);
    }

    void DrawFullscreenShit(double ticFrac)
    {
        let cursor = (12, -8);

        let mugshotSize = (24, 32);

        cursor.x += mugshotSize.x / 2;
        DrawTexture(GetMugshot(7, Mugshot.ANIMATEDGODMODE), cursor);
        let mugshotCoords = cursor;

        //
        // lives
        //

        let livesAmt = cplayer.mo.CountInv('TOB_ExtraLife');
        if (livesAmt)
        {
            DrawString(_tinyFont, FormatNumber(livesAmt),
                                  (cursor.x + mugshotSize.x / 2,
                                   cursor.y - _tinyFont.mFont.GetHeight() + 1),
                                  translation: Font.CR_FIRE);
        }

        cursor.x += (mugshotSize.x / 2);
        cursor.y -= 2;

        //
        // armor and health
        //

        let armor = cplayer.mo.FindInventory('BasicArmor');

        if (armor && armor.amount > 0)
        {
            cursor.x += 4;
            DrawHealthWithArmor(cursor);
        }
        else
        {
            cursor.x += 8;
            DrawHealthWithoutArmor(cursor);
        }

        //
        // score
        //

        cursor.y = -44 - _medFont.mFont.GetHeight();
        cursor.x = (mugshotSize.x / 2) + 4;

        let scoreIcon = TexMan.CheckForTexture("graphics/belmondo/tob/g_points.png");
        let scoreIconSize = TexMan.GetScaledSize(scoreIcon);
        cursor.x -= 8;
        DrawTexture(scoreIcon, cursor, DI_ITEM_LEFT_TOP);
        cursor.x += 5;

        cursor.x += _medFont.mFont.GetCharWidth("0") * 7;
        DrawString(_medFont, String.Format("%06d", mScoreInterpolator.GetValue()), cursor, DI_TEXT_ALIGN_RIGHT, Font.CR_CYAN);

        //
        // inventory box
        //

        if (cplayer.mo.invSel)
        {
            let invBoxTexture = TexMan.CheckForTexture("graphics/belmondo/tob/SELECTBO.png");
            let invBoxSize = TexMan.GetScaledSize(invBoxTexture);

            cursor.x += 8;
            cursor.y = -8;

            DrawTexture(invBoxTexture, cursor, DI_ITEM_LEFT_BOTTOM);

            let invIconPos = (cursor.x + invBoxSize.x / 2, cursor.y - invBoxSize.y / 2);
            DrawInventoryIcon(cplayer.mo.invSel, invIconPos, DI_ITEM_CENTER, boxSize: invBoxSize);

            let invCountPos = (cursor.x + invBoxSize.x, cursor.y - _tinyFont.mFont.GetHeight());
            invCountPos -= (2, 2);

            DrawString(_tinyFont, String.Format("%d", cplayer.mo.invSel.amount), invCountPos, DI_TEXT_ALIGN_RIGHT, Font.CR_FIRE);
        }

        //
        // ammo
        //

        cursor = (-12, -8);

        Ammo a1, a2;
        [a1, a2] = GetCurrentAmmo();

        if (cplayer.readyWeapon is 'TOB_ReloadingWeapon')
        {
            let w = TOB_ReloadingWeapon(cplayer.readyWeapon);
            a2 = a1;
            a1 = w.subAmmo1;
        }

        let ammoIconSize = (16, 16);

        if (a1 && a2)
        {
            if (a2.icon)
            {
                DrawTexture(a2.icon, cursor, DI_ITEM_RIGHT_BOTTOM, box: ammoIconSize);
                cursor.x -= ammoIconSize.x;
            }

            let a2Font = _medFont;
            // let a2String = FormatNumber(a2.amount, 3, 3);
            let a2String = FormatNumber(mAmmo2Interpolator.GetValue());
            cursor.y -= a2Font.mFont.GetHeight();
            DrawString(a2Font, a2String, cursor, DI_TEXT_ALIGN_RIGHT, Font.CR_CYAN);
            cursor.x -= a2Font.mFont.GetCharWidth("0") * a2String.Length() + 8;
            cursor.y = -8;

            if (a1.icon)
            {
                DrawTexture(a1.icon, cursor, DI_ITEM_RIGHT_BOTTOM, box: ammoIconSize);
                cursor.x -= ammoIconSize.x;
            }

            let a1Font = _bigFont;
            let a1String = FormatNumber(a1.amount, 3, 3);
            // let a1String = FormatNumber(mAmmo1Interpolator.GetValue(), 3, 3);
            cursor.y -= a1Font.mFont.GetHeight();
            DrawString(a1Font, a1String, cursor, DI_TEXT_ALIGN_RIGHT, Font.CR_CYAN);
        }
        else if (a1)
        {
            DrawTexture(a1.icon, cursor, DI_ITEM_RIGHT_BOTTOM, box: ammoIconSize);
            cursor.x -= ammoIconSize.x;

            let a1Font = _bigFont;
            let a1String = FormatNumber(a1.amount, 3, 3);
            cursor.y -= a1Font.mFont.GetHeight();
            DrawString(a1Font, a1String, cursor, DI_TEXT_ALIGN_RIGHT, Font.CR_CYAN);
            cursor.x -= a1Font.mFont.StringWidth(a1String) + 8;
        }

        //
        // keys
        //

        cursor.x = -8;
        cursor.y -= 8;

        for (let i = cplayer.mo.inv; i != null; i = i.inv)
        {
            if (i is 'Key')
            {
                DrawInventoryIcon(i, cursor, DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM, boxSize: (16, 16));
                cursor.x -= 16;
            }
        }
    }

    override void Init()
    {
        super.Init();

        mHealthInterpolator = DynamicValueInterpolator.Create(0, 0.25, 1, 8);
        mArmorInterpolator  = DynamicValueInterpolator.Create(0, 0.25, 1, 8);
        mAmmo1Interpolator  = DynamicValueInterpolator.Create(0, 0.25, 1, 8);
        mAmmo2Interpolator  = DynamicValueInterpolator.Create(0, 0.25, 1, 8);
        mScoreInterpolator  = DynamicValueInterpolator.Create(0, 0.25, 1, 200);

        _bigFont  = CreateMonospaceRightAlignedFromName('BIGFONT');
        _medFont  = CreateMonospaceRightAlignedFromName('MEDNUM');
        _tinyFont = CreateMonospaceRightAlignedFromName('SWTINY');
    }

    override void NewGame()
    {
        super.NewGame();

        mHealthInterpolator.Reset(0);
        mArmorInterpolator.Reset(0);
        mAmmo1Interpolator.Reset(0);
        mAmmo2Interpolator.Reset(0);
        mScoreInterpolator.Reset(0);
    }

    override void Tick()
    {
        super.Tick();

        let armor = cplayer.mo.FindInventory('BasicArmor');

        mHealthInterpolator.Update(cplayer.health);

        if (armor)
        {
            mArmorInterpolator.Update(armor.amount);
        }

        Ammo a1, a2;
        [a1, a2] = GetCurrentAmmo();

        if (cplayer.readyWeapon is 'TOB_ReloadingWeapon')
        {
            let w = TOB_ReloadingWeapon(cplayer.readyWeapon);
            a2 = a1;
            a1 = w.subAmmo1;
        }

        if (a1)
        {
            mAmmo1Interpolator.Update(a1.amount);
        }

        if (a2)
        {
            mAmmo2Interpolator.Update(a2.amount);
        }

        mScoreInterpolator.Update(cplayer.mo.score);
    }

    override void Draw(int state, double ticFrac)
    {
        super.Draw(state, ticFrac);

        if (state == HUD_StatusBar)
        {
        }
        else if (state == HUD_Fullscreen)
        {
            BeginHUD();
            DrawFullscreenShit(ticFrac);
        }
    }
}
