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

@end
