//
//  ViewController.m
//  Js2NativeDemo
//
//  Created by chenliang on 2018/7/17.
//  Copyright © 2018年 chenl. All rights reserved.
//

#import "ViewController.h"
#import "WebViewController.h"
#import "WKWebViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 150, 40)];
    [button1 setTitle:@"pushWeb" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(pushWeb) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(100, 300, 150, 40)];
    [button2 setTitle:@"pushWK" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(pushWK) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
}


-(void)pushWeb{
    WebViewController *wv = [[WebViewController alloc]init];
    [self.navigationController pushViewController:wv animated:YES];
}

-(void)pushWK{
    WKWebViewController *wv = [[WKWebViewController alloc]init];
    [self.navigationController pushViewController:wv animated:YES];
}
@end
