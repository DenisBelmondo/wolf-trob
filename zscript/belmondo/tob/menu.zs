class TOB_ListMenu : ListMenu
{
    enum TOB_ECursorInfo
    {
        TOB_ECursorInfo_None,
        TOB_ECursorInfo_Left,
        TOB_ECursorInfo_Right
    }

    protected int cursorSideInfo;

    static Vector2 GetMenuItemDimensions(ListMenuItem item)
    {
        if (item is 'ListMenuItemTextItem')
        {
            let textItem = ListMenuItemTextItem(item);
            return (textItem.mFont.StringWidth(textItem.mText), textItem.mFont.GetHeight());
        }
        else if (item is 'ListMenuItemPatchItem')
        {
            let patchItem = ListMenuItemPatchItem(item);
            let patchSize = TexMan.GetScaledSize(patchItem.mTexture);
            return patchSize;
        }

        return (-1, -1);
    }

    Vector2 GetSelectorOffset()
    {
        return (mDesc.mSelectOfsX, mDesc.mSelectOfsY);
    }

    void SetSelectorOffset(Vector2 offset)
    {
        mDesc.mSelectOfsX = offset.x;
        mDesc.mSelectOfsY = offset.y;
    }

    virtual ListMenuItem GetSelectedItem()
    {
        return mDesc.mItems[mDesc.mSelectedItem];
    }

    virtual void DrawMenuItems()
    {
		for (let i = 0; i < mDesc.mItems.Size(); i++)
		{
			if (mDesc.mItems[i].mEnabled)
            {
                mDesc.mItems[i].Draw(mDesc.mSelectedItem == i, mDesc);
            }
		}
    }

    virtual bool ShouldDrawSelectors()
    {
        return mDesc.mSelectedItem >= 0 && mDesc.mSelectedItem < mDesc.mItems.Size();
    }

    virtual void DrawSelectors()
    {
        if (ShouldDrawSelectors())
		{
            let selectedItem = GetSelectedItem();

			if (!menuDelegate.DrawSelector(mDesc))
            {
                let dim = GetMenuItemDimensions(selectedItem);
                let strWidth = dim.x;

                if (cursorSideInfo & TOB_ECursorInfo_Left)
                {
                    selectedItem.DrawSelector(mDesc.mSelectOfsX, mDesc.mSelectOfsY, mDesc.mSelector, mDesc);
                }

                if (cursorSideInfo & TOB_ECursorInfo_Right)
                {
				    selectedItem.DrawSelector(strWidth + 4, mDesc.mSelectOfsY, mDesc.mSelector, mDesc);
                }
            }
        }
    }

    override void Init(Menu parent, ListMenuDescriptor desc)
    {
        super.Init(parent, desc);

        cursorSideInfo = TOB_ECursorInfo_Left|TOB_ECursorInfo_Right;
    }

    override void Ticker()
    {
        super.Ticker();
    }

    override void Drawer()
    {
        DrawMenuItems();
        DrawSelectors();
    }
}

class TOB_CenteredMenu : TOB_ListMenu
{
    const SCREEN_CENTER_X = 160;
    const SCREEN_CENTER_Y = 120;

    override void Init(Menu parent, ListMenuDescriptor desc)
    {
        super.Init(parent, desc);

        for (let i = 0; i < mDesc.mItems.Size(); i++)
        {
            let item = mDesc.mItems[i];
            let itemWidth = 0;

            if (item is 'ListMenuItemTextItem')
            {
                let textItem = ListMenuItemTextItem(item);
                itemWidth = textItem.GetWidth();
            }
            else if (item is 'ListMenuItemPatchItem')
            {
                let patchItem = ListMenuItemPatchItem(item);
                let patchItemSize = TexMan.GetScaledSize(patchItem.mTexture);
                itemWidth = patchItemSize.x;
            }

            item.SetX(SCREEN_CENTER_X - (itemWidth / 2));
        }
    }
}

class TOB_SkillMenu : TOB_ListMenu
{
    static const String SKILL_DESCRIPTIONS[] = {
        "Very easy difficulty setting for the spineless gamer.",
        "Easy difficulty for the novice gamer.",
        "Normal difficulty for the average gamer.",
        "Hard difficulty for the experienced gamer.",
        "Very hard difficulty setting for the heroic gamer.",
        "Ultra hard difficulty setting for the fearless gamer."
    };

    static const String MUGSHOT_NAMES[] = {
        "graphics/belmondo/tob/g_smug_baby.png",
        "graphics/belmondo/tob/g_smug_kid.png",
        "graphics/belmondo/tob/g_smug_teen.png",
        "graphics/belmondo/tob/g_smug_true.png",
        "graphics/belmondo/tob/g_smug_grownup.png",
        "graphics/belmondo/tob/g_smug_evil.png"
    };

    private TextureID _noTexture;

    protected ListMenuItemStaticText skillDescription;
    protected ListMenuItemStaticPatch mugshot;

    override void Init(Menu parent, ListMenuDescriptor desc)
    {
        skillDescription = new('ListMenuItemStaticText');
        skillDescription.Init(desc, 16, 200 - 16, "", Font.CR_GOLD);
        skillDescription.mFont = 'swtiny';
        desc.mItems.Push(skillDescription);

        mugshot = new('ListMenuItemStaticPatch');
        mugshot.Init(desc, 320 - 104, 200 - 40, _noTexture);
        desc.mItems.Push(mugshot);

        super.Init(parent, desc);
        cursorSideInfo = TOB_ListMenu.TOB_ECursorInfo_Right;
    }

    override void Ticker()
    {
        super.Ticker();

        skillDescription.mText = "Please select a difficulty level.";

        if (mDesc.mSelectedItem >= 0)
        {
            skillDescription.mText = SKILL_DESCRIPTIONS[clamp(mDesc.mSelectedItem - 1, 0, SKILL_DESCRIPTIONS.Size() - 1)];
        }
    }

    override void Drawer()
    {
        super.Drawer();

        let tex = _noTexture;

        if (mDesc.mSelectedItem >= 0)
        {
            tex = TexMan.CheckForTexture(
                MUGSHOT_NAMES[clamp(mDesc.mSelectedItem - 1, 0, MUGSHOT_NAMES.Size() - 1)]);
        }

        mugshot.mTexture = tex;
    }
}
