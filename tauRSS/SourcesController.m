#import "SourcesController.h"
#import <AFHTTPRequestOperationManager.h>
#import "RSSParser.h"


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

- (void)updateAllArticles {
#warning resolve TODO mark
    // TODO: Implement this
};

- (void)updateArticlesForSource:(Source *)source
{
#warning resolve TODO mark
    // TODO: Implement this properly
    NSString *URLString = source.sourceURL.absoluteString;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/rss+xml"];
    [manager GET:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        RSSParser *rssParser = [[RSSParser alloc] init];
        NSArray *articles = [rssParser parseResponse:(NSXMLParser *)responseObject];
        NSLog(@"Response: %@", articles);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
};

@end
