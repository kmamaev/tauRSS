#import <Foundation/Foundation.h>


@interface RSSParser : NSObject

/**
 *  Parses xml from the specified xml parser object and returns array of articles objects
 */
- (NSMutableSet *)parseResponse:(NSXMLParser *)xmlParser;

@end
