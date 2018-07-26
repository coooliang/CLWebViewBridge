//
//  ViewController.m
//  Js2NativeDemo
//
//  Created by chenliang on 2018/7/17.
//  Copyright © 2018年 chenl. All rights reserved.
//

#import "ViewController.h"
#import "WebViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


-(IBAction)push{
    WebViewController *wv = [[WebViewController alloc]init];
    [self presentViewController:wv animated:YES completion:nil];
}

@end
