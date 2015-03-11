#import "Source.h"


@implementation Source

- (instancetype)initWithTitle:(NSString *)title {
    self = [self init];
    if (self != nil) {
        _title = title;
    }
    return self;
}

@end
