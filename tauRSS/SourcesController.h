#import <Foundation/Foundation.h>
#import "Source.h"
#import "Article.h"
#import "ArticlesController.h"

@class StorageController;


@interface SourcesController : NSObject

@property (strong, nonatomic) NSArray *sources;
@property (strong, nonatomic) StorageController *storageController;

- (void)addSource:(Source *)source;
- (void)deleteSource:(Source *)source;
+ (instancetype)sharedInstance;

@end
