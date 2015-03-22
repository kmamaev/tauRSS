#import "SourcesController.h"


@interface SourcesController ()

@property (nonatomic, strong) StorageController *storageController;

@end


@implementation SourcesController

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _storageController = [[StorageController alloc] init];
        
        _articlesController = [[ArticlesController alloc] init];
        _articlesController.sourcesController = self;
        
        _sources = [_storageController getAllSources];
    }
    return self;
}

- (void)addSource:(Source *)source {
#warning resolve TODO mark
    // TODO: Implement this
};

- (void)deleteSource:(Source *)source {
#warning resolve TODO mark
    // TODO: Implement this
};

- (void)getSourceById:(NSString *)sourceId {
#warning resolve TODO mark
    // TODO: Implement this
};

@end
