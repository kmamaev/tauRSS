#import <Foundation/Foundation.h>


@class Source;

@interface Article : NSObject

@property (nonatomic, copy) NSString *articleId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSURL *link;
@property (nonatomic, copy) NSString *articleDescription;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) NSDate *publishDate;
@property (nonatomic, assign) BOOL isRead;
@property (nonatomic, assign) BOOL isFavorite;
@property (nonatomic, weak) Source *source;

- (instancetype)initWithTitle:(NSString *)title
    link:(NSURL *)link
    description:(NSString *)articleDescription
    category:(NSString *)category
    imageURL:(NSURL *)imageURL
    publishDate:(NSDate *)publishDate;

/**
 *  Returns string containing article's publish date (date OR time), category and source
 */
+ (NSString *)buildShortArticleInfo:(Article *)article;

/**
 *  Returns string containing article's publish date (date AND time), category and source
 */
+ (NSString *)buildLongArticleInfo:(Article *)article;

@end
