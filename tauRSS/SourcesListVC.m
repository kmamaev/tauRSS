#import "SourcesListVC.h"
#import "IIViewDeckController.h"


@interface SourcesListVC ()

@property (strong, nonatomic) SourcesController *sourcesController;
@property (weak, nonatomic, readonly) NSArray *sources;
#warning property sources in sourceController should not be (copy)

@end


@implementation SourcesListVC

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _sourcesController = [[SourcesController alloc] init];
        _articlesListVC = [[ArticlesListVC alloc] init];
        _sources = _sourcesController.sources;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)ip {
    Source *source = self.sources[ip.row];
    self.articlesListVC.articles = source.articles;
    [self.articlesListVC.articlesTable reloadData];
    [self.viewDeckController closeLeftViewAnimated:YES];
}

@end
