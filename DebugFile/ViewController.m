//
//  ViewController.m
//  DebugFile
//
//  Created by langwang on 8/5/2020.
//  Copyright © 2020 yy. All rights reserved.
//

#import "ViewController.h"

#ifdef DEBUG
#import "YYFileManager.h"
#import "YYDebugFileSingleton.h"
#import "YYDebugFileBrowseView.h"
#import "SuspendButton.h"
#endif

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initTestBtn];
    
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    #ifdef DEBUG
        [self initDebugView];
    #endif
}

- (void)initTestBtn{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 50, 100, 100)];
    btn.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)test:(UIButton*)btn{
#ifdef DEBUG
    [[YYFileManager standardDefault] writeDebugString:@"this is a debug string"];
    NSLog(@"%@", PATH_OF_DOCUMENT);
#endif
}

#ifdef DEBUG
- (void)initDebugView{
    kWeakSelf;
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    UIView *subView = [window viewWithTag:20001];
    if (subView) {
        return;
    }
    
    SuspendButton *button = [[SuspendButton alloc] initWithFrame:CGRectMake(kYYWinSize.width -110-100, 50, 45, 45)];
    [button setTitle:@"debug" forState:UIControlStateNormal];
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    button.backgroundColor = [UIColor greenColor];
    button.tag = 20001;
    [window addSubview:button];
    
    NSString *btnTitle = @"off";
    if ([YYDebugFileSingleton standardDefault].write_debug_file_enable) {
        btnTitle = @"on";
    }
    button.itemsData = @[
        @{btnTitle:[^(UIButton* btn){
            btn.selected = !btn.selected;
            [btn setTitle:btn.selected ? @"on" : @"off" forState:UIControlStateNormal];
            [YYDebugFileSingleton standardDefault].write_debug_file_enable = btn.selected;
        } copy]},
        @{@"showFile":[^(UIButton* btn){
            [weakSelf showDebugFileView:nil];
        } copy]}
    ];
    
}

- (void)showDebugFileView:(UIButton*)btn{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if ([window viewWithTag:1001]) {
        [[window viewWithTag:1001] removeFromSuperview];
    }
    YYDebugFileBrowseView *browseView = [[YYDebugFileBrowseView alloc] initWithFrame:window.bounds];
    browseView.tag = 1001;
    [window addSubview:browseView];
    NSString *debugDirPath = [PATH_OF_DOCUMENT stringByAppendingPathComponent:@"debug"];
    browseView.fileDirectory = debugDirPath;
}
#endif

@end
