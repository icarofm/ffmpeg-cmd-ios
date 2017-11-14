//
//  FFmpegCMD.h
//  FFmpegCMD
//
//  Created by IcaroFM on 26/10/17.
//  Copyright © 2017 totmob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFmpegCMD : NSObject
{
    
}

+(bool)cmd:(NSString*)cmd oncomplete:(void(^)(int ret))oncomplete;
+(bool)cmd:(NSString *)cmd onlog:(void(^)(int,NSString*))onlog oncomplete:(void (^)(int))oncomplete;
+(bool)isRunning;
@end
