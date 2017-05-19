//
//  BOURLProtocolResponse.h
//  ArchUtilDemo
//
//  Created by Boris on 17/3/1.
//  Copyright © 2017年 Boris. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BOURLProtocolResponse : NSObject

@property (copy, nonatomic) NSString *errorMessage;
@property (strong, nonatomic) NSDictionary *data;
@property (assign, nonatomic) int code;

- (NSString *)jsonString;

@end
