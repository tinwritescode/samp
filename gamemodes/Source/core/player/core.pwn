#include <YSI_Coding\y_hooks>

enum _:E_CHARACTER_INFO {
  c_SQLID,
  c_Name[MAX_PLAYER_NAME],
  c_Account_SQLID,
  c_Account_ID,
  c_Pos_X,
  c_Pos_Y,
  c_Pos_Z
}
enum _:E_ACCOUNT_INFO {
  a_SQLID,
  a_Name[MAX_PLAYER_NAME],
  a_Password[50],
  a_Slot1,
  a_Slot2,
  a_Slot3,
  a_Slot4,
  a_LoginAttemp
}

new 
  gAccount[MAX_PLAYERS + 1][E_ACCOUNT_INFO],
  gCharacter[MAX_PLAYERS + 1][E_CHARACTER_INFO];

#define Player_GetName(%0) gAccount[%0][a_Name]

hook OnGameModeInit() {
  gAccount[MAX_PLAYERS][a_SQLID] = -1;
  gAccount[MAX_PLAYERS][a_Name][0] = '\0';
  gAccount[MAX_PLAYERS][a_Password][0] = '\0';
  gAccount[MAX_PLAYERS][a_Slot1] = -1;
  gAccount[MAX_PLAYERS][a_Slot2] = -1;
  gAccount[MAX_PLAYERS][a_Slot3] = -1;
  gAccount[MAX_PLAYERS][a_Slot4] = -1;
  gAccount[MAX_PLAYERS][a_LoginAttemp] = 3;

  for(new i = 0; i < MAX_PLAYERS; i++) {
    memcpy(gAccount[i], gAccount[MAX_PLAYERS], 0, sizeof(gAccount[]) * 4, sizeof(gAccount[]));
  }
  return 1;
}

hook OnPlayerConnect(playerid) {
	GetPlayerName(playerid, gAccount[playerid][a_Name], MAX_PLAYER_NAME);
	new query[200];
	mysql_format(gDatabase, query, sizeof(query), 
    "SELECT `name`, `password` FROM `account` WHERE `name` = '%e'", Player_GetName(playerid));

	mysql_tquery(gDatabase, query, "Login", "d", playerid);
	return 1;
}
hook OnPlayerDisconnect(playerid) {
  new query[200];
  mysql_format(gDatabase, query, sizeof(query), 
    "UPDATE `character` SET `pos_x` = '%i', `pos_y` = '%i', `pos_z` = '%i' \
    WHERE `id` = '%i'", 
    gCharacter[playerid][c_Pos_X], 
    gCharacter[playerid][c_Pos_Y], 
    gCharacter[playerid][c_Pos_Z], 
    gCharacter[playerid][c_SQLID]);  
  
  mysql_pquery(gDatabase, query);
  
  memcpy(gAccount[playerid], gAccount[MAX_PLAYERS], 0, sizeof(gAccount[]) * 4, sizeof(gAccount[]));
  return 1;
}
Callback:Login(playerid) {
  new isRegistered = cache_num_rows();
  new infoString[200];

  cache_get_value_name(0, "password", gAccount[playerid][a_Password]);

  if(isRegistered) {
    Format:infoString("Chao %s, tai khoan cua ban da duoc dang ky. Hay nhap mat khau de dang nhap:", Player_GetName(playerid));
    Dialog_Show(playerid, "AUTH_LOGIN", DIALOG_STYLE_PASSWORD, "Dang nhap", infoString, "Dang nhap", "Thoat");
  }
  else {
    Format:infoString("Chao %s, tai khoan nay chua duoc dang ky, hay nhap mat khau de dang ky:", Player_GetName(playerid));
    Dialog_Show(playerid, "AUTH_REGISTER", DIALOG_STYLE_PASSWORD, "Dang ky", infoString, "Dang ky", "Thoat");
  }
  return 1;
}
Dialog:AUTH_LOGIN(playerid, response, listitem, inputtext[]) {
  if(response) {
    if(!strcmp(inputtext, gAccount[playerid][a_Password], false)) {
      Debug_PrintI("%s vua dang nhap", gAccount[playerid][a_Name]);

      
      SpawnPlayer(playerid);
    }
    else {
      gAccount[playerid][a_LoginAttemp]--;

      if(gAccount[playerid][a_LoginAttemp] == 0) {
        Kick:(playerid);
        Dialog_Show(playerid, 0, DIALOG_STYLE_MSGBOX, "Thong bao", "Ban da het so lan thu dang nhap.", "Thoat", "");
      }
      else {
        new infoString[300];
        Format:infoString("Chao %s, tai khoan cua ban da duoc dang ky. Hay nhap mat khau de dang nhap:\n\n{"FIREBRICK_1"}Ban con %d lan thu dang nhap lai", Player_GetName(playerid), gAccount[playerid][a_LoginAttemp]);

        Dialog_Show(playerid, "AUTH_LOGIN", DIALOG_STYLE_PASSWORD, "Dang nhap", infoString, "Dang nhap", "Thoat");     
      }
    }
  }
  else {
    Kick:(playerid);
  }
  return 1;
}
Dialog:AUTH_REGISTER(playerid, response, listitem, inputtext[]) {
  if(response) {
    if(strlen(inputtext) < 6) {
      Dialog_Show(playerid, "AUTH_REGISTER", DIALOG_STYLE_PASSWORD, "Dang ky", "Mat khau can co it nhat 6 ki tu", "Dang ky", "Thoat");
    }
    else {
      new
        sqlString[200];

      mysql_format(gDatabase, sqlString, sizeof(sqlString), "INSERT INTO `account` (`name`, `password`) VALUES ('%e', '%e')", Player_GetName(playerid), inputtext);
      mysql_query(gDatabase, sqlString);
    }
  }
  else {
    Kick:(playerid);
  }
  return 1;
}