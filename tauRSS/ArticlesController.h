#import <Foundation/Foundation.h>
#import "Article.h"


@class SourcesController;

@interface ArticlesController : NSObject

@property (weak, nonatomic) SourcesController *sourcesController;

- (void)setRead:(BOOL)isRead forArticle:(Article *)article;
- (void)setFavorite:(BOOL)isFavorite forArticle:(Article *)article;
- (NSArray *)allArticles;
- (NSArray *)favoriteArticles;
- (void)updateArticlesForSource:(Source *)source
    success:(void (^)(BOOL))success
    failure:(void (^)(NSArray *))failure;

@end
