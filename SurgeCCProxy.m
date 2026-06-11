#import <UIKit/UIKit.h>
#import <ControlCenterUIKit/CCUIToggleModule.h>
#import <CoreFoundation/CoreFoundation.h>

#if __has_include(<roothide.h>)
#import <roothide.h>
#else
#define jbroot(path) path
#endif

@interface SurgeCCProxy : CCUIToggleModule {
    @public BOOL _isActuallySelected;
    NSTimeInterval _lastFetchTime;
}
@end

static void ProxyTurnOffCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    SurgeCCProxy *module = (__bridge SurgeCCProxy *)observer;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (module->_isActuallySelected) {
            module->_isActuallySelected = NO;
            [module refreshState];
        }
    });
}

@implementation SurgeCCProxy

- (instancetype)init {
    self = [super init];
    if (self) {
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), (__bridge const void *)(self), ProxyTurnOffCallback, CFSTR("com.crctdd.surgectl.selectDirect"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), (__bridge const void *)(self), ProxyTurnOffCallback, CFSTR("com.crctdd.surgectl.selectRule"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    }
    return self;
}

- (NSString *)getRealPrefsPath {
    NSString *basePath = @"/var/mobile/Library/Preferences/com.crctdd.surgectl.plist";
#if __has_include(<roothide.h>)
    return jbroot(basePath);
#else
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/var/jb/"]) { return [@"/var/jb" stringByAppendingPathComponent:basePath]; }
    return basePath;
#endif
}

- (NSString *)getSetting:(NSString *)key fallback:(NSString *)fallback {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:[self getRealPrefsPath]];
    if (prefs && prefs[key] && ![prefs[key] isEqual:@""]) { return [NSString stringWithFormat:@"%@", prefs[key]]; }
    return fallback;
}

- (UIImage *)centeredImageWithSymbolName:(NSString *)name {
    UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:26 weight:UIImageSymbolWeightMedium];
    UIImage *sysImage = [UIImage systemImageNamed:name withConfiguration:config];
    if (!sysImage) return nil;
    CGSize canvasSize = CGSizeMake(50.0, 50.0);
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:canvasSize];
    return [[renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull context) {
        CGSize imgSize = sysImage.size;
        [sysImage drawInRect:CGRectMake((canvasSize.width - imgSize.width)/2.0, (canvasSize.height - imgSize.height)/2.0, imgSize.width, imgSize.height)];
    }] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

- (UIImage *)iconGlyph { return [self centeredImageWithSymbolName:@"arrow.triangle.capsulepath"]; }
- (UIColor *)selectedColor { return [UIColor systemRedColor]; }

- (BOOL)isSelected {
    [self fetchCurrentStateAsynchronously];
    return _isActuallySelected;
}

- (void)fetchCurrentStateAsynchronously {
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    if (now - _lastFetchTime < 1.0) return;
    _lastFetchTime = now;
    
    NSString *port = [self getSetting:@"port" fallback:@"1836"];
    NSString *key = [self getSetting:@"key" fallback:@"crctdd"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://127.0.0.1:%@/v1/outbound", port]];
    if (!url) return;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:1.5];
    [request setValue:key forHTTPHeaderField:@"X-Key"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!data) return;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if (![json isKindOfClass:[NSDictionary class]] || !json[@"mode"]) return;
        BOOL newState = [[[NSString stringWithFormat:@"%@", json[@"mode"]] lowercaseString] isEqualToString:@"proxy"];
        if (self->_isActuallySelected != newState) {
            self->_isActuallySelected = newState;
            dispatch_async(dispatch_get_main_queue(), ^{ [self refreshState]; });
        }
    }] resume];
}

- (void)setSelected:(BOOL)selected {
    _isActuallySelected = YES;
    [self refreshState];
    
    _lastFetchTime = [[NSDate date] timeIntervalSince1970] + 2.0;
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.crctdd.surgectl.selectProxy"), NULL, NULL, YES);
    
    NSString *port = [self getSetting:@"port" fallback:@"1836"];
    NSString *key = [self getSetting:@"key" fallback:@"crctdd"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://127.0.0.1:%@/v1/outbound", port]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:2.0];
    request.HTTPMethod = @"POST";
    [request setValue:key forHTTPHeaderField:@"X-Key"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:@{@"mode": @"proxy"} options:0 error:nil];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self->_lastFetchTime = 0;
            [self fetchCurrentStateAsynchronously];
        });
    }] resume];
}
@end
