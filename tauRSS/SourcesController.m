#import "SourcesController.h"


@implementation SourcesController

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        Source *s1 = [[Source alloc] initWithTitle:@"Все новости"];
        Source *s2 = [[Source alloc] initWithTitle:@"Закладки"];
        Source *s3 = [[Source alloc] initWithTitle:@"Лента RSS"];
        Source *s4 = [[Source alloc] initWithTitle:@"НГС RSS"];
        Source *s5 = [[Source alloc] initWithTitle:@"Яндекс RSS"];
        _sources = @[s1, s2, s3, s4, s5];
    }
    return self;
}

- (void)addSource:(Source *)source {
#warning resolve TODO mark
    // TODO: Implement this
};

- (void)deleteSource:(Source *)source {
#warning resolve TODO mark
    // TODO: Implement this
};

- (void)getSourceById:(NSString *)sourceId {
#warning resolve TODO mark
    // TODO: Implement this
};

- (void)updateAllArticles {
#warning resolve TODO mark
    // TODO: Implement this
};

- (void)updateArticlesForSourceWithId:(NSString *)sourceId {
#warning resolve TODO mark
    // TODO: Implement this
};

- (void)markArticleAsRead:(Article *)article {
#warning resolve TODO mark
    // TODO: Implement this
};

- (void)markArticleAsFavorite:(Article *)article {
#warning resolve TODO mark
    // TODO: Implement this
};

@end
