#include <amxmodx>
#include <customshop>
#include <crxranks>
#include <DeathGift>

#pragma compress 1
#pragma semicolon 1

public stock const PluginName[] = "[DG] OciXCrom Ext.";
public stock const PluginVersion[] = "1.0.0";
public stock const PluginAuthor[] = "ArKaNeMaN";
public stock const PluginUrl[] = "t.me/arkaneman";

/*
    Бонус `CRX-Shop-Points`
    Описание:
        Выдаёт указанное кол-во очков для магазина CustomShop от OciXCrom
    Параметры:
        - Amount <Целое число>: Кол-во очков.
        
    Бонус `CRX-Ranks-Exp`
    Описание:
        Выдаёт указанное кол-во опыта для системы рангов от OciXCrom
    Параметры:
        - Amount <Целое число>: Кол-во опыта.

    Пример:
    [
        {
            "Name": "Очки для магазина",
            "Chance": 1,
            "Bonus": "CRX-Shop-Points",
            "Params": {
                "Amount": 50
            }
        },
        {
            "Name": "Опыт",
            "Chance": 1,
            "Bonus": "CRX-Ranks-Exp",
            "Params": {
                "Amount": 20
            }
        }
    ]
*/

public DG_OnBonusesInit(){
    register_plugin(PluginName, PluginVersion, PluginAuthor);

    DG_RegisterBonus("CRX-Shop-Points", "@Bonus_Points", "Amount", ptInteger);
    DG_RegisterBonus("CRX-Ranks-Exp", "@Bonus_Exp", "Amount", ptInteger);
}

@Bonus_Points(const UserId, const Trie:p) {
    cshop_give_points(UserId, DG_ReadParamInt(p, "Amount"));
}

@Bonus_Exp(const UserId, const Trie:p) {
    crxranks_give_user_xp(UserId, DG_ReadParamInt(p, "Amount"));
}
