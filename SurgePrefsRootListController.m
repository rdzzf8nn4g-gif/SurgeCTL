#import <Preferences/PSListController.h>

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
                                                                   message:@"保存成功"
                                                            preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alert addAction:okAction];

    [self presentViewController:alert animated:YES completion:nil];
}

@end
