//
//  InfoPlugin.m
//  J2NativeDemo
//
//  Created by chenliang on 2018/5/8.
//  Copyright © 2018年 yypt. All rights reserved.
//

#import "InfoPlugin.h"

@implementation InfoPlugin{
    UIView *_keyboard;
}

-(void)hello:(NSString *)argument{
    NSLog(@"%@",argument);
    if(argument){
        [self toSuccessCallbackAsString:argument];
    }else{
        [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(test) userInfo:nil repeats:NO];
    }
}
-(void)test{
    [self toSuccessCallback];//成功回调
}

-(void)world:(NSString *)argument{
    NSLog(@"argument = %@",argument);
    [self finish];//没有调用成功或者失败回调时，需要调用finish函数
}

#pragma mark - keyboard demo
-(void)keyboard:(NSString *)argument{
    NSLog(@"argument = %@",argument);
    _keyboard = [[UIView alloc]initWithFrame:CGRectMake(0, 300, 300, 300)];
    _keyboard.backgroundColor = [UIColor blueColor];
    [self.webViewController.view addSubview:_keyboard];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(50, 50, 100, 40)];
    [button setTitle:@"button" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [_keyboard addSubview:button];
    
    UIButton *close = [[UIButton alloc]initWithFrame:CGRectMake(50, 110, 100, 40)];
    [close setTitle:@"close" forState:UIControlStateNormal];
    [close addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [_keyboard addSubview:close];
}
-(void)click{
    NSLog(@"click");
    NSString *js = @"document.getElementById('test').value = '666';";
    [self eval:js];
}
-(void)close{
    [_keyboard removeFromSuperview];
    [self finish];//退出键盘
}
@end
