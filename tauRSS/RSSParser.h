#import <Foundation/Foundation.h>
#import "Source.h"

/**
 *  The object might be used only one time. Create another one object for parsing each response.
 */
@interface RSSParser : NSObject

/**
 *  Parses xml from the specified xml parser object and returns array of articles objects
 */
- (NSMutableSet *)parseResponse:(NSXMLParser *)xmlParser forSource:(Source *)source;

@end
