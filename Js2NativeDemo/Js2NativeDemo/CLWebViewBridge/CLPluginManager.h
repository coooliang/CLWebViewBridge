//
//  CLPluginManager.h
//  Js2NativeDemo
//
//  Created by chenliang on 2018/9/25.
//  Copyright © 2018年 chenl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLPluginManager : NSObject

+ (id)sharedInstance;

-(NSString *)injectionJS;

@end

NS_ASSUME_NONNULL_END
