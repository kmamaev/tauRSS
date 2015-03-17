#import "Source.h"


@implementation Source

- (NSArray *)articles {
    if (self.sourceId == sourceTypeAllNews) {
        return [self.articlesController allArticles];
    }
    else if (self.sourceId == sourceTypeFavorites) {
        return [self.articlesController favoriteArticles];
    }
    else return _articles;
}

+ (instancetype)allNewsSourceWithArticlesController:(ArticlesController *)articlesController  {
    Source *source = [[self alloc] init];
    source.title = @"Все новости";
#warning resolve TODO mark
    // TODO: title value should not be hardcoded
    source.sourceId = sourceTypeAllNews;
    source.articlesController = articlesController;
    return source;
}

+ (instancetype)favoritesSourceWithArticlesController:(ArticlesController *)articlesController {
    Source *source = [[self alloc] init];
    source.title = @"Закладки";
#warning resolve TODO mark
    // TODO: title value should not be hardcoded
    source.sourceId = sourceTypeFavorites;
    source.articlesController = articlesController;
    return source;
}

@end
