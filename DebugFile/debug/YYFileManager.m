//
//  YYFileManager.m
//  testdebug
//
//  Created by langwang on 22/4/2020.
//  Copyright © 2020 qufan. All rights reserved.
//

#import "YYFileManager.h"
#import "YYDebugFile.h"

static NSString * dirName = @"debug";
static const NSString * debugFileName = @"debug_net_ios.txt";

static YYFileManager *fileManager;

/**
YYFileManager will help you write you debug string to your local file.
By default this class creates the file 'debug_net_ios.txt' in the 'document/debug' directory.
Of course, you can also specify the file storage address by calling the method '-initWithFilePath',
*/
@interface YYFileManager()
@property (strong, nonatomic) dispatch_queue_t  queue;
@property (strong, nonatomic) NSString  *filePath;
@end

@implementation YYFileManager

+ (instancetype)standardDefault{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        fileManager = [[YYFileManager alloc] init];
    });
    return fileManager;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        NSString * filePath = [PATH_OF_DOCUMENT stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@", dirName, debugFileName]];
        self.filePath = filePath;
        [self createFileWithFilePath:filePath];
    }
    return self;
}

- (instancetype)initWithFilePath:(NSString *)filePath{
    self = [super init];
    if (self) {
        self.filePath = filePath;
        [self createFileWithFilePath:filePath];
    }
    return self;
}

- (void)createFileWithFilePath:(NSString*)filePath{
    
    if (![filePath containsString:PATH_OF_DOCUMENT]) {
        NSAssert(0, @"filePath need to be create at document path");
    }
    
    // create debug directory
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *subPaths = [fileManager subpathsAtPath:PATH_OF_DOCUMENT];
    BOOL containDir = NO;
    for (NSString *path in subPaths) {
        if ([path isEqualToString:dirName]) {
            containDir = YES;
        }
    }
    if (!containDir) {
        [fileManager createDirectoryAtPath:[PATH_OF_DOCUMENT stringByAppendingPathComponent:dirName] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *dirPath = [filePath stringByDeletingLastPathComponent];
    [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    if (![fileManager fileExistsAtPath:filePath]){
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
        NSString *dateString = [[formatter stringFromDate:date] stringByAppendingString:@"/n"];
        [fileManager createFileAtPath:filePath contents:[dateString dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    }
}

- (void)writeDebugString:(NSString*)content{
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:self.filePath];
    [handle seekToEndOfFile];
    NSError *error;
    if (@available(iOS 13.0, *)) {
        [handle writeData:data error:&error];
    } else {
        [handle writeData:data];
    }
    [handle closeFile];
    debugLog(error);
}

- (NSString *)readDebugString{
    NSString *result;
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:self.filePath];
    NSError *error;
    if (@available(iOS 13.0, *)) {
        NSData *data = [handle readDataToEndOfFileAndReturnError:&error];
        [handle closeFile];
        debugLog(error);
        if (!error){
            result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
    } else {
        NSData *data = [handle readDataToEndOfFile];
        [handle closeFile];
        result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return result;
}

- (void)clearDebugString{
    clearFileContent(self.filePath);
}

+ (void)clearFileContentWithFilePath:(NSString *)filePath{
    clearFileContent(filePath);
}

static void clearFileContent(NSString * filePath){
    NSString *tempStr = @"";
    [tempStr writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];

    /*
    NSData *data = [@"" dataUsingEncoding:NSUTF8StringEncoding];
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    NSError *error;
    if (@available(iOS 13.0, *)) {
        [handle seekToOffset:0 error:&error];
        [handle writeData:data error:&error];
    } else {
        [handle seekToFileOffset:0];
        [handle writeData:data];
    }
    [handle closeFile];
    debugLog(error);
     */
}

@end
