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
    success:(void (^)(BOOL))success
    failure:(void (^)(NSArray *))failure
{
    // If source is equal to "All news"
    if (source.sourceId == sourceIdAllNews) {
        NSMutableArray *__block errors = [NSMutableArray array];
        BOOL __block areAllArticlesHaveUpdates = NO;
        dispatch_group_t group = dispatch_group_create();
        for (Source *s in self.sourcesController.sources) {
            dispatch_group_enter(group);
            [self updateArticlesForSource:s
                success:^(BOOL areNewArticlesAdded) {
                    if (areNewArticlesAdded && !areAllArticlesHaveUpdates) {
                        areAllArticlesHaveUpdates = YES;
                    }
                    dispatch_group_leave(group);
                } failure:^(NSArray *error) {
                    @synchronized(errors) {
                        [errors addObjectsFromArray:error];
                    }
                    dispatch_group_leave(group);
                }];
        }
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            NSLog(@"All sources updated.");
            if (errors.count > 0) {
                failure(errors);
            }
            else {
                success(areAllArticlesHaveUpdates);
            }
        });
    }
    
    // If source is equal to "Favorites"
    else if (source.sourceId == sourceIdFavorites) {
        success(NO);
    }
    
    // If source is not equal to "All news" or "Favorites"
    else {
        NSString *URLString = source.sourceURL.absoluteString;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
#warning I am not sure that only type "application/rss+xml" is necessary. Need to additional investigation.
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/rss+xml"];
        [manager GET:URLString
            parameters:nil
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                RSSParser *rssParser = [[RSSParser alloc] init];
                NSMutableSet *fetchedArticles = [rssParser parseResponse:(NSXMLParser *)responseObject];
                NSSet *currentArticles = [NSSet setWithArray:source.articles];
                [fetchedArticles minusSet:currentArticles];
                NSArray *newArticles = [[self class] articlesArrayBySortingASet:fetchedArticles];
                source.articles = [newArticles arrayByAddingObjectsFromArray:source.articles];
                NSLog(@"Update for source \"%@\" has finished, %ld articles are added:", source.title, newArticles.count);
                for (Article *a in newArticles) {
                    NSLog(@"%@", a);
                }
                success(newArticles.count > 0);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                failure(@[error]);
            }];
    }
}

// Sort the specified articles set by publish date and returns the sorted set as array
+ (NSArray *)articlesArrayBySortingASet:(NSSet *)unsortedArticlesSet
{
    NSSortDescriptor *publishDateSortDescriptor = [NSSortDescriptor
        sortDescriptorWithKey:@"publishDate" ascending:NO];
    return [unsortedArticlesSet sortedArrayUsingDescriptors:@[publishDateSortDescriptor]];
}

@end
