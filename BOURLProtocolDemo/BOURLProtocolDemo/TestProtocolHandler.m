//
//  TestProtocolHandler.m
//  ArchUtilDemo
//
//  Created by Boris on 17/3/1.
//  Copyright © 2017年 Boris. All rights reserved.
//

#import "TestProtocolHandler.h"
#import "AppDelegate.h"

@implementation TestProtocolHandler

- (void)handleURLProtocolRequest:(NSURLRequest *)request block:(BOURLProtocolBLock)block
{
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        BOURLProtocolResponse *response = [[BOURLProtocolResponse alloc]init];
        response.data = @{@"result":@"cancel"};
        response.code = 200;
        response.errorMessage = @"";
        block(response);
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        BOURLProtocolResponse *response = [[BOURLProtocolResponse alloc]init];
        response.data = @{@"result":@"ok"};
        response.code = 200;
        response.errorMessage = @"";
        block(response);
    }];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"BOURLProtocolDemo" message:@"BOURLProtocolDemo" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    
    UIViewController *vc = [[[[UIApplication sharedApplication ] delegate] window]rootViewController];
    
    [vc presentViewController:alert animated:YES completion:nil];
}

@end
