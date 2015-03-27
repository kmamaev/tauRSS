#import "NSString+StringHelper.h"


@implementation NSString (StringHelper)

- (BOOL)containsString:(NSString *)substring
{
    NSRange range = [self rangeOfString:substring];
    return range.location != NSNotFound;
}

@end
