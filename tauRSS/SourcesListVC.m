#import "SourcesListVC.h"
#import "IIViewDeckController.h"
#import "SettingsVC.h"
#import "NewSourceVC.h"
#import "SourcesListCell.h"

static NSString *const reuseIDSourceCell = @"SourceListCell";


@interface SourcesListVC () <NewSourceDelegate>

@property (strong, nonatomic) SourcesController *sourcesController;
@property (weak, nonatomic) NSArray *sources;
@property (strong, nonatomic) NSArray *regularSources;
@property (strong, nonatomic) NSArray *sections;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *settingsBarButtonItem;


- (IBAction)didTapSettingsBarButtonItem:(UIBarButtonItem *)sender;
- (IBAction)didTapAddSourceBarButtonItem:(UIBarButtonItem *)sender;
- (void)updateData;

@end


@implementation SourcesListVC

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _sourcesController = [[SourcesController alloc] init];
        _articlesListVC = [[ArticlesListVC alloc] init];
        _articlesListVC.articlesController = _sourcesController.articlesController;
        _sources = _sourcesController.sources;
        Source *allNewsSource = [Source allNewsSourceWithArticlesController:_sourcesController.articlesController];
        Source *favoritesSource = [Source favoritesSourceWithArticlesController:_sourcesController.articlesController];
        _regularSources = @[allNewsSource, favoritesSource];
        _sections = @[_regularSources, _sources];

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
    
    self.settingsBarButtonItem.title = NSLocalizedString(@"settings", );
}


#pragma mark - UITableViewDataSource implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SourcesListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIDSourceCell];;
    NSArray *sources = self.sections[indexPath.section];
    
    Source *source = sources[indexPath.row];
    cell.titleLabel.text = source.title;
    cell.countLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[source.articles count]];
    return cell;
}

#pragma mark - UITableViewDelegate implementation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Source *source = self.sources[indexPath.row];
    self.articlesListVC.source = source;
    self.articlesListVC.title = source.title;
    [self.viewDeckController closeLeftViewAnimated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
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
#warning Need to handle it correctly
    //[self.sourcesController updateAllArticles];
    [self updateData];
    [self.tableView reloadData];
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];
    
    
}


- (void)updateData
{
    Source *allNewsSource = [Source allNewsSourceWithArticlesController:_sourcesController.articlesController];
    Source *favoritesSource = [Source favoritesSourceWithArticlesController:_sourcesController.articlesController];
    self.regularSources = @[allNewsSource, favoritesSource];
    self.sources = self.sourcesController.sources;
    self.sections = @[self.regularSources, self.sources];
}

@end
