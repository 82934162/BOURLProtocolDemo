//
//  ViewController.m
//  BOURLProtocolDemo
//
//  Created by Boris on 2017/5/18.
//  Copyright © 2017年 Boris. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Send Request" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(20, 100, 200, 44)];
    [self.view addSubview:button];
}

- (void)sendAction
{
    NSString *urlStr = @"http://baidu.com/alert?_mobile_bridge=1";
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 通过URL初始化task,在block内部可以直接对返回的数据进行处理
    NSURLSessionTask *task = [session dataTaskWithURL:url
                                    completionHandler:
                              ^(NSData *data, NSURLResponse *response, NSError *error)
    {
        NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
    }];
    
    [task resume];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
