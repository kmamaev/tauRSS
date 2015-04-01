#import <Foundation/Foundation.h>
#import "Article.h"


@interface ArticlesController : NSObject

@property (strong, nonatomic) NSArray *favoriteArticles;

- (void)setRead:(BOOL)isRead forArticle:(Article *)article;
- (void)setFavorite:(BOOL)isFavorite forArticle:(Article *)article;
- (NSArray *)allArticles;
- (void)updateArticlesForSource:(Source *)source
    success:(void (^)(BOOL))success
    failure:(void (^)(NSArray *))failure;
- (NSArray *)unreadArticlesForSource:(Source *)source;
+ (ArticlesController *)sharedInstance;

@end
