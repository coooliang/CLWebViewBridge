//
//  WebViewController.m
//  J2NativeDemo
//
//  Created by chenliang on 2018/7/17.
//  Copyright © 2018年 yypt. All rights reserved.
//

#import "WebViewController.h"
#import "CLInterceptor.h"

@interface WebViewController ()<UIWebViewDelegate>

@end

@implementation WebViewController{
    CLInterceptor *_interceptor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _interceptor = [[CLInterceptor alloc]init];
    
    //test
    UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    webView.delegate = self;
    [self.view addSubview:webView];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:path] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20]];
    
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *url = request.URL.absoluteString;
    NSLog(@"url : %@",url);
    if([_interceptor isPluginUrl:url webView:webView]){
        [_interceptor filter:url webView:webView webViewController:self];
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
}
    
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"error %@",error);
}

#pragma mark - 
- (void)dealloc{
    NSLog(@"%@ dealloc",[self class]);
}

@end
