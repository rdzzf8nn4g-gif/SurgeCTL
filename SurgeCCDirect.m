#import <UIKit/UIKit.h>
#import <ControlCenterUIKit/CCUIToggleModule.h>

#if __has_include(<roothide.h>)
#import <roothide.h>
#else
#define jbroot(path) path
#endif

@interface SurgeCCDirect : CCUIToggleModule
@end

@implementation SurgeCCDirect

// 获取动态配置文件的绝对路径 (兼容 Rootless/Roothide)
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

// 获取具体设置值 (带默认值 fallback)
- (NSString *)getSetting:(NSString *)key fallback:(NSString *)fallback {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:[self getRealPrefsPath]];
    if (prefs && prefs[key] && ![prefs[key] isEqual:@""]) {
        return [NSString stringWithFormat:@"%@", prefs[key]];
    }
    return fallback;
}

// 终极图标绝对居中渲染模块
- (UIImage *)centeredImageWithSymbolName:(NSString *)name {
    UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:26 weight:UIImageSymbolWeightMedium];
    UIImage *sysImage = [UIImage systemImageNamed:name withConfiguration:config];
    if (!sysImage) return nil;
    
    CGSize canvasSize = CGSizeMake(50.0, 50.0);
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:canvasSize];
    UIImage *centeredImage = [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull context) {
        CGSize imgSize = sysImage.size;
        CGRect rect = CGRectMake((canvasSize.width - imgSize.width) / 2.0, (canvasSize.height - imgSize.height) / 2.0, imgSize.width, imgSize.height);
        [sysImage drawInRect:rect];
    }];
    return [centeredImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

// ★ 更新了直连专属图标
- (UIImage *)iconGlyph { return [self centeredImageWithSymbolName:@"arrow.right.and.line.vertical.and.arrow.left"]; }
- (UIColor *)selectedColor { return [UIColor systemGreenColor]; }
- (BOOL)isSelected { return NO; }

// 用户点击控制中心按钮时触发
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    // 动态读取设置面板的端口和密码
    NSString *port = [self getSetting:@"port" fallback:@"1836"];
    NSString *key = [self getSetting:@"key" fallback:@"crctdd"];
    NSString *urlString = [NSString stringWithFormat:@"http://127.0.0.1:%@/v1/outbound", port];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:key forHTTPHeaderField:@"X-Key"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *body = @{@"mode": @"direct"};
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:body options:0 error:nil];
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [super setSelected:NO]; // 请求发送完毕后恢复按钮默认状态
        });
    }];
    [task resume];
}
@end
