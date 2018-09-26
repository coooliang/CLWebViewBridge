//
//  WKWebViewController.m
//  Js2NativeDemo
//
//  Created by chenliang on 2018/8/20.
//  Copyright © 2018年 chenl. All rights reserved.
//

#import "WKWebViewController.h"
#import "CLInterceptor.h"
#import <Availability.h>

#import <WebKit/WebKit.h>

@interface WKWebViewController ()<WKNavigationDelegate,WKUIDelegate>

@end

@implementation WKWebViewController{
    CLInterceptor *_interceptor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _interceptor = [[CLInterceptor alloc]init];
    
    if(@available(iOS 8.0, *)){
        //Build Phases --> Link Binary With Libraries --> add WebKit.framework
        WKWebView *webView = [[WKWebView alloc]initWithFrame:self.view.bounds];
        webView.navigationDelegate = self;
        webView.UIDelegate = self;
        [self.view addSubview:webView];
        
        
        
        //获取bundlePath 路径
        NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
        //获取本地html目录 basePath
        NSString *basePath = [NSString stringWithFormat: @"%@", bundlePath];
        //获取本地html目录 baseUrl
        NSURL *baseUrl = [NSURL fileURLWithPath: basePath isDirectory: YES];
        NSLog(@"%@", baseUrl);
        //html 路径
        NSString *indexPath = [NSString stringWithFormat: @"%@/index.html", basePath];
        //html 文件中内容
        NSString *indexContent = [NSString stringWithContentsOfFile:indexPath encoding: NSUTF8StringEncoding error:nil];
        //显示内容
        [webView loadHTMLString: indexContent baseURL: baseUrl];
    }
}

#pragma mark - WKNavigationDelegate
// 页面开始加载时调用 2
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
}
// 当内容开始返回时调用 3
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}
// 页面加载完成之后调用 4
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    
}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}
// 在发送请求之前，决定是否跳转 1
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *url = navigationAction.request.URL.absoluteString;
    NSLog(@"url: %@",url);
    
    if([_interceptor isPluginUrl:url webView:webView]){
        [_interceptor filter:url webView:webView webViewController:self];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationActionPolicyCancel);
}

#pragma mark - WKUIDelegate
// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    return [[WKWebView alloc]init];
}
// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    NSLog(@"prompt = %@",prompt);
    completionHandler(@"http");
}
// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    NSLog(@"message = %@",message);
    completionHandler(YES);
}
// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    NSLog(@"message = %@",message);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler();
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)dealloc{
    NSLog(@"%@ dealloc",[self class]);
}

@end
