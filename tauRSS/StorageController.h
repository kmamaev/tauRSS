#import <Foundation/Foundation.h>
#import "SourcesController.h"
#import "Source.h"
#import "Article.h"


@interface StorageController : NSObject

- (void)storeSource:(Source *)source;
- (void)storeArticles:(NSArray *)articles forSourceWithId:(NSString *)sourceId;
- (NSArray *)getAllSources;

@end
