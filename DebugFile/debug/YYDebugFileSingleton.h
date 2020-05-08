//
//  YYDebugFileSingleton.h
//  Pokio
//
//  Created by langwang on 7/5/2020.
//  Copyright © 2020 深圳趣凡网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Singleton to store debug information
 */
@interface YYDebugFileSingleton : NSObject
@property (assign, nonatomic) BOOL  write_debug_file_enable;
@property (strong, nonatomic) NSDictionary  *debugInfo;
+ (instancetype)standardDefault;
@end

NS_ASSUME_NONNULL_END
