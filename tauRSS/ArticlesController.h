#import <Foundation/Foundation.h>
#import "Article.h"


@protocol ArticlesController

@required
- (void)articleControllerDidFinishUpdateArticles;

@end


@class SourcesController;

@interface ArticlesController : NSObject

@property (weak, nonatomic) SourcesController *sourcesController;

- (void)setRead:(BOOL)isRead forArticle:(Article *)article;
- (void)setFavorite:(BOOL)isFavorite forArticle:(Article *)article;
- (NSArray *)allArticles;
- (NSArray *)favoriteArticles;
- (void)updateArticlesForSource:(Source *)source;
- (void)addObserver:(id<ArticlesController>)observer;
- (void)removeObserver:(id<ArticlesController>)observer;

@end
