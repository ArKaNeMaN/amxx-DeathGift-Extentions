#include <amxmodx>
#include <cwapi>
#include <DeathGift>

/*
    Бонус `CWAPI-Weapon`
    Описание:
        Выдаёт указанное кастомное оружие из Custom Weapons API
    Параметры:
        - Weapon <Строка>: Название оружия. Соответствует названию файла оружия без расширения.

    Пример:
    {
        "Name": "Калаш випа",
        "Chance": 1,
        "Bonus": "CWAPI-Weapon",
        "Params": {
            "Weapon": "Vip_AK47"
        }
    }
*/

new const PLUG_NAME[] = "[DG] CWAPI Ext.";
new const PLUG_VER[] = "1.0.0";

public DG_OnBonusesInit(){
    register_plugin(PLUG_NAME, PLUG_VER, "ArKaNeMaN");

    DG_RegisterBonus("CWAPI-Weapon", "@Bonus_Weapon", "Weapon", ptString);
}

@Bonus_Weapon(const UserId, const Trie:p){
    new WeaponName[32];
    DG_ReadParamString(p, "Weapon", WeaponName, charsmax(WeaponName));

    CWAPI_GiveWeapon(UserId, WeaponName);
}