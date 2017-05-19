//
//  BOURLProtocol.m
//  OSBuyApp
//
//  Created by Boris on 17/2/28.
//  Copyright © 2017年 Gome. All rights reserved.
//

#import "BOURLProtocol.h"
#import "BOJsonTools.h"
#import "BOURLProtocolResponse.h"

#define kBOURLProtocolHandled @"BOURLProtocolHandled"

#define kBOURLProtocol   @"gome"

static NSMutableDictionary *_handlerMap;

@interface BOURLProtocol()
@property(nonatomic,strong) id<BOURLProtocolHandleProtocol> handler;
@end

@implementation BOURLProtocol

+(void)initialize
{
    if(self == BOURLProtocol.class)
    {
        _handlerMap = [NSMutableDictionary dictionary];
    }
}

#pragma mark - Public

+ (void)registerHandler:(Class<BOURLProtocolHandleProtocol>)handlerClass
                   path:(NSString *)path
{
    @synchronized (_handlerMap)
    {
        [_handlerMap setObject:handlerClass forKey:path];
    }
}

+ (void)unregisterHandlerWithPath:(NSString *)path
{
    @synchronized (_handlerMap)
    {
        [_handlerMap removeObjectForKey:path];
    }
}

#pragma mark - NSURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    //如果请求已经被处理了，则不再重复处理
    if ([NSURLProtocol propertyForKey:kBOURLProtocolHandled inRequest:request])
    {
        return NO;
    }
    
    //拦截我们约定好的规则
    if([request.URL.absoluteString containsString:@"_mobile_bridge=1"])
    {
        return YES;
    }
    
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a
                       toRequest:(NSURLRequest *)b
{
    return [super requestIsCacheEquivalent:a toRequest:b];
}

/**
 在该方法里做path的判断和对应的逻辑
 */
- (void)startLoading
{
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    [BOURLProtocol setProperty:@(YES)
                        forKey:kBOURLProtocolHandled
                     inRequest:mutableReqeust];
    
    self.handler = nil;
    @synchronized (_handlerMap)
    {
        for(NSString *key in [_handlerMap allKeys])
        {
            if([mutableReqeust.URL.path isEqualToString:key])
            {
                Class class = [_handlerMap objectForKey:key];
                self.handler = [[class alloc]init];
                break;
            }
        }
    }
    BOURLProtocolResponse *protocolResponse = nil;
    
    if(![self.handler respondsToSelector:@selector(handleURLProtocolRequest:block:)])
    {
        protocolResponse = [[BOURLProtocolResponse alloc]init];
        protocolResponse.code = 400;
        protocolResponse.errorMessage = @"No response";
        [self handleProtocolResponse:protocolResponse];
    }
    else
    {
        [self.handler handleURLProtocolRequest:mutableReqeust
                                     block:^(BOURLProtocolResponse *response)
        {
            [self handleProtocolResponse:response];
        }];
    }
}

- (void)handleProtocolResponse:(BOURLProtocolResponse *)protocolResponse
{
    NSString *str = [protocolResponse jsonString];
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary * headerFields = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",data.length], @"Content-Length", @"text/json",@"Content-Type", nil];
    NSHTTPURLResponse * response = [[NSHTTPURLResponse alloc] initWithURL:self.request.URL statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:headerFields];//statusCode == 200
    
    
    [self.client URLProtocol:self
          didReceiveResponse:response
          cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    
    [self.client URLProtocol:self didLoadData:data];
    [self.client URLProtocolDidFinishLoading:self];
    
    self.handler = 0;
}

- (void)stopLoading
{
    self.handler = 0;
}

@end
