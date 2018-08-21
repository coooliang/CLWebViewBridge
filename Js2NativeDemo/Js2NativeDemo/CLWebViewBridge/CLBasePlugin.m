//
//  CLBasePlugin.m
//
//  Created by chenliang on 2018/7/17.
//

#import "CLBasePlugin.h"

#import <WebKit/WebKit.h>

@implementation CLBasePlugin

- (id)init{
    self = [super init];
    if (self) {
        _keyWindow = [UIApplication sharedApplication].keyWindow;
    }
    return self;
}

-(void)eval:(NSString *)js{
    if (_webView) {
        if([_webView isKindOfClass:[UIWebView class]]){
            UIWebView *wv = (UIWebView *)_webView;
            [wv stringByEvaluatingJavaScriptFromString:js];
        }else if(@available(iOS 8.0,*)){
            if ([_webView isKindOfClass:[WKWebView class]]) {
                WKWebView *wk = (WKWebView *)_webView;
                [wk evaluateJavaScript:js completionHandler:nil];
            }
        }
    }
}
/**
 *  执行成功回调函数
 *
 */
-(void)toSuccessCallback{
    [self toSuccessCallbackAsString:nil];
}

/**
 *  执行失败回调函数
 *
 */
-(void)toFailCallback{
    [self toFailCallbackAsString:nil];
}

/**
 *  执行成功回调函数
 *
 *  @param msg        回调消息
 */
-(void)toSuccessCallbackAsString:(NSString *)msg{
    NSString *successKey = [NSString stringWithFormat:@"%@SuccessEvent",_callbackId];
    [self callback:successKey msg:msg];
}

/**
*  执行失败回调函数
*
*  @param msg        回调消息
*/
-(void)toFailCallbackAsString:(NSString *)msg{
    NSString *failKey = [NSString stringWithFormat:@"%@FailEvent",_callbackId];
    [self callback:failKey msg:msg];
}
-(void)callback:(NSString *)key msg:(NSString *)msg{
    NSLog(@"callback...");
    if(_webView){
        NSString *js = @"";
        if(msg){
            js = [NSString stringWithFormat:@"app_plugin_execute_callback('%@','%@')",key,msg];
        }else{
            js = [NSString stringWithFormat:@"app_plugin_execute_callback('%@')",key];
        }
        
        if([_webView isKindOfClass:[UIWebView class]]){
            UIWebView *wv = (UIWebView *)_webView;
            [wv stringByEvaluatingJavaScriptFromString:js];
            [self finish];
        }else if(@available(iOS 8.0,*)){
            if ([_webView isKindOfClass:[WKWebView class]]) {
                WKWebView *wk = (WKWebView *)_webView;
                [wk evaluateJavaScript:js completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                    [self finish];
                }];
            }
        }
    }
}

-(void)finish{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"CLPluginContainer_Remove" object:self];
}

- (void)dealloc{
    NSLog(@"%@ dealloc",[self class]);
    [self finish];
}
@end
