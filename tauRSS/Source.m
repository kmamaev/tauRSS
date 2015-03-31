#import "Source.h"


@interface Source ()
@property (strong, nonatomic) ArticlesController *articlesController;
@end


@implementation Source

- (ArticlesController *)articlesController
{
    if (!_articlesController) {
        _articlesController = [ArticlesController sharedInstance];
    }
    return _articlesController;
}

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
    BOOL isRegularSource = self.sourceId == sourceIdAllNews || self.sourceId == sourceIdFavorites;
    if (!_unreadArticles || isRegularSource) {
        _unreadArticles = [self.articlesController unreadArticlesForSource:self];
    }
    return _unreadArticles;
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
