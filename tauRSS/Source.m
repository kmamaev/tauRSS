#import "Source.h"


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
    source.title = NSLocalizedString(@"allNews", );
    source.sourceId = sourceIdAllNews;
    return source;
}

+ (instancetype)favoritesSourceWithArticlesController:(ArticlesController *)articlesController {
    Source *source = [[self alloc] initWithArticlesController:articlesController];
    source.title = NSLocalizedString(@"favorites", );
    source.sourceId = sourceIdFavorites;
    return source;
}

- (NSArray *)unreadArticles {
    return [self.articlesController unreadArticlesForSource:self];
}

@end
