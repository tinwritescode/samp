#include <a_samp>


#if defined MAX_PLAYERS
  #undef MAX_PLAYERS
  #define MAX_PLAYERS 10
#endif

#define YSI_NO_VERSION_CHECK
#define YSI_YES_HEAP_MALLOC
#define YSI_NO_OPTIMISATION_MESSAGE
/*
  0 = No debugging.
  1 = Show public function calls (callbacks and timers).
  2 = Show API function calls (main YSI functions).
  3 = Show stock function calls (secondary YSI functions).
  4 = Show internal function calls.
  5 = Show function branches (extra debug information within functions).
  6 = Show loop repeats (prints within loops).
  7 = Show extra loops (even more prints in loops).
*/

// #define _DEBUG 0

// #include <crashdetect>			    	// By Zeex:					https://github.com/Zeex/samp-plugin-crashdetect
#include <sscanf2>					      // By Y_Less:				https://github.com/maddinat0r/sscanf
#include <YSI_Visual\y_commands>  // By Y_Less:       https://github.com/pawn-lang/YSI-Includes
// #include <YSI_Data\y_iterate>
#include <YSI_Coding\y_hooks>
// #include <YSI_Coding\y_timers>
// #include <YSI_Coding\y_va>
#include <YSI_Server\y_colours>
// #include <streamer>
#include <a_mysql>
#include <easyDialog>

#define Format:%0(%1,%2) format(%0, sizeof(%0), (%1), %2)
#define Callback:%0(%1) forward %0(%1); public %0(%1)
#define Function:%0(%1) %0(%1)
// 
#define Kick:(%0) SetTimerEx("Kick", 500, false, "d", %0)

#include "Source/core/initFunction.pwn"
#include "Source/core/db.pwn"
#include "Source/core/player/core.pwn"

main() {
}