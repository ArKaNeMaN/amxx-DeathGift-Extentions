#include <amxmodx>
#include <reapi>
#include <healthnade>
#include <DeathGift>

/*
    Бонус `HealthNade`
    Описание:
        Выдаёт лечащую гранату с указанными параметрами
    Параметры:
        - ThrowHealingAmount <Д. Число>: Кол-во ХП, восстанавливаемое от взрыва гранаты.
        - DrinkHealingAmount <Д. Число>: Кол-во ХП, восстанавливаемое от выпивания гранаты.
        - ExplodeRadius <Д. Число>: Радиус взрыва гранаты.
    Примечания:
        - Все параметры необязательны. По-умолчанию берутся значения из кваров HealthNade.

    Пример:
    {
        "Name": "Улучшенная хилка",
        "Chance": 1,
        "Bonus": "HealthNade",
        "Params": {
            "ThrowHealingAmount": 40.0,
            "DrinkHealingAmount": 50.0
        }
    }
*/

new const PLUG_NAME[] = "[DG] HealthNade Ext.";
new const PLUG_VER[] = "1.0.0";

public DG_OnBonusesInit(){
    register_plugin(PLUG_NAME, PLUG_VER, "ArKaNeMaN");

    DG_RegisterBonus("HealthNade", "@Bonus_HealthNade",
        "ThrowHealingAmount", ptFloat,
        "DrinkHealingAmount", ptFloat,
        "ExplodeRadius", ptFloat
    );
}

@Bonus_Weapon(const UserId, const Trie:tParams){
    new iNadeItem = HealthNade_GiveNade(UserId);
    if (iNadeItem == HN_NULLENT) {
        log_amx("Can`t give health nade.");
        return;
    }

    new Float:fParam = -1.0;

    fParam = DG_ReadParamFloat(tParams, "ThrowHealingAmount", -1.0);
    if (fParam >= 0.0) {
        set_entvar(iNadeItem, var_HealthNade_ThrowHealingAmount, fParam);
    }

    fParam = DG_ReadParamFloat(tParams, "DrinkHealingAmount", -1.0);
    if (fParam >= 0.0) {
        set_entvar(iNadeItem, var_HealthNade_DrinkHealingAmount, fParam);
    }

    fParam = DG_ReadParamFloat(tParams, "ExplodeRadius", -1.0);
    if (fParam >= 0.0) {
        set_entvar(iNadeItem, var_HealthNade_Radius, fParam);
    }
}
