#ifndef __MAIN_H__
#define __MAIN_H__

// #include <iostream>
#include <stdio.h>
#include <stdlib.h>

#include <stdbool.h>
#include <string.h>

#define PRINT_ERR( __STR )      printf( " ***[ ERROR ]   %d.    %s   -->  %s", __LINE__, __func__, __STR )
#define PRINT_INFO( __STR )       printf( " ***[ INFO ]   %d.    %s", __LINE__, __STR )

#endif      /* __MAIN_H__ */