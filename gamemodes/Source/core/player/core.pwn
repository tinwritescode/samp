#include <YSI_Coding\y_hooks>

enum E_PLAYER_INFO
{
  E_SQLID,
  E_NAME[MAX_PLAYER_NAME],
  E_PASSWORD, // with hashed password
  E_POS_X,
  E_POS_Y,
  E_POS_Z
}

new gPlayerInfo[MAX_PLAYERS][E_PLAYER_INFO];