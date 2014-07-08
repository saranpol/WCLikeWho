#import "UIView+Circle.h"
#import <QuartzCore/QuartzCore.h>


@implementation UIView (Circle)

- (void)setCircle {
    [self.layer setCornerRadius:self.frame.size.width/2.0];
    [self.layer setMasksToBounds:YES];
    [self.layer setShouldRasterize:YES];
    [self.layer setRasterizationScale:[[UIScreen mainScreen] scale]];
}

@end
