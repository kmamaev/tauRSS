#import <Foundation/Foundation.h>
#import "Source.h"
#import "Article.h"
#import "StorageController.h"
#import "ArticlesController.h"


@interface SourcesController : NSObject

@property (strong, nonatomic) NSArray *sources;
@property (strong, nonatomic) ArticlesController *articlesController;

- (void)addSource:(Source *)source;
- (void)deleteSource:(Source *)source;
- (void)getSourceById:(NSString *)sourceId;
- (void)updateAllArticles;
- (void)updateArticlesForSourceWithId:(NSString *)sourceId;

@end
