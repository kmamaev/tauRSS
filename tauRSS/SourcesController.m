#import "SourcesController.h"


@implementation SourcesController

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        Article *a1 = [[Article alloc] initWithTitle:@"Доллар подорожал"];
        Article *a2 = [[Article alloc] initWithTitle:@"Выпало рекордное количество снега"];
        Article *a3 = [[Article alloc] initWithTitle:@"13ый трамвай устроил дтп"];
        Article *a4 = [[Article alloc] initWithTitle:@"Apple продали много iphone'ов"];
        Article *a5 = [[Article alloc] initWithTitle:@"Президент подписал указ"];
        NSArray *articles = @[a1, a2, a3, a4, a5];
        
        Source *s1 = [[Source alloc] initWithTitle:@"Все новости"];
        Source *s2 = [[Source alloc] initWithTitle:@"Закладки"];
        Source *s3 = [[Source alloc] initWithTitle:@"Лента RSS"];
        Source *s4 = [[Source alloc] initWithTitle:@"НГС RSS"];
        Source *s5 = [[Source alloc] initWithTitle:@"Яндекс RSS"];
        
        s1.articles = s2.articles = s3.articles = s4.articles = s5.articles = articles; //Only for test purposes
        
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
