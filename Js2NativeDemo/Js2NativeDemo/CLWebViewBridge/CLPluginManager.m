//
//  CLPluginManager.m
//  Js2NativeDemo
//
//  Created by chenliang on 2018/9/25.
//  Copyright © 2018年 chenl. All rights reserved.
//

#import "CLPluginManager.h"
#import <objc/runtime.h>
#import "CLBasePlugin.h"

@implementation CLPluginManager

//单例
+ (id)sharedInstance{
    static CLPluginManager *instance;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

/**
 创建注入的JS内容
 @return js
 */
-(NSString *)createJS{
    NSArray *classArray = [self findSubClass:[CLBasePlugin class]];
    NSMutableString *js = [NSMutableString stringWithString:@"if(!window.plugins){window.plugins={};}"];
    if (classArray) {
        for (Class class in classArray) {
            NSString *classString = NSStringFromClass(class);
            NSString *definition = [NSString stringWithFormat:@"function %@(){};",class];
            [js appendString:definition];
            NSArray *methods = [self getAllMethods:class];
            if (methods) {
                for (NSString *methodString in methods) {
                    NSString *m = [NSString stringWithFormat:@"%@.prototype.%@=function(successCallback, failureCallback,jsonString){js2native.exec(successCallback,failureCallback, \"%@\", \"%@\",jsonString);};",classString,methodString,classString,methodString];
                    [js appendString:m];
                }
            }
            
            [js appendString:[NSString stringWithFormat:@"window.plugins.%@=new %@();",[self firstLowercase:classString],classString]];
        }
    }
    return js;
}

#pragma mark -
-(NSArray *)findSubClass:(Class)defaultClass{
    int count = objc_getClassList(NULL,0);
    if (count <= 0) {
        return nil;
    }
    NSMutableArray *output = [NSMutableArray new];
    Class *classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * count);
    objc_getClassList(classes, count);
    for (int i = 0; i < count; i++) {
        if (defaultClass == class_getSuperclass(classes[i])) {
            [output addObject:classes[i]];
        }
    }
    return output;
}

/* 获取对象的所有方法 */
-(NSArray *)getAllMethods:(Class)class{
    unsigned int count = 0;
    Method* methodList = class_copyMethodList(class,&count);
    NSMutableArray *methodsArray = [NSMutableArray array];
    for (unsigned int i = 0; i<count; i++) {
        Method method = methodList[i];
        NSString *methodString = NSStringFromSelector(method_getName(method));
        
        //filter method name
        if(methodString && [methodString hasSuffix:@":"] && [self isEnglishFirst:methodString]){
            [methodsArray addObject:[methodString substringToIndex:methodString.length-1]];
        }
    }
    return methodsArray;
}

-(BOOL)isEnglishFirst:(NSString *)str {
    NSString *regular = @"^[A-Za-z].+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regular];
    
    if ([predicate evaluateWithObject:str] == YES){
        return YES;
    }else{
        return NO;
    }
}

-(NSString *)firstLowercase:(NSString *)word{
    if(word && word.length>1){
        return [NSString stringWithFormat:@"%@%@",[[word lowercaseString]substringToIndex:1],[word substringFromIndex:1]];
    }
    return word;
}

@end
