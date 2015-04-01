#import <Foundation/Foundation.h>
#import "Source.h"
#import "Article.h"
#import "ArticlesController.h"

@class StorageController;


@interface SourcesController : NSObject

@property (strong, nonatomic) NSArray *sources;
@property (strong, nonatomic) ArticlesController *articlesController;
@property (strong, nonatomic) StorageController *storageController;

- (void)addSource:(Source *)source;
- (void)deleteSource:(Source *)source;
- (void)getSourceById:(NSString *)sourceId;
+ (instancetype)sharedInstance;

@end
