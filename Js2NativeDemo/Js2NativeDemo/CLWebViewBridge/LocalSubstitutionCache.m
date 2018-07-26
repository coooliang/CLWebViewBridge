
#import "LocalSubstitutionCache.h"
#import "CLAppPlugin_JS.h"

#define app_plugin_js @"app-plugin.js"
@implementation LocalSubstitutionCache

#pragma mark - override NSURLCache
- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request{
    NSURL *requestUrl = [request URL];
    NSString *pathString = [requestUrl absoluteString];//full path
    NSLog(@"pathString = %@",pathString);
    if([pathString containsString:app_plugin_js]){
        NSString *js = CLWebViewJavascriptBridge_js();
        NSData *data = [js dataUsingEncoding:NSUTF8StringEncoding];
        if(data != nil){
            NSURLResponse *response = [[NSURLResponse alloc] initWithURL:[request URL]
                                                                MIMEType:@"application/javascript"
                                                   expectedContentLength:[data length]
                                                        textEncodingName:nil];
            NSCachedURLResponse *cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:data];
            return cachedResponse;
        }
    }
    return [super cachedResponseForRequest:request];
}
    
@end
