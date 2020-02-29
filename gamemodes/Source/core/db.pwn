#include <a_mysql>
#include <YSI_Coding\y_hooks>
#include <env>

new
  MySQL: gDatabase;

hook OnGameModeInit() {
  new 
    hostname[30], 
    username[30], 
    password[30], 
    database[30];
  
  Env_Get("MYSQL_HOST",     hostname);
  Env_Get("MYSQL_USER",     username);
  Env_Get("MYSQL_PASSWORD", password);
  Env_Get("MYSQL_DATABASE", database);

  gDatabase = mysql_connect(hostname, username, password, database);

  if(gDatabase == MYSQL_INVALID_HANDLE || mysql_errno(gDatabase) != 0) {
    Debug_PrintE("MySQL Connection failed, shutting the server down!");
    SendRconCommand("exit");
    return 1;
  }

  new servername[50];
  Env_Get("SERVER_NAME", servername);

  Format:servername("hostname %s", servername);

  SendRconCommand(servername);
  Debug_PrintI("MySQL Connection was successful.");
  
  return 1;
}