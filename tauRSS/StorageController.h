#import <Foundation/Foundation.h>
#import "SourcesController.h"
#import "Source.h"
#import "Article.h"


@interface StorageController : NSObject

- (void)storeSource:(Source *)source;
- (void)storeArticles:(NSArray *)articles forSourceWithId:(NSInteger)sourceId;
- (NSArray *)getAllSources;
- (void)deleteSource:(Source *)source;

@end
