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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"确认"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(saveSettingsTapped)];
    self.navigationItem.rightBarButtonItem = saveButton;
}

- (void)saveSettingsTapped {
    [self.view endEditing:YES];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"保存成功"
                                                                   message:@"保存成功。"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showInstructions {
   
    NSString *instructionText = 
    @"【配置 Surge】\n"
    @"1. Surge - 主页底部(更多设置)\n"
    @"2. 远程控制 - HTTP API & Web 面板\n"
    @"3. 端口：4～5位数(可默认)\n"
    @"4. 密码：随便填(最好都是小写)\n\n"
    @"或者编辑模式手动输入：\n"
    @"[General]\n"
    @"http-api = 密码@127.0.0.1:端口\n\n"
    @"↓↓↓\n\n"
    @"【终端命令用法】\n"
    @"surgectl direct   (切换直连)\n"
    @"surgectl rule     (切换规则)\n"
    @"surgectl proxy    (切换全局)\n"
    @"surgectl status   (查看当前模式)";

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"使用说明"
                                                                   message:instructionText
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"我明白了"
                                                       style:UIAlertActionStyleCancel
                                                     handler:nil];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
