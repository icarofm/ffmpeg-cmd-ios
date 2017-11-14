//
//  FFmpegCMD.m
//  FFmpegCMD
//
//  Created by IcaroFM on 26/10/17.
//  Copyright © 2017 totmob. All rights reserved.
//

#import "FFmpegCMD.h"
#import "ffmpeg.h"

@implementation FFmpegCMD
bool __FFmpegCMD_isRunning=false;


void mlog(void*a,int level,const char* arg, va_list va){
    char buf[1024];
    vsnprintf(buf, sizeof(buf), arg, va);
    if( logBlock != nil ){
        logBlock(level,[NSString stringWithUTF8String:buf]);
    }
}

void (^logBlock)(int level, NSString*log)=nil;

+(bool)cmd:(NSString *)cmd oncomplete:(void (^)(int))oncomplete{
    return [FFmpegCMD cmd:cmd onlog:nil oncomplete:oncomplete];
}

+(bool)cmd:(NSString *)cmd onlog:(void(^)(int,NSString*))onlog oncomplete:(void (^)(int))oncomplete
{
    if(__FFmpegCMD_isRunning) return false;
    __FFmpegCMD_isRunning=true;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray * arr = (NSMutableArray*)[cmd componentsSeparatedByString:@" "];
        
        int ret=0, argc;
        char **argv=[FFmpegCMD allocArgv:arr argc:&argc];
        @try{
            @autoreleasepool {
                logBlock = onlog;
                ret = ffmpeg(argc, argv, mlog);
            }
        }@catch(NSException *e){
            ret = -1;
        }
        [FFmpegCMD freeArgv:argv];
        __FFmpegCMD_isRunning=false;
        if( oncomplete != nil )
            oncomplete(ret);
    });
    return true;
}

+(char**)allocArgv:(NSMutableArray*)arr argc:(int *)argc
{
    [arr insertObject:@"ffmpeg" atIndex:0];
    unsigned int count = (unsigned int)[arr count];
    *argc=count;
    char **array = (char **)malloc((count + 1) * sizeof(char*));
    for (unsigned i = 0; i < count; i++)
        array[i] = strdup([[arr objectAtIndex:i] UTF8String]);
    array[count] = NULL;
    return array;
}

+(void)freeArgv:(char**)argv
{
    if (argv != NULL) {
        for (unsigned index = 0; argv[index] != NULL; index++)
            free(argv[index]);
        free(argv);
    }
}

+(bool)isRunning
{
    return __FFmpegCMD_isRunning;
}

@end
