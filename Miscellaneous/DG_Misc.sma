#include <amxmodx>
#include <reapi>
#include <DeathGift>

new const PLUG_NAME[] = "[DG] Misc Bonuses";
new const PLUG_VER[] = "1.1.0";

new Float:g_fSpeedMult[MAX_PLAYERS + 1] = {1.0, ...};

new HookChain:g_iHook_ResetMaxSpeed = INVALID_HOOKCHAIN;
new HookChain:g_iHook_Spawn_Pre = INVALID_HOOKCHAIN;

public DG_OnBonusesInit(){
    register_plugin(PLUG_NAME, PLUG_VER, "ArKaNeMaN");

    DG_RegisterBonus(
        "Misc-Speed", "@Bonus_Speed",
        "Multiplier", ptFloat,
        "Duration", ptFloat
    );
    DG_RegisterBonus(
        "Misc-Health", "@Bonus_Health",
        "Health", ptInteger,
        "ToHealth", ptInteger,
        "MaxHealth", ptInteger
    );
    DG_RegisterBonus(
        "Misc-Armor", "@Bonus_Armor",
        "Armor", ptInteger,
        "ToArmor", ptInteger,
        "MaxArmor", ptInteger
    );
    DG_RegisterBonus(
        "Misc-Money", "@Bonus_Money",
        "Money", ptInteger,
        "MaxMoney", ptInteger
    );
    DG_RegisterBonus(
        "Misc-Item", "@Bonus_Item",
        "ItemName", ptString,
        "GiveType", ptString
    );
    DG_RegisterBonus("Misc-Empty", "@Bonus_Empty");

    DisableHookChain(g_iHook_ResetMaxSpeed = RegisterHookChain(RG_CBasePlayer_ResetMaxSpeed, "@OnResetMaxSpeedPost", true));
    DisableHookChain(g_iHook_Spawn_Pre = RegisterHookChain(RG_CBasePlayer_Spawn, "@OnPlayerSpawnPre", false));
}

@OnResetMaxSpeedPost(const UserId) {
    MultUserSpeed(UserId, g_fSpeedMult[UserId]);
}

@OnPlayerSpawnPre(const UserId) {
    g_fSpeedMult[UserId] = 1.0;
}

@Bonus_Speed(const UserId, const Trie:p){
    g_fSpeedMult[UserId] = DG_ReadParamFloat(p, "Multiplier", 1.0);

    MultUserSpeed(UserId, g_fSpeedMult[UserId]);
    
    EnableHookChain(g_iHook_ResetMaxSpeed);
    EnableHookChain(g_iHook_Spawn_Pre);

    new Float:fDuration = DG_ReadParamFloat(p, "Duration", 0.0);

    if (fDuration > 0.0) {
        set_task(fDuration, "@Task_ResetSpeedMult", UserId);
    }
}

@Task_ResetSpeedMult(const UserId) {
    g_fSpeedMult[UserId] = 1.0;
    rg_reset_maxspeed(UserId);
}

@Bonus_Health(const UserId, const Trie:p){
    new Health = DG_ReadParamInt(p, "Health");
    new ToHealth = DG_ReadParamInt(p, "ToHealth", Health);
    new MaxHealth = DG_ReadParamInt(p, "MaxHealth", 100);

    if (get_user_health(UserId) >= MaxHealth) {
        return;
    }

    set_entvar(UserId, var_health, float(clamp(get_user_health(UserId) + random_num(Health, ToHealth), 0, MaxHealth)));
}

@Bonus_Armor(const UserId, const Trie:p){
    new Armor = DG_ReadParamInt(p, "Armor");
    new ToArmor = DG_ReadParamInt(p, "ToArmor", Armor);
    new MaxArmor = DG_ReadParamInt(p, "MaxArmor", 100);

    if (rg_get_user_armor(UserId) >= MaxArmor) {
        return;
    }

    new ArmorType:Type;
    new iCurArmor = rg_get_user_armor(UserId, Type);
    if (Type != ARMOR_NONE) {
        Type = ARMOR_KEVLAR;
    }

    rg_set_user_armor(UserId, clamp(iCurArmor + random_num(Armor, ToArmor), 0, MaxArmor), Type);
}

@Bonus_Money(const UserId, const Trie:p){
    new Money = DG_ReadParamInt(p, "Money");
    new MaxMoney = DG_ReadParamInt(p, "MaxMoney", Money);

    rg_add_account(UserId, random_num(Money, MaxMoney));
}

@Bonus_Item(const UserId, const Trie:p){
    new ItemName[32], strGiveType[16];
    DG_ReadParamString(p, "ItemName", ItemName, charsmax(ItemName));
    DG_ReadParamString(p, "GiveType", strGiveType, charsmax(strGiveType), "DropReplace");

    rg_give_item(UserId, ItemName, StrToGivetype(strGiveType));
}

@Bonus_Empty(const UserId, const Trie:p){
    // Пусто))
}


GiveType:StrToGivetype(const Str[]){
    if(equali(Str, "Append"))
        return GT_APPEND;
    else if(equali(Str, "Replace"))
        return GT_REPLACE;
    else if(equali(Str, "DropReplace"))
        return GT_DROP_AND_REPLACE;
    else{
        log_amx("[WARNING] Undefined give type `%s`.", Str);
        return GT_DROP_AND_REPLACE;
    }
}

MultUserSpeed(const UserId, const Float:fMultiplier) {
    set_entvar(UserId, var_maxspeed, Float:get_entvar(UserId, var_maxspeed) * fMultiplier);
}
