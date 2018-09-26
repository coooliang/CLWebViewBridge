//
//  CLInterceptor.m
//
//  Created by chenliang on 2018/7/17.
//

#import "CLInterceptor.h"
#import "CLPluginContainer.h"
#import <Availability.h>
#import <WebKit/WebKit.h>
#import "CLPluginManager.h"

#define CALLFUNCTION_PREFIX @"https://callfunction//"
@implementation CLInterceptor{
    CLPluginContainer *_pluginContainer;

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
        NSString *isInjection = [wv stringByEvaluatingJavaScriptFromString:@"typeof(app_plugin_is_injection)"];
        BOOL isUndefined = [@"undefined"isEqualToString:isInjection];
        if(isUndefined){
            NSLog(@"injection js...");
            NSString *injectionJS = [[CLPluginManager sharedInstance]injectionJS];
            [wv stringByEvaluatingJavaScriptFromString:injectionJS];
        }
    }else if ([webView isKindOfClass:[WKWebView class]]) {
        WKWebView *wk = (WKWebView *)webView;
        [wk evaluateJavaScript:@"typeof(app_plugin_is_injection)" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            if (!error && result) {
                BOOL isUndefined = [@"undefined"isEqualToString:result];
                if(isUndefined){
                    NSLog(@"injection js...");
                    NSString *injectionJS = [[CLPluginManager sharedInstance]injectionJS];
                    [wk evaluateJavaScript:injectionJS completionHandler:nil];
                }
            }
        }];
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
    
    if(arr != nil){
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:arr.count];
        for (NSString *param in arr) {
            NSArray *temp = [param componentsSeparatedByString:@"="];
            if (temp && temp.count > 0) {
                [params setObject:temp[1] forKey:temp[0]];
            }
        }
        
        NSString *callBackId = [params objectForKey:@"callbackId"];
        NSString *className = [params objectForKey:@"className"];;
        NSString *methodName = [params objectForKey:@"method"];
        NSString *jsonString = [params objectForKey:@"param"];
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

- (void)dealloc{
    NSLog(@"%@ dealloc",[self class]);
}

@end

