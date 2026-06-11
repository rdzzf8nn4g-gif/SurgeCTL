#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>

@interface SurgePrefsRootListController : PSListController
@end

@implementation SurgePrefsRootListController

- (NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
    }
    return _specifiers;
}

// 视图加载时，在右上角添加保存按钮
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"确认"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(saveSettingsTapped)];
    self.navigationItem.rightBarButtonItem = saveButton;
}

// 用户点击确认按钮后的逻辑
- (void)saveSettingsTapped {
    // 1. 强制收起键盘，触发系统底层将输入的文字立即写入 Plist 文件
    [self.view endEditing:YES];
    
    // 2. 弹窗 UI 反馈
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"保存成功"
                                                                   message:@"配置已保存，您可以直接使用控制中心组件或终端命令了。"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alert addAction:okAction];
    
    // 显示弹窗
    [self presentViewController:alert animated:YES completion:nil];
}

@end
