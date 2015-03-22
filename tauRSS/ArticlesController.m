#import "ArticlesController.h"
#import "SourcesController.h"
#import <AFHTTPRequestOperationManager.h>
#import "RSSParser.h"


@implementation ArticlesController

- (void)setRead:(BOOL)isRead forArticle:(Article *)article
{
#warning resolve TODO mark
    // TODO: Implement this
}

- (void)setFavorite:(BOOL)isFavorite forArticle:(Article *)article
{
#warning resolve TODO mark
    // TODO: Implement this
}

- (NSArray *)allArticles
{
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

- (void)updateArticlesForSource:(Source *)source
    success:(void (^)())success
    failure:(void (^)(NSError *))failure
{
#warning resolve TODO mark
    // TODO: Implement this properly
    
    
    NSString *URLString = source.sourceURL.absoluteString;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
#warning I am not sure that only type "application/rss+xml" is necessary. Need to additional investigation.
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/rss+xml"];
    [manager GET:URLString
        parameters:nil
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            RSSParser *rssParser = [[RSSParser alloc] init];
            NSArray *articles = [rssParser parseResponse:(NSXMLParser *)responseObject];
            source.articles = articles;
            NSLog(@"Update has finished");
            success();
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            failure(error);
        }];
};

@end
