#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>

@interface SurgePrefsRootListController : PSListController
@end

@implementation SurgePrefsRootListController

- (NSArray *)specifiers {
    if (!_specifiers) {
        NSMutableArray *specs = [[self loadSpecifiersFromPlistName:@"Root" target:self] mutableCopy];
        
        
        if (specs.count > 0) {
            PSSpecifier *groupSpec = specs[0];
            NSString *footerText = @"使用说明：\nSurge - 主页底部(更多设置) - 远程控制 - HTTP API & Web 面板\n打开HTTP API\n端口：4～5位数(可默认)\n密码：随便填(最好都是小写字母)\n\n或者编辑模式手动输入：\n[General]\nhttp-api = 密码@127.0.0.1:端口\n\n设置好了后，在上方填入。\n\n↓↓↓\n\n终端命令用法(仅输入英文)：\nsurgectl direct   切换直连模式\nsurgectl rule     切换规则模式\nsurgectl proxy    切换全局代理\nsurgectl status   查看当前模式";
            
            [groupSpec setProperty:footerText forKey:@"footerText"];
        }
        _specifiers = specs;
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

@end
