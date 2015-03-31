#import "SourcesController.h"


@interface SourcesController ()

@property (nonatomic, strong) StorageController *storageController;

@end


@implementation SourcesController

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        _storageController = [[StorageController alloc] init];
        _articlesController = [[ArticlesController alloc] init];
        _sources = [_storageController getAllSources];
    }
    return self;
}

+ (SourcesController *)sharedInstance
{
    static SourcesController *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[SourcesController alloc] init];
    });
    return sharedInstance;
}

- (void)addSource:(Source *)source
{
    self.sources = [self.sources arrayByAddingObject:source];
    [self.storageController storeSource:source];
}

- (void)deleteSource:(Source *)source
{
    NSMutableArray *newSources = [self.sources mutableCopy];
    [newSources removeObject:source];
    self.sources = [NSArray arrayWithArray:newSources];
    [self.storageController deleteSource:source];
}

- (void)getSourceById:(NSString *)sourceId {
#warning resolve TODO mark
    // TODO: Implement this
}

@end
