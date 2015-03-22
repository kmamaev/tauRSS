#import "ArticlesListVC.h"
#import <IIViewDeckController.h>
#import "ArticlesListCell.h"
#import "NSDate+DateHelper.h"
#import "Source.h"
#import "ArticleDetailsVC.h"


static NSString *const reuseIDcellWithImage = @"ArticlesListCell1";
static NSString *const reuseIDcellWithoutImage = @"ArticlesListCell2";
static const CGFloat cellHeight = 96.0f;


@interface ArticlesListVC () <ArticlesController>

@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end


@implementation ArticlesListVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Add self to observers list of articles controller
    [self.articlesController addObserver:self];
    
    // Initialize main menu button
    UIButton *mainMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *barsIcon = [[UIImage imageNamed:@"bars.png"]
        imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [mainMenuButton setImage:barsIcon forState:UIControlStateNormal];
    mainMenuButton.frame = (CGRect){0, 0, 20, 24};
    [mainMenuButton addTarget:self.viewDeckController
        action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
        initWithCustomView:mainMenuButton];
    
    // Initialize custom cells for articles table
    [self.articlesTable
        registerNib:[UINib nibWithNibName:NSStringFromClass([ArticlesListCell class])
            bundle:[NSBundle mainBundle]]
        forCellReuseIdentifier:reuseIDcellWithImage];
    [self.articlesTable
        registerNib:[UINib nibWithNibName:NSStringFromClass([ArticlesListCell class])
            bundle:[NSBundle mainBundle]]
        forCellReuseIdentifier:reuseIDcellWithoutImage];
    
    // Initialize the refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshArticles)
        forControlEvents:UIControlEventValueChanged];
    [self.articlesTable addSubview:self.refreshControl];
}

- (void)dealloc
{
    // Remove self from observers list of articles controller
    [self.articlesController removeObserver:self];
}

- (void)setSource:(Source *)source {
    _source = source;
    [self.articlesTable reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.source.articles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Article *article = self.source.articles[indexPath.row];
    
    NSString *reuseId = article.imageURL ? reuseIDcellWithImage : reuseIDcellWithoutImage;
    
    ArticlesListCell *cell = [self.articlesTable dequeueReusableCellWithIdentifier:reuseId];
    cell.titleLabel.text = article.title;
    cell.infoLabel.text = [NSString stringWithFormat:@"%@・%@・%@",
        [article.publishDate convertToShortString], article.category, article.source.title];
    cell.descriptionLabel.text = article.articleDescription;
    if (article.imageURL == nil) {
        cell.imageWidth.constant = 0.0f;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Article *article = self.source.articles[indexPath.row];
    [self.navigationController pushViewController:[[ArticleDetailsVC alloc] initWithArticle:article]
                                         animated:YES];
}

- (void)refreshArticles
{
    [self.articlesController updateArticlesForSource:self.source];
}

- (void)articleControllerDidFinishUpdateArticles
{
    [self.refreshControl endRefreshing];
    [self.articlesTable reloadData];
}

@end
