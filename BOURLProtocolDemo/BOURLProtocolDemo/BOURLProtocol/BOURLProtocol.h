//
//  BOURLProtocol.h
//  OSBuyApp
//
//  Created by Boris on 17/2/28.
//  Copyright © 2017年 Gome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BOURLProtocolResponse.h"

typedef void (^BOURLProtocolBLock)(BOURLProtocolResponse *response);

@protocol BOURLProtocolHandleProtocol <NSObject>

/**
 处理完也许，创建一个BOURLProtocolResponse，并调用block

 @param request 请求
 @param block 回调
 */
- (void)handleURLProtocolRequest:(NSURLRequest *)request block:(BOURLProtocolBLock)block;

@end

@interface BOURLProtocol : NSURLProtocol

/**
 注册处理器到协议
 最好在应用启动的时候注册
 
 每一次请求，都会根据path对应的Class来创建一个［新的实例］
 因此建议不要和其他无关逻辑混在一起
 调用实例的BOURLProtocolHandleProtocol方法做后续处理

 @param handlerClass 实现了处理协议的Class
 @param path url中的path，如http://baidu.com/image/test?a=1 中的 /image/test
 */
+ (void)registerHandler:(Class<BOURLProtocolHandleProtocol>)handlerClass
                   path:(NSString *)path;

/**
 解除path的处理器

 @param path path
 */
+ (void)unregisterHandlerWithPath:(NSString *)path;

@end
