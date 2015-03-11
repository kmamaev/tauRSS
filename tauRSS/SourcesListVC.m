#import "SourcesListVC.h"
#import "IIViewDeckController.h"


@interface SourcesListVC ()

@property (nonatomic, strong) SourcesController *sourcesController;

@end


@implementation SourcesListVC

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _sourcesController = [[SourcesController alloc] init];
        _articlesListVC = [[ArticlesListVC alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sourcesController.sources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:@"reuseID1"];
    Source *source = self.sourcesController.sources[indexPath.row];
    cell.textLabel.text = source.title;
    return cell;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)ip {
    Source *source = self.sourcesController.sources[ip.row];
    self.articlesListVC.articles = source.articles;
    [self.articlesListVC.articlesTable reloadData];
    [self.viewDeckController closeLeftViewAnimated:YES];
}

@end
