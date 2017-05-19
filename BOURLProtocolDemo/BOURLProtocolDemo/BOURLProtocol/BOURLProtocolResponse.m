//
//  BOURLProtocolResponse.m
//  ArchUtilDemo
//
//  Created by Boris on 17/3/1.
//  Copyright © 2017年 Boris. All rights reserved.
//

#import "BOURLProtocolResponse.h"
#import "BOJsonTools.h"

@implementation BOURLProtocolResponse

- (NSString *)jsonString
{
    NSMutableDictionary *temp = [NSMutableDictionary dictionary];
    
    if(!self.errorMessage)
    {
        self.errorMessage = @"";
    }
    
    if(self.data)
        [temp setObject:self.data forKey:@"data"];
    
    
    [temp setObject:@(self.code) forKey:@"code"];
    [temp setObject:self.errorMessage forKey:@"message"];
    
    return [BOJsonTools dataToJsonString:temp];
}

@end
