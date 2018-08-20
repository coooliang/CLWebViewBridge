//
//  CLBasePlugin.h
//
//  Created by chenliang on 2018/7/17.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CLBasePlugin : NSObject

@property(nonatomic,weak)UIViewController *webViewController;
@property(nonatomic,strong)id webView;
@property(nonatomic,strong)NSString *callbackId;
@property(nonatomic,strong)UIWindow *keyWindow;

-(void)eval:(NSString *)js;

-(void)toSuccessCallback;

-(void)toFailCallback;

-(void)toSuccessCallbackAsString:(NSString *)msg;

-(void)toFailCallbackAsString:(NSString *)msg;

-(void)finish;

@end
