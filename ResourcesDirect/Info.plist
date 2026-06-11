#import <UIKit/UIKit.h>
#import <ControlCenterUIKit/CCUIToggleModule.h>

@interface SurgeCCDirect : CCUIToggleModule
@end

@implementation SurgeCCDirect

// 核心辅助方法：把任意尺寸的 SF Symbol 画死在一个 50x50 的绝对正方形画布正中心
- (UIImage *)centeredImageWithSymbolName:(NSString *)name {
    UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:26 weight:UIImageSymbolWeightMedium];
    UIImage *sysImage = [UIImage systemImageNamed:name withConfiguration:config];
    if (!sysImage) return nil;
    
    CGSize canvasSize = CGSizeMake(50.0, 50.0);
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:canvasSize];
    UIImage *centeredImage = [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull context) {
        CGSize imgSize = sysImage.size;
        CGRect rect = CGRectMake((canvasSize.width - imgSize.width) / 2.0,
                                 (canvasSize.height - imgSize.height) / 2.0,
                                 imgSize.width,
                                 imgSize.height);
        [sysImage drawInRect:rect];
    }];
    return [centeredImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

- (UIImage *)iconGlyph {
    return [self centeredImageWithSymbolName:@"location.fill"]; // 直连图标
}

- (UIColor *)selectedColor {
    return [UIColor systemGreenColor];
}

- (BOOL)isSelected {
    return NO; // 触发器模式，不保持常亮状态
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    // 异步发送请求，防止卡死 SpringBoard
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1:1836/v1/outbound"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"crctdd" forHTTPHeaderField:@"X-Key"];
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
