#import <Foundation/Foundation.h>


@interface NSString (StringHelper)

/**
 *  Searches the specified substring in the string and returns if the substring found or not
 */
- (BOOL)containsString:(NSString *)substring;

@end
