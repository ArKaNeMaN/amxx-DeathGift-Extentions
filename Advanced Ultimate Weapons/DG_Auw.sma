#include <amxmodx>
#include <DeathGift>
#include <auw>

/*
    Бонус `AUW-GiveWeapon`
    Описание:
        Выдаёт указанное оружие
    Параметры:

        [Обязательные]
        - Weapon <Строка>: Название оружия

        [Необязательные]
        - Notif <true/false>: Отображение в чате сообщения о выдача оружия
        - UID <Ц.Число>: UID оружия
        - UidWithOffset <true/false>: Включает ли UID внутренний сдвиг

    Пример:
    {
        "Name": "Золотой Калаш",
        "Chance": 1,
        "Bonus": "AUW-GiveWeapon",
        "Params": {
            "Weapon": "Golden_AK47"
        }
    }
*/

new const PLUG_NAME[] = "[DG] AUW Ext.";
new const PLUG_VER[] = "1.0.0";

public DG_OnBonusesInit(){
    register_plugin(PLUG_NAME, PLUG_VER, "ArKaNeMaN");

    DG_RegisterBonus(
        "AUW-GiveWeapon", "@Bonus_GiveWeapon",
        "Weapon", ptString,
        "Notif", ptBool,
        "UID", ptInteger,
        "UidWithOffset", ptBool
    );
}

@Bonus_GiveWeapon(const UserId, const Trie:p){
    new WeaponName[32];
    DG_ReadParamString(p, "Weapon", WeaponName, charsmax(WeaponName));
    
    __auw__native__auw_give_weapon(UserId, WeaponName,
        DG_ReadParamBool(p, "Notif", true),
        DG_ReadParamInt(p, "UID", -1),
        DG_ReadParamBool(p, "UidWithOffset", true),
        0
    );
}