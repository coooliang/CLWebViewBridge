//
//  CLPluginContainer.m
//  Js2NativeDemo
//
//  Created by chenliang on 2018/7/23.
//  Copyright © 2018年 chenl. All rights reserved.
//

#import "CLPluginContainer.h"
#define CLPluginContainer_Remove @"CLPluginContainer_Remove"
@implementation CLPluginContainer{
    NSMutableDictionary *_container;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _container = [NSMutableDictionary dictionary];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeNotif:) name:CLPluginContainer_Remove object:nil];
    }
    return self;
}
    
-(void)add:(CLBasePlugin *)plugin{
    if(_container){
        NSString *nid = plugin.callbackId;
        if(nid && ![@""isEqualToString:nid]){
            [_container setObject:plugin forKey:nid];
        }
    }
}

-(void)removeNotif:(NSNotification *)notif{
    if(notif){
        id obj = notif.object;
        if(obj && [obj isKindOfClass:[CLBasePlugin class]]){
            [self remove:obj];
        }
    }
}
-(void)remove:(CLBasePlugin *)plugin{
    if(_container && plugin){
        NSString *nid = plugin.callbackId;
        if(nid && ![@""isEqualToString:nid]){
            [_container removeObjectForKey:nid];
        }
    }
}
- (void)dealloc{
    if(_container){
        [_container removeAllObjects];
        _container = nil;
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self name:CLPluginContainer_Remove object:nil];
}
@end
