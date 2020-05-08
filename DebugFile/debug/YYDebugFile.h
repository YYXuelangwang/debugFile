//
//  YYDebugFile.h
//  fmdb
//
//  Created by langwang on 2/5/2020.
//  Copyright © 2020 qufan. All rights reserved.
//

#ifndef YYDebugFile_h
#define YYDebugFile_h

#import <UIKit/UIKit.h>

#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
//#define debugLog(msg) NSLog(@"debug at %s Line:%d; message:%@", __func__, __LINE__, msg)
#define debugLog(msg)
#define kWeakSelf __weak typeof(self) weakSelf = self;

#define kYYWinSize  [UIScreen mainScreen].bounds.size

typedef  void (^yyItemClicked)(UIButton*);
typedef NSDictionary<NSString*, yyItemClicked> YYItemData;

#endif /* YYDebugFile_h */
