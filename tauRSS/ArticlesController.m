#import "ArticlesController.h"
#import "SourcesController.h"


@implementation ArticlesController

- (void)updateAllArticles {
#warning resolve TODO mark
    // TODO: Implement this
}

- (void)updateArticlesForSourceWithId:(NSString *)sourceId {
#warning resolve TODO mark
    // TODO: Implement this
}

- (void)setRead:(BOOL)isRead forArticle:(Article *)article {
#warning resolve TODO mark
    // TODO: Implement this
}

- (void)setFavorite:(BOOL)isFavorite forArticle:(Article *)article {
#warning resolve TODO mark
    // TODO: Implement this
}

- (NSArray *)allArticles {
    NSMutableArray *articles = [NSMutableArray array];
    NSArray *sources = self.sourcesController.sources;
    for (Source *source in sources) {
        if (source.sourceId != sourceIdAllNews && source.sourceId != sourceIdFavorites) {
            [articles addObjectsFromArray:source.articles];
        }
    }
    return articles;
}

- (NSArray *)favoriteArticles
{
#warning Need to optimize getting of favorites list
    NSArray *allArticles = [self allArticles];
    NSMutableArray *favoriteArticles = [NSMutableArray array];
    for (Article *article in allArticles) {
        if (article.isFavorite) {
            [favoriteArticles addObject:article];
        }
    }
    return favoriteArticles;
}

@end
