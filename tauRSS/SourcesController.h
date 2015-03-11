#import <Foundation/Foundation.h>
#import "Source.h"
#import "Article.h"
#import "StorageController.h"


@interface SourcesController : NSObject

@property (nonatomic, strong) NSArray *sources;

- (void)addSource:(Source *)source;
- (void)deleteSource:(Source *)source;
- (void)getSourceById:(NSString *)sourceId;
- (void)updateAllArticles;
- (void)updateArticlesForSourceWithId:(NSString *)sourceId;
- (void)markArticleAsRead:(Article *)article;
- (void)markArticleAsFavorite:(Article *)article;

@end
