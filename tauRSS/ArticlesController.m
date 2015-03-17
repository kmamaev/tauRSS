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

- (void)markArticleAsRead:(Article *)article {
#warning resolve TODO mark
    // TODO: Implement this
}

- (void)markArticleAsFavorite:(Article *)article {
#warning resolve TODO mark
    // TODO: Implement this
}

- (NSArray *)allArticles {
    NSMutableArray *articles = [NSMutableArray array];
    NSArray *sources = self.sourcesController.sources;
    for (Source *source in sources) {
        if (source.sourceId != sourceTypeAllNews && source.sourceId != sourceTypeFavorites) {
            [articles addObjectsFromArray:source.articles];
        }
    }
    return articles;
}

- (NSArray *)favoriteArticles {
#warning resolve TODO mark
    // TODO: Implement this
    return nil;
}

@end
