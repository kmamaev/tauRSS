#import "SourcesListVC.h"
#import "SettingsVC.h"
#import "NewSourceVC.h"
#import "SourcesListCell.h"
#import <IIViewDeckController.h>
#import "AlertUtils.h"


static NSString *const reuseIDSourceCell = @"SourceListCell";
static void *const sourcesListContext = (void *)&sourcesListContext;


@interface SourcesListVC () <NewSourceDelegate>

@property (strong, nonatomic) SourcesController *sourcesController;
@property (strong, nonatomic) NSArray *regularSources;
@property (strong, nonatomic) NSArray *sections;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *settingsBarButtonItem;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

- (IBAction)didTapSettingsBarButtonItem:(UIBarButtonItem *)sender;
- (IBAction)didTapAddSourceBarButtonItem:(UIBarButtonItem *)sender;
- (void)updateData;

@end


@implementation SourcesListVC

#pragma mark - Initialization

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        _articlesListVC = [[ArticlesListVC alloc] init];
        NSArray *sources = [SourcesController sharedInstance].sources;
        Source *allNewsSource = [Source allNewsSource];
        Source *favoritesSource = [Source favoritesSource];
        _regularSources = @[allNewsSource, favoritesSource];
        _sections = @[_regularSources, sources];
        
        [self.sourcesController addObserver:self
                        forKeyPath:@"sources"
                           options:NSKeyValueObservingOptionNew
                           context:sourcesListContext];
        
        [[ArticlesController sharedInstance] addObserver:self
                                 forKeyPath:@"favoriteArticles"
                                    options:NSKeyValueObservingOptionNew
                                    context:sourcesListContext];

    }
    return self;
}

- (void)dealloc
{
    [self.sourcesController removeObserver:self
                       forKeyPath:@"sources"
                          context:sourcesListContext];
    
    [[ArticlesController sharedInstance] removeObserver:self
                                forKeyPath:@"favoriteArticles"
                                   context:sourcesListContext];
}

#pragma mark - Getters

- (SourcesController *)sourcesController
{
    if (!_sourcesController) {
        _sourcesController = [SourcesController sharedInstance];
    }
    return _sourcesController;
}

#pragma mark - View's lifecycle

- (void)viewDidLoad
{
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
    
    // Initialize refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshSources)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

#pragma mark - UITableViewDataSource implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sections[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
    cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SourcesListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIDSourceCell];
    NSArray *sources = self.sections[indexPath.section];
    
    Source *source = sources[indexPath.row];
    cell.titleLabel.text = source.title;
    cell.countLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[source.articles count]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 0)
        return NO;
    else
        return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSArray *sources = self.sections[indexPath.section];
        Source *source = sources[indexPath.row];
        [self.sourcesController deleteSource:source];
        [self updateData];
        NSIndexPath *allSourceIP = [NSIndexPath indexPathForRow:0 inSection:0];
        NSIndexPath *favoriteSourceIP = [NSIndexPath indexPathForRow:1 inSection:0];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView reloadRowsAtIndexPaths:@[allSourceIP, favoriteSourceIP] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
}

#pragma mark - UITableViewDelegate implementation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sources = self.sections[indexPath.section];
    Source *source = sources[indexPath.row];
    self.articlesListVC.source = source;
    self.articlesListVC.title = source.title;
    [self.viewDeckController closeLeftViewAnimated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Actions

- (IBAction)didTapSettingsBarButtonItem:(UIBarButtonItem *)sender
{
    SettingsVC *settingsVC = [[SettingsVC alloc]init];
    UINavigationController *navController = [[UINavigationController alloc]
        initWithRootViewController:settingsVC];
    [self presentViewController:navController animated:YES completion:nil];
}

- (IBAction)didTapAddSourceBarButtonItem:(UIBarButtonItem *)sender
{
    NewSourceVC *newVC = [[NewSourceVC alloc]init];
    UINavigationController *navController = [[UINavigationController alloc]
        initWithRootViewController:newVC];
    [self presentViewController:navController animated:YES completion:nil];
}

#pragma mark - NewSourceViewControllerDelegate implementation

- (void)newSourceViewController:(NewSourceVC *)sender didFinishWithSource:(Source *)sourse
{
    sourse.sourceId = [self.sourcesController.sources count];
    [self.sourcesController addSource:sourse];
    ArticlesController *articlesController = [ArticlesController sharedInstance];
    [articlesController updateArticlesForSource:sourse success:^(BOOL areNewArticlesAdded)
    {
        if (areNewArticlesAdded) {
            [self updateData];
            [self.tableView reloadData];;
            NSLog(@"Sources table has been refreshed.");
        }
        else {
            NSLog(@"No need to refresh the sources table.");
        }
    } failure:^(NSArray *errors)
    {
        NSLog(@"Errors: %@", errors);
        NSString *alertDesctiption = ((NSError *)errors.firstObject).localizedDescription;
        showInfoAlert(NSLocalizedString(@"errorLoadingArticles",), alertDesctiption, self);

    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateData
{
    Source *allNewsSource = [Source allNewsSource];
    Source *favoritesSource = [Source favoritesSource];
    self.regularSources = @[allNewsSource, favoritesSource];
    //self.sourcesController.sources = self.sourcesController.sources;
    self.sections = @[self.regularSources, self.sourcesController.sources];
}

- (void)refreshSources
{
    ArticlesController *articlesController = [ArticlesController sharedInstance];
    [articlesController
     updateArticlesForSource:self.regularSources.firstObject
     success:^(BOOL areNewArticlesAdded) {
         [self.refreshControl endRefreshing];
         if (areNewArticlesAdded) {
             [self.tableView reloadData];
             NSLog(@"Sources table has been refreshed.");
         }
         else {
             NSLog(@"No need to refresh the sources table.");
         }
     } failure:^(NSArray *errors) {
         NSLog(@"Errors: %@", errors);
         [self.refreshControl endRefreshing];
         NSString *alertDesctiption = ((NSError *)errors.firstObject).localizedDescription;
         showInfoAlert(NSLocalizedString(@"errorLoadingArticles",), alertDesctiption, self);
     }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == sourcesListContext) {
        [self updateData];
        [self.tableView reloadData];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


@end
