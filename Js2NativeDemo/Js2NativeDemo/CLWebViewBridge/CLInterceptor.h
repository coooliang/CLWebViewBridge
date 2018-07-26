//
//  CLInterceptor.h
//
//  Created by chenliang on 2018/7/17.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CLInterceptor : NSObject

-(BOOL)isPluginUrl:(NSString *)url;
    
-(void)filter:(NSString *)url webView:(UIWebView *)wv webViewController:(UIViewController *)webViewController;

@end
