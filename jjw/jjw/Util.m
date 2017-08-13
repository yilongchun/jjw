//
//  Util.m
//  jjw
//
//  Created by ylc on 2017/8/10.
//  Copyright © 2017年 Stephen Chin. All rights reserved.
//

#import "Util.h"

@implementation Util

+(NSString *)generateRandomString{
    NSString *string = [[NSString alloc]init];
    for (int i = 0; i < 10; i++) {
        int number = arc4random() % 36;
        if (number < 10) {
            int figure = arc4random() % 10;
            NSString *tempString = [NSString stringWithFormat:@"%d", figure];
            string = [string stringByAppendingString:tempString];
        }else {
            int figure = (arc4random() % 26) + 97;
            char character = figure;
            NSString *tempString = [NSString stringWithFormat:@"%c", character];
            string = [string stringByAppendingString:tempString];
        }
    }
    NSLog(@"%@", string);
    return string;
}


@end
