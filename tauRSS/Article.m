#import "Article.h"


@implementation Article

- (instancetype)initWithTitle:(NSString *)title {
    self = [self init];
    if (self != nil) {
        _title = title;
    }
    return self;
}

@end
