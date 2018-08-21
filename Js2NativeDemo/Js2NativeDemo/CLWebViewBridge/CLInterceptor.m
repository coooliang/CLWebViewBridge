//
//  CLInterceptor.m
//
//  Created by chenliang on 2018/7/17.
//

#import "CLInterceptor.h"
#import "CLPluginContainer.h"
#import "CLAppPlugin_JS.h"

#import <Availability.h>

#import <WebKit/WebKit.h>

#define CALLFUNCTION_PREFIX @"https://callfunction//"
@implementation CLInterceptor{
    CLPluginContainer *_pluginContainer;
    BOOL _isInjection;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _pluginContainer = [[CLPluginContainer alloc]init];
    }
    return self;
}

-(BOOL)isPluginUrl:(NSString *)url webView:(id)webView{
    if ([webView isKindOfClass:[UIWebView class]]) {
        UIWebView *wv = (UIWebView *)webView;
        NSString *injectionJs = [wv stringByEvaluatingJavaScriptFromString:@"typeof(app_plugin_is_injection)"];
        BOOL isUndefined = [@"undefined"isEqualToString:injectionJs];
        if(isUndefined){
            NSLog(@"injection js...");
            [wv stringByEvaluatingJavaScriptFromString:CLWebViewJavascriptBridge_js()];
        }
    }else if(@available(iOS 8.0,*)){
        if ([webView isKindOfClass:[WKWebView class]]) {
            WKWebView *wk = webView;
            [wk evaluateJavaScript:@"typeof(app_plugin_is_injection)" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                if (!error && result) {
                    BOOL isUndefined = [@"undefined"isEqualToString:result];
                    if(isUndefined){
                        NSLog(@"injection js...");
                        [wk evaluateJavaScript:CLWebViewJavascriptBridge_js() completionHandler:nil];
                    }
                }
            }];
        }
    }
    if(url && ![@""isEqualToString:url] && [url hasPrefix:CALLFUNCTION_PREFIX]){
        return YES;
    }
    return NO;
}

-(void)filter:(NSString *)url webView:(id)webView webViewController:(UIViewController *)webViewController{
    
    
    
    NSRange range = [url rangeOfString:CALLFUNCTION_PREFIX];
    NSString *temp = [url substringFromIndex:range.location + range.length];
    NSArray *arr = [temp componentsSeparatedByString:@"&"];
    
    NSString *callBackId = @"";
    NSString *className = @"";
    NSString *methodName = @"";
    
    
    if(arr != nil && arr.count > 3){
        NSString *tt = [arr objectAtIndex:0];
        NSArray *tempArr = [tt componentsSeparatedByString:@"="];
        callBackId = [tempArr objectAtIndex:1];
        
        tt = [arr objectAtIndex:1];
        tempArr = [tt componentsSeparatedByString:@"="];
        className = [tempArr objectAtIndex:1];
        
        tt = [arr objectAtIndex:2];
        tempArr = [tt componentsSeparatedByString:@"="];
        methodName = [tempArr objectAtIndex:1];
        
        tt = [arr objectAtIndex:3];
        tempArr = [tt componentsSeparatedByString:@"="];
        NSString *jsonString = [tempArr objectAtIndex:1];
        jsonString = [jsonString stringByRemovingPercentEncoding];
        jsonString = [self filterArgument:jsonString];
        
        Class cls = NSClassFromString(className);
        id target = [[cls alloc]init];
        
        if([target isKindOfClass:[CLBasePlugin class]]){
            CLBasePlugin *plugin = (CLBasePlugin *)target;
            plugin.callbackId = callBackId;
            plugin.webView = webView;
            plugin.webViewController = webViewController;
            [_pluginContainer add:plugin];
            
            SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@%@",methodName,@":"]);
            [plugin performSelector:selector withObject:jsonString afterDelay:0.0];
        }
    }
}

#pragma mark - private methods
-(NSString *)filterArgument:(NSString *)argument{
    if([argument isEqual:[NSNull null]] || argument == nil || [@"undefined"isEqualToString:argument]){
        return nil;
    }else{
        argument = [argument stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
        return argument;
    }
}
    
@end

