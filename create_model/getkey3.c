// copyright Barry Rowlingson?
#include <stdio.h>
#include <termios.h>
#include <unistd.h>

void mygetch ( int *ch ) 
{
  struct termios oldt, newt;

  tcgetattr ( STDIN_FILENO, &oldt );
  newt = oldt;
  newt.c_lflag &= ~( ICANON | ECHO );
  tcsetattr ( STDIN_FILENO, TCSANOW, &newt );
  *ch = getchar();
  tcsetattr ( STDIN_FILENO, TCSANOW, &oldt );
  return;
}
