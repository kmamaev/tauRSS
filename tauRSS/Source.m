#import "Source.h"


@implementation Source

- (NSArray *)articles
{
    if (self.sourceId == sourceIdAllNews) {
        return [self.articlesController allArticles];
    }
    else if (self.sourceId == sourceIdFavorites) {
        return [self.articlesController favoriteArticles];
    }
    else return _articles;
}

- (NSArray *)unreadArticles
{
    return [self.articlesController unreadArticlesForSource:self];
}

+ (instancetype)allNewsSource
{
    Source *source = [[self alloc] init];
    source.title = NSLocalizedString(@"allNews", );
    source.sourceId = sourceIdAllNews;
    return source;
}

+ (instancetype)favoritesSource
{
    Source *source = [[self alloc] init];
    source.title = NSLocalizedString(@"favorites", );
    source.sourceId = sourceIdFavorites;
    return source;
}

@end
