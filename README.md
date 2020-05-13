# debugFile
once you want to write the debug message to local file, maybe this repository can help you

[中文说明](https://github.com/YYXuelangwang/debugFile/blob/master/README_ZH.md)

simple to install
``` podfile
pod 'debugFileStore', '~>0.0.3', :configurations => 'Debug'
```

### introduce

1. SuspendButton

    This is a hover button; The hover button provides an itemsData property, which is used to configure the submenu you need to operate after you click the hover button
    The format of itemsData:
    ``` objc
    button.itemsData = @[
        @{@"on":[^(UIButton* btn){
            // your code
        } copy]},
        @{@"showFile":[^(UIButton* btn){
            // your code 
        } copy]}
    ];
    ```

2. YYFileManager

    This class that stores/reads debug information, which provides the interface to read/write, is stored in the document/debug/debug_net_ios.txt file by default if the file storage path is not set

    ``` objc
    + (instancetype)standardDefault; // stored in debug_net_ios.txt
    - (instancetype)init;   // stored in debug_net_ios.txt
    - (instancetype)initWithFilePath:(NSString*)filePath;   // stored in a custom filepath
    ```

3. YYDebugFileSingleton

    The singleton class, which holds the debug information you want to store, provides the write_debug_file_enable property to determine whether to write to the debug file. DebugInfo is used to store information you want to save;

    ``` objc
    @property (assign, nonatomic) BOOL  write_debug_file_enable;
    @property (strong, nonatomic) NSDictionary  *debugInfo;
    ```

4. YYDebugFileBrowseView

    Show all the subfiles in the specified folder, display them in the way of tableview. After clicking cell, you can choose to view or share the debug file

    ``` objc
    /** The folder you want to show */
    @property (strong, nonatomic) NSString  *fileDirectory;
    ```
### how to use (simple)

1. Initialize your debug button
    ``` objc
    #ifdef DEBUG
    - (void)initDebugView{
        kWeakSelf;
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        UIView *subView = [window viewWithTag:20001];
        if (subView) {
            return;
        }

        SuspendButton *button = [[SuspendButton alloc] initWithFrame:CGRectMake(kYYWinSize.width -110-100, 50, 30, 30)];
        [button setTitle:@"debug" forState:UIControlStateNormal];
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
                [weakSelf showDebugFileView:btn];
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
    ```

2. Where you need to store debug information, add methods

    ``` objc
    #ifdef DEBUG
    if ([YYDebugFileSingleton standardDefault].write_debug_file_enable) {
        [[YYFileManager standardDefault] writeDebugString:@"your debug string"];
    }
    #endif
    ```
