#import "ArticlesListVC.h"
#import <IIViewDeckController.h>
#import "ArticlesListCell.h"
#import "ArticleDetailsVC.h"
#import "Utils.h"


typedef NS_ENUM(NSInteger, FilterType) {
    filterTypeAll,
    filterTypeUnread,
    filterTypeDefault = filterTypeAll
};

static FilterType currentFilterType = filterTypeDefault;
static BOOL isReadFilterShown = NO;
static float const readFilterHeight = 44.0f;
static NSString *const reuseIDcellWithImage = @"ArticlesListCell1";
static NSString *const reuseIDcellWithoutImage = @"ArticlesListCell2";
static NSString *const kSegmentTitle = @"segment_title";
static NSString *const kSegmentFilterType = @"segment_filter_type";


@interface ArticlesListVC ()

@property (strong, nonatomic) ArticlesController *articlesController;
@property (strong, nonatomic) IBOutlet UISegmentedControl *readFilterControl;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *readFilterHeight;
@property (strong, nonatomic) IBOutlet UITableView *articlesTableView;
@property (strong, nonatomic, readonly) NSArray *articlesTableDatasource;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSArray *readFilterSegments;

@end


@implementation ArticlesListVC

#pragma mark - Getters and setters

- (ArticlesController *)articlesController
{
    if (!_articlesController) {
        _articlesController = [ArticlesController sharedInstance];
    }
    return _articlesController;
}

- (NSArray *)articlesTableDatasource
{
    if (currentFilterType == filterTypeAll) {
        return self.source.articles;
    }
    else if (currentFilterType == filterTypeUnread) {
        return self.source.unreadArticles;
    }
    else {
        NSLog(@"Unimplemented filterType %ld", currentFilterType);
        return nil;
    }
}

- (void)setSource:(Source *)source
{
    _source = source;
    [self.articlesTableView reloadData];
}

#pragma mark - View's lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set up edges for navbar and toolbar for proper working of autolayout
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // Initialize main menu button
    UIImage *barsIcon = [[UIImage imageNamed:@"bars.png"]
        imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
        initWithImage:barsIcon
        style:UIBarButtonItemStylePlain
        target:self.viewDeckController
        action:@selector(toggleLeftView)];
    
    // Initialize filter button
    UIImage *filterIcon = [[UIImage imageNamed:@"filter.png"]
        imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton *filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    filterButton.frame = (CGRect){0, 0, 24, 20};
    [filterButton setImage:filterIcon forState:UIControlStateNormal];
    [filterButton addTarget:self action:@selector(toggleFilterControl:)
        forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
        initWithCustomView:filterButton];
    
    // Initialize custom cells for articles table
    [self.articlesTableView
        registerNib:[UINib nibWithNibName:NSStringFromClass([ArticlesListCell class])
            bundle:[NSBundle mainBundle]]
        forCellReuseIdentifier:reuseIDcellWithImage];
    [self.articlesTableView
        registerNib:[UINib nibWithNibName:NSStringFromClass([ArticlesListCell class])
            bundle:[NSBundle mainBundle]]
        forCellReuseIdentifier:reuseIDcellWithoutImage];
    
    // Initialize refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshArticles)
        forControlEvents:UIControlEventValueChanged];
    [self.articlesTableView addSubview:self.refreshControl];
    
    // Initialize segmented control with read filter options
    self.readFilterSegments = @[
        @{kSegmentTitle: NSLocalizedString(@"all",), kSegmentFilterType: @(filterTypeAll)},
        @{kSegmentTitle: NSLocalizedString(@"unread",), kSegmentFilterType: @(filterTypeUnread)}
    ];
    for (int i = 0; i < self.readFilterSegments.count; i++) {
        [self.readFilterControl
            setTitle:self.readFilterSegments[i][kSegmentTitle]
            forSegmentAtIndex:i];
    }
    [self.readFilterControl addTarget:self
        action:@selector(readFilterValueChanged:)
        forControlEvents:UIControlEventValueChanged];
    self.readFilterHeight.constant = isReadFilterShown ? readFilterHeight : 0.0f;
}

#pragma mark - Actions

- (void)readFilterValueChanged:(UISegmentedControl *)sender
{
    NSDictionary *selectedSegment = self.readFilterSegments[[sender selectedSegmentIndex]];
    currentFilterType = [selectedSegment[kSegmentFilterType] integerValue];
    [self.articlesTableView reloadData];
}

- (void)toggleFilterControl:(UIButton *)sender
{
    self.readFilterHeight.constant = isReadFilterShown ? 0.0f : readFilterHeight;
    isReadFilterShown = !isReadFilterShown;

    [self.view setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.25f animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - UITableViewDataSource implementation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.articlesTableDatasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Article *article = self.articlesTableDatasource[indexPath.row];
    
    NSString *reuseId = article.imageURL ? reuseIDcellWithImage : reuseIDcellWithoutImage;
    
    ArticlesListCell *cell = [self.articlesTableView dequeueReusableCellWithIdentifier:reuseId];
    cell.titleLabel.text = article.title;
    
    cell.infoLabel.text = [Utils buildShortArticleInfo:article];
    cell.descriptionLabel.text = article.articleDescription;
    cell.urlForImage = article.imageURL;
    
    if (article.isRead) {
        [cell setStyle:CellStyleMuted];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Need for working of row editing
}

#pragma mark - UITableViewDelegate implementation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Article *article = self.articlesTableDatasource[indexPath.row];
    
    ArticlesListCell *selectedCell = (ArticlesListCell *)[tableView cellForRowAtIndexPath:indexPath];
    UIImage *articleImage;
    if (selectedCell.articleImageView.image != [ArticlesListCell placeholderImage]) {
        articleImage = selectedCell.articleImageView.image;
    }
    
    ArticleDetailsVC *articleDetailsVC = [[ArticleDetailsVC alloc]
        initWithArticle:article image:articleImage];
    
    [self.navigationController pushViewController:articleDetailsVC animated:YES];
    
    if (!article.isRead) {
        [self setRead:YES forArticle:article atIndexPath:indexPath];
    }
}

- (NSArray *)tableView:(UITableView *)tableView
    editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Article *article = self.articlesTableDatasource[indexPath.row];
    NSString *actionTitle =
        article.isRead ? NSLocalizedString(@"markAsUnRead",) : NSLocalizedString(@"markAsRead",);
    typeof(self) __weak wself = self;
    UITableViewRowAction *markAsReadAction = [UITableViewRowAction
        rowActionWithStyle:UITableViewRowActionStyleDefault
        title:actionTitle
        handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            typeof(wself) __strong sself = wself;
            Article *article = sself.articlesTableDatasource[indexPath.row];
            [sself setRead:!article.isRead forArticle:article atIndexPath:indexPath];
            [sself.articlesTableView setEditing:NO];
        }];
    markAsReadAction.backgroundColor = [UIColor lightGrayColor];
    return @[markAsReadAction];
}

#pragma mark - UIGestureRecognizerDelegate implementation

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
    shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - Auxiliaries

- (void)refreshArticles
{
    [self.articlesController
        updateArticlesForSource:self.source
        success:^(BOOL areNewArticlesAdded) {
            [self.refreshControl endRefreshing];
            if (areNewArticlesAdded) {
                [self.articlesTableView reloadData];
                NSLog(@"Articles table has been refreshed.");
            }
            else {
                NSLog(@"No need to refresh the articles table.");
            }
        } failure:^(NSArray *errors) {
            NSLog(@"Errors: %@", errors);
            [Utils showInfoAlertWithTitle:NSLocalizedString(@"errorLoadingArticles",)
                description:((NSError *)errors.firstObject).localizedDescription
                delegate:(self)];
        }];
}

- (void)setRead:(BOOL)isRead forArticle:(Article *)article atIndexPath:(NSIndexPath *)indexPath
{
    [self.articlesController setRead:isRead forArticle:article];
    if (currentFilterType == filterTypeAll) {
        ArticlesListCell *articlesListCell =
            (ArticlesListCell *)[self.articlesTableView cellForRowAtIndexPath:indexPath];
        CellStyle cellStyleToBeApplied = article.isRead ? CellStyleMuted : CellStyleNormal;
        [articlesListCell setStyle:cellStyleToBeApplied];
    }
    else if (currentFilterType == filterTypeUnread) {
        [self.articlesTableView deleteRowsAtIndexPaths:@[indexPath]
            withRowAnimation:UITableViewRowAnimationTop];
    }
}

@end
