#import <Foundation/Foundation.h>
#import "Article.h"


@class SourcesController;

@interface ArticlesController : NSObject

@property (weak, nonatomic) SourcesController *sourcesController;

- (void)updateAllArticles;
- (void)updateArticlesForSourceWithId:(NSString *)sourceId;
- (void)markArticleAsRead:(Article *)article;
- (void)markArticleAsFavorite:(Article *)article;
- (NSArray *)allArticles;
- (NSArray *)favoriteArticles;

@end
