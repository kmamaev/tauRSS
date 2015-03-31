#import <Foundation/Foundation.h>
#import "SourcesController.h"
#import "Source.h"
#import "Article.h"


@interface StorageController : NSObject

- (void)storeSource:(Source *)source;
- (void)storeArticles:(NSArray *)articles forSourceWithId:(NSInteger)sourceId;
- (NSArray *)getAllSources;

//delete source from 'sources' table in db and delete all articles with the same sourceId from 'articles' table
- (void)deleteSource:(Source *)source;

- (void)setRead:(BOOL)isRead forArticle:(Article *)article;
- (void)setFavorite:(BOOL)isFavorite forArticle:(Article *)article;
- (void)deleteAllArticles;


@end
