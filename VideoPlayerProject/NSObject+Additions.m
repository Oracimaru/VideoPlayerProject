//
//  NSObject+Additions.m
//  VideoPlayerProject
//
//  Created by emuch on 2017/1/3.
//  Copyright © 2017年 100TAL. All rights reserved.
//

#import "NSObject+Additions.h"

@implementation NSObject (Additions)

+ (NSString *)formatSecondsToString:(NSInteger)seconds
{
    NSString *hhmmss = nil;
    if (seconds < 0) {
        return @"00:00:00";
    }
    
    int h = (int)round((seconds%86400)/3600);
    int m = (int)round((seconds%3600)/60);
    int s = (int)round(seconds%60);
    
    hhmmss = [NSString stringWithFormat:@"%02d:%02d:%02d", h, m, s];
    
    return hhmmss;
}
@end
