# debugFile

如果你想将debug信息存储到本地，或许这个仓库可以帮到你；

### introduce

1. SuspendButton

    悬浮按钮，提供了一个itemsData属性，用来配置你点击悬浮按钮后，需要操作的子菜单
    itemsData的格式是：

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

    存储/读取debug信息的类，提供了读取的接口，如果不设置文件存储路径的话，默认是存储在document/debug/debug_net_ios.txt文件中

    ``` objc
    + (instancetype)standardDefault; // 存储在debug_net_ios.txt中
    - (instancetype)init;   // 存储在debug_net_ios.txt中
    - (instancetype)initWithFilePath:(NSString*)filePath;   // 存储在自定义的filepath中
    ```

3. YYDebugFileSingleton

    单例类，用来保存你要存储的debug信息，提供了write_debug_file_enable属性来决定是否要写入到debug文件中；debugInfo用来存储你要保存的信息；

    ``` objc
    @property (assign, nonatomic) BOOL  write_debug_file_enable;
    @property (strong, nonatomic) NSDictionary  *debugInfo;
    ```
4. YYDebugFileBrowseView

    展示指定文件夹目录下所有的子文件，通过tableview的方式展示出来，点击cell后，你可以选择查看或者将debug文件分享出去

    ``` objc
    /**你要展示的文件夹*/
    @property (strong, nonatomic) NSString  *fileDirectory;
    ```
### how to use (simple)

1. 初始化你的debug按钮
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

2. 在你需要存储debug信息的地方，添加方法

    ``` objc
    #ifdef DEBUG
    if ([YYDebugFileSingleton standardDefault].write_debug_file_enable) {
        [[YYFileManager standardDefault] writeDebugString:@"your debug string"];
    }
    #endif
    ```

