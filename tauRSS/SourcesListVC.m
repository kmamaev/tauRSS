#import "SourcesListVC.h"
#import "IIViewDeckController.h"


@interface SourcesListVC ()

@property (strong, nonatomic) SourcesController *sourcesController;
@property (strong, nonatomic, readonly) NSArray *sources;

@end


@implementation SourcesListVC

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _sourcesController = [[SourcesController alloc] init];
        _articlesListVC = [[ArticlesListVC alloc] init];
        _articlesListVC.articlesController = _sourcesController.articlesController;
        _sources = _sourcesController.sources;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:@"reuseID1"];
    Source *source = self.sources[indexPath.row];
    cell.textLabel.text = source.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Source *source = self.sources[indexPath.row];
    self.articlesListVC.source = source;
    self.articlesListVC.title = source.title;
    [self.viewDeckController closeLeftViewAnimated:YES];
}

@end
