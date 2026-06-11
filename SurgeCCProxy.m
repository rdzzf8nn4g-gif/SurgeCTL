#import <UIKit/UIKit.h>
#import <ControlCenterUIKit/CCUIToggleModule.h>

@interface SurgeCCProxy : CCUIToggleModule
@end

@implementation SurgeCCProxy

- (UIImage *)iconGlyph {
    return [UIImage systemImageNamed:@"globe"];
}

- (UIColor *)selectedColor {
    return [UIColor systemRedColor];
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
    NSDictionary *body = @{@"mode": @"proxy"};
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:body options:0 error:nil];
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [super setSelected:NO];
        });
    }];
    [task resume];
}
@end
