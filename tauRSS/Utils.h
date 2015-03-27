#import <Foundation/Foundation.h>
#import "Article.h"


@interface Utils : NSObject

/**
 *  Shows informational alert view with the specified title and description and only "Close" button
 */
+ (void)showInfoAlertWithTitle:(NSString *)title
    description:(NSString *)description
    delegate:(id)delegate;

/**
 *  Returns string containing article's publish date (date OR time), category and source
 */
+ (NSString *)buildShortArticleInfo:(Article *)article;

/**
 *  Returns string containing article's publish date (date AND time), category and source
 */
+ (NSString *)buildLongArticleInfo:(Article *)article;

@end
