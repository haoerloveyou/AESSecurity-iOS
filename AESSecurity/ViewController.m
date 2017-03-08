//
//  ViewController.m
//  AESSecurity
//
//  Created by luzhiyong on 2017/3/6.
//  Copyright © 2017年 ileafly. All rights reserved.
//

#import "ViewController.h"

#import "NSString+AESSecurity.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)requestAction:(id)sender {
    // 创建一个网络路径
    NSURL *url = [NSURL URLWithString:@"http://localhost:4000/AESSecurity-PHP/index.php"];
    
    // 创建一个网络请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 根据会话对象，创建一个Task任务
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"Response data: %@", dic);
            NSString *info = [dic objectForKey:@"info"];
            NSString *str = [NSString descryptAES:info key:@"zq9GFxgbh9nWFdjO"];
            NSLog(@"Descrpt data: %@", str);

            str = [str stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
            
            NSError *err = nil;
            NSData *jsondata = [str dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableLeaves error:&err];
            NSLog(@"Descrpt data: %@", arr);

        }
    }];
    
    [sessionDataTask resume];
}

- (IBAction)uploadAction:(id)sender {
    // 创建一个网络路径
    NSURL *url = [NSURL URLWithString:@"http://localhost:4000/AESSecurity-PHP/index.php?act=upload"];
    
    // 创建一个网络请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *content = @"我是一段加密的内容";
    
    content = [NSString encrypyAES:content key:@"zq9GFxgbh9nWFdjO"];
    
    NSDictionary *params = @{@"post" : content};
    
    NSData *data= [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];

    [request setHTTPBody:data];
    
    // 获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 根据会话对象，创建一个Task任务
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"Response data: %@", dic);
        }
    }];
    
    [sessionDataTask resume];
}

@end
