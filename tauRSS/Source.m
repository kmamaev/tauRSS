#import "Source.h"


@interface Source()

@property (weak, nonatomic, readonly) ArticlesController *articlesController;

@end


@implementation Source

- (instancetype)initWithArticlesController:(ArticlesController *)articlesController {
    self = [self init];
    if (self != nil) {
        _articlesController = articlesController;
    }
    return self;
}

- (NSArray *)articles {
    if (self.sourceId == sourceIdAllNews) {
        return [self.articlesController allArticles];
    }
    else if (self.sourceId == sourceIdFavorites) {
        return [self.articlesController favoriteArticles];
    }
    else return _articles;
}

+ (instancetype)allNewsSourceWithArticlesController:(ArticlesController *)articlesController {
    Source *source = [[self alloc] initWithArticlesController:articlesController];
    source.title = @"Все новости";
#warning resolve TODO mark
    // TODO: title value should not be hardcoded
    source.sourceId = sourceIdAllNews;
    return source;
}

+ (instancetype)favoritesSourceWithArticlesController:(ArticlesController *)articlesController {
    Source *source = [[self alloc] initWithArticlesController:articlesController];
    source.title = @"Закладки";
#warning resolve TODO mark
    // TODO: title value should not be hardcoded
    source.sourceId = sourceIdFavorites;
    return source;
}

@end
