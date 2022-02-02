#include <amxmodx>
#include <DeathGift>
#include <army_ranks_ultimate>

/*
    Расширение Death Gift для поддержки Army Ranks Ultimate

    Бонус `ARU-Exp`:
    Описание:
        Выдаёт опыт
    Параметры:
        Exp <Ц.Число> - Количество опыта

    Бонус `ARU-Anew`:
    Описание:
        Выдаёт Anew бонусы
    Параметры:
        Anew <Ц.Число> - Количество бонусов

    Пример:
    [
        {
            "Name": "5 Опыта",
            "Chance": 1,
            "Bonus": "ARU-Exp",
            "Params": {
                "Exp": 5
            }
        },
        {
            "Name": "5 Anew-бонусов",
            "Chance": 1,
            "Bonus": "ARU-Anew",
            "Params": {
                "Anew": 5
            }
        },
        {...}
    ]
*/

new const PLUG_NAME[] = "[DG] ARU Ext.";
new const PLUG_VER[] = "1.0.0";

public DG_OnBonusesInit(){
    register_plugin(PLUG_NAME, PLUG_VER, "ArKaNeMaN");

    DG_RegisterBonus("ARU-Exp", "@Bonus_Exp", "Exp", ptInteger);
    DG_RegisterBonus("ARU-Anew", "@Bonus_Anew", "Anew", ptInteger);
}

@Bonus_Exp(const UserId, const Trie:p){
    new Res = ar_set_user_addxp(UserId, DG_ReadParamInt(p, "Exp", 1));
    if(Res < 0)
        log_amx("[ERROR] Can`t add exp for user #%d.", UserId);
}

@Bonus_Anew(const UserId, const Trie:p){
    new Res = ar_add_user_anew(-1, UserId, DG_ReadParamInt(p, "Anew", 1));
    if(Res < 0)
        log_amx("[ERROR] Can`t add exp for user #%d.", UserId);
}