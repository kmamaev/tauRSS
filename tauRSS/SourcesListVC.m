#import "SourcesListVC.h"
#import "IIViewDeckController.h"
#import "SettingsVC.h"
#import "NewSourceVC.h"
#import "SourcesListCell.h"

static NSString *const reuseIDSourceCell = @"SourceListCell";


@interface SourcesListVC () <NewSourceDelegate>

@property (strong, nonatomic) SourcesController *sourcesController;
@property (weak, nonatomic, readonly) NSArray *sources;
@property (strong, nonatomic, readonly) NSArray *regularSources;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)didTapSettingsBarButtonItem:(UIBarButtonItem *)sender;
- (IBAction)didTapAddSourceBarButtonItem:(UIBarButtonItem *)sender;

@end


@implementation SourcesListVC

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _sourcesController = [[SourcesController alloc] init];
        _articlesListVC = [[ArticlesListVC alloc] init];
        _sources = _sourcesController.sources;
        Source *allNewsSource = [Source allNewsSourceWithArticlesController:_sourcesController.articlesController];
        Source *favoritesSource = [Source favoritesSourceWithArticlesController:_sourcesController.articlesController];
        _regularSources = @[allNewsSource, favoritesSource];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.navigationItem)
    {
        self.navigationItem.title = @"tauRSS";
    }
    
    [self.tableView
     registerNib:[UINib nibWithNibName:NSStringFromClass([SourcesListCell class])
                                bundle:[NSBundle mainBundle]]
     forCellReuseIdentifier:reuseIDSourceCell];
}


#pragma mark - UITableViewDataSource implementation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SourcesListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIDSourceCell];;
    Source *source = self.sources[indexPath.row];
    cell.titleLabel.text = source.title;
    cell.countLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[source.articles count]];
    return cell;
}


#pragma mark - UITableViewDelegate implementation

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)ip {
    Source *source = self.sources[ip.row];
    self.articlesListVC.articles = source.articles;
    self.articlesListVC.title = source.title;
    [self.viewDeckController closeLeftViewAnimated:YES];
    [self.tableView deselectRowAtIndexPath:ip animated:YES];
}

#pragma mark - Actions


- (IBAction)didTapSettingsBarButtonItem:(UIBarButtonItem *)sender
{
    SettingsVC *settingsVC = [[SettingsVC alloc]init];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:settingsVC];
    [self presentViewController:navController animated:YES completion:nil];
}

- (IBAction)didTapAddSourceBarButtonItem:(UIBarButtonItem *)sender
{
    NewSourceVC *newVC = [[NewSourceVC alloc]init];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:newVC];
    [self presentViewController:navController animated:YES completion:nil];
}

#pragma mark - NewSourceViewControllerDelegate implementation

- (void)newSourceViewController:(NewSourceVC *)sender didFinishWithSource:(Source *)sourse
{
    sourse.sourceId = [self.sourcesController.sources count];
    [self.sourcesController addSource:sourse];
    
    [self.tableView reloadData];
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];
    
    
}
@end
