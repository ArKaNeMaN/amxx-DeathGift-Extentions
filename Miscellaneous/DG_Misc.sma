#include <amxmodx>
#include <reapi>
#include <DeathGift>

#define MAX_HEALTH 120
#define MAX_ARMOR 120

new const PLUG_NAME[] = "[DG] Misc Bonuses";
new const PLUG_VER[] = "1.0.0";

public DG_OnBonusesInit(){
    register_plugin(PLUG_NAME, PLUG_VER, "ArKaNeMaN");

    DG_RegisterBonus(
        "Misc-Health", "@Bonus_Health",
        "Health", ptInteger,
        "MaxHealth", ptInteger
    );
    DG_RegisterBonus(
        "Misc-Armor", "@Bonus_Armor",
        "Armor", ptInteger,
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
}

@Bonus_Health(const UserId, const Trie:p){
    new Health = DG_ReadParamInt(p, "Health");
    new MaxHealth = DG_ReadParamInt(p, "MaxHealth", Health);

    Health = random_num(Health, MaxHealth);
    Health = clamp(Health+get_user_health(UserId), 0, MAX_HEALTH);

    set_entvar(UserId, var_health, float(Health));
}

@Bonus_Armor(const UserId, const Trie:p){
    new Armor = DG_ReadParamInt(p, "Armor");
    new MaxArmor = DG_ReadParamInt(p, "MaxArmor", Armor);
    new ArmorType:Type;

    Armor = random_num(Armor, MaxArmor);
    Armor = clamp(Armor+rg_get_user_armor(UserId, Type), 0, MAX_ARMOR);
    if(Type != ARMOR_NONE)
        Type = ARMOR_KEVLAR;

    rg_set_user_armor(UserId, Armor, Type);
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

//================ [ Utils ] ================//

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