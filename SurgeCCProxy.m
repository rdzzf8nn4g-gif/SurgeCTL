#import <UIKit/UIKit.h>
#import <ControlCenterUIKit/CCUIToggleModule.h>

#if __has_include(<roothide.h>)
#import <roothide.h>
#else
#define jbroot(path) path
#endif

@interface SurgeCCProxy : CCUIToggleModule {
    BOOL _isActuallySelected;
    NSTimeInterval _lastFetchTime;
}
@end

@implementation SurgeCCProxy

- (NSString *)getRealPrefsPath {
    NSString *basePath = @"/var/mobile/Library/Preferences/com.crctdd.surgectl.plist";
#if __has_include(<roothide.h>)
    return jbroot(basePath);
#else
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/var/jb/"]) {
        return [@"/var/jb" stringByAppendingPathComponent:basePath];
    }
    return basePath;
#endif
}

- (NSString *)getSetting:(NSString *)key fallback:(NSString *)fallback {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:[self getRealPrefsPath]];
    if (prefs && prefs[key] && ![prefs[key] isEqual:@""]) {
        return [NSString stringWithFormat:@"%@", prefs[key]];
    }
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
        CGRect rect = CGRectMake((canvasSize.width - imgSize.width) / 2.0, (canvasSize.height - imgSize.height) / 2.0, imgSize.width, imgSize.height);
        [sysImage drawInRect:rect];
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
    if (now - _lastFetchTime < 1.5) return;
    _lastFetchTime = now;
    
    NSString *port = [self getSetting:@"port" fallback:@"1836"];
    NSString *key = [self getSetting:@"key" fallback:@"crctdd"];
    NSString *urlString = [NSString stringWithFormat:@"http://127.0.0.1:%@/v1/outbound", port];
    NSURL *url = [NSURL URLWithString:urlString];
    if (!url) return;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:2.0];
    request.HTTPMethod = @"GET";
    [request setValue:key forHTTPHeaderField:@"X-Key"];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error || !data) return;
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (jsonError || !json || !json[@"mode"]) return;
        
        NSString *currentMode = [[NSString stringWithFormat:@"%@", json[@"mode"]] lowercaseString];
        BOOL newState = [currentMode isEqualToString:@"proxy"]; // 判断当前是否为全局
        
        if (self->_isActuallySelected != newState) {
            self->_isActuallySelected = newState;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self refreshState];
            });
        }
    }];
    [task resume];
}

- (void)setSelected:(BOOL)selected {
    _isActuallySelected = YES;
    [self refreshState];
    
    NSString *port = [self getSetting:@"port" fallback:@"1836"];
    NSString *key = [self getSetting:@"key" fallback:@"crctdd"];
    NSString *urlString = [NSString stringWithFormat:@"http://127.0.0.1:%@/v1/outbound", port];
    NSURL *url = [NSURL URLWithString:urlString];
    if (!url) return;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:3.0];
    request.HTTPMethod = @"POST";
    [request setValue:key forHTTPHeaderField:@"X-Key"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *body = @{@"mode": @"proxy"};
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:body options:0 error:nil];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        self->_lastFetchTime = 0;
        [self fetchCurrentStateAsynchronously];
    }];
    [task resume];
}
@end
