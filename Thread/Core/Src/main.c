#include "main.h"

#include <unistd.h>
#include <pthread.h>
#include <semaphore.h>

/*=======================================================================*/
#define NUM_THREAD  3
#define SIZE_OF_BUFFER  5

/*=======================================================================*/
enum RETURN_VALUE
{
    SUCCESS = 0,
    FAIL_TO_SEMAPHORE_INIT = 1
};

struct __userDATA_t
{
    char *str;
    unsigned char numOfElement;
    unsigned int buffer[SIZE_OF_BUFFER];
    sem_t semHavingData;
};
typedef struct __userDATA_t userData_t;

struct testA
{
    double a;
    char b;
    float c;
};

struct testB
{
    char b;
    double a;
    float c;
};

/*=======================================================================*/
int SystemInit(userData_t *__userData)
{
    __userData->numOfElement = 0;

    int _retValue;
    _retValue = sem_init ( __userData->semHavingData, 1, 0 );
    if( _retValue < SUCCESS )
    {
        PRINT_ERR( "FAIL TO SEMAPHORE INIT\n" );
        return FAIL_TO_SEMAPHORE_INIT;
    }

    return SUCCESS;
}

/*=======================================================================*/
void thread1_function(userData_t *__userData)
{
    
    
}

/*=======================================================================*/
int main()
{
    // pthread_t thread_1, thread_2;
    // userData_t userData;

    printf( " char: %d\n", sizeof(char) );
    printf( " short: %d\n", sizeof(short) );
    printf( " int: %d\n", sizeof(int) );
    printf( " long: %d\n", sizeof(long) );    
    printf( " float: %d\n", sizeof(float) );
    printf( " double: %d\n", sizeof(double) );


    printf(" struct:   %d\n", sizeof(struct testA) );
    printf(" struct:   %d\n", sizeof(struct testB) );


    return SUCCESS;
}