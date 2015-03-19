#import <Foundation/Foundation.h>
#import "Article.h"


@class SourcesController;

@interface ArticlesController : NSObject

@property (weak, nonatomic) SourcesController *sourcesController;

- (void)updateAllArticles;
- (void)updateArticlesForSourceWithId:(NSString *)sourceId;
- (void)setRead:(BOOL)isRead forArticle:(Article *)article;
- (void)setFavorite:(BOOL)isFavorite forArticle:(Article *)article;
- (NSArray *)allArticles;
- (NSArray *)favoriteArticles;

@end
