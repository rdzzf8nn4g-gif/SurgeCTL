#import <UIKit/UIKit.h>
#import <ControlCenterUIKit/CCUIToggleModule.h>

@interface SurgeCCRule : CCUIToggleModule
@end

@implementation SurgeCCRule

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
    return [self centeredImageWithSymbolName:@"doc.text.fill"];
}

- (UIColor *)selectedColor {
    return [UIColor systemYellowColor];
}

- (BOOL)isSelected {
    return NO;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1:1836/v1/outbound"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"crctdd" forHTTPHeaderField:@"X-Key"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *body = @{@"mode": @"rule"};
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:body options:0 error:nil];
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [super setSelected:NO];
        });
    }];
    [task resume];
}
@end
