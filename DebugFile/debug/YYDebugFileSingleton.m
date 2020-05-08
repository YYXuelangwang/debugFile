//
//  YYDebugFileSingleton.m
//  Pokio
//
//  Created by langwang on 7/5/2020.
//  Copyright © 2020 深圳趣凡网络科技有限公司. All rights reserved.
//

#import "YYDebugFileSingleton.h"


static YYDebugFileSingleton *debugFileSingleton;

/**
Singleton to store debug information
*/
@interface YYDebugFileSingleton()
{
    BOOL _write_debug_file_enable;
}

@end

@implementation YYDebugFileSingleton

@synthesize write_debug_file_enable = _write_debug_file_enable;

+ (instancetype)standardDefault{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        debugFileSingleton = [[YYDebugFileSingleton alloc] init];
        BOOL enable = [[NSUserDefaults standardUserDefaults] boolForKey:@"write_debug_file_enable"];
        debugFileSingleton->_write_debug_file_enable = enable;
    });
    return debugFileSingleton;
}

- (void)setWrite_debug_file_enable:(BOOL)write_debug_file_enable{
    if (_write_debug_file_enable != write_debug_file_enable) {
        [[NSUserDefaults standardUserDefaults] setBool:write_debug_file_enable forKey:@"write_debug_file_enable"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    _write_debug_file_enable = write_debug_file_enable;
}

@end
