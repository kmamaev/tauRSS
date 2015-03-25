#import "ArticlesListVC.h"
#import <IIViewDeckController.h>
#import "ArticlesListCell.h"
#import "NSDate+DateHelper.h"
#import "Source.h"
#import "ArticleDetailsVC.h"


static NSString *const reuseIDcellWithImage = @"ArticlesListCell1";
static NSString *const reuseIDcellWithoutImage = @"ArticlesListCell2";


@interface ArticlesListVC ()
@end


@implementation ArticlesListVC

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        _articles = [NSArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.articles.count;
}

// Set articles array and reload data of articles table
- (void)setArticles:(NSArray *)articles
{
    _articles = [articles copy];
    [self.articlesTable reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Article *article = self.articles[indexPath.row];
    
    NSString *reuseId = article.imageURL ? reuseIDcellWithImage : reuseIDcellWithoutImage;
    
    ArticlesListCell *cell = [self.articlesTable dequeueReusableCellWithIdentifier:reuseId];
    cell.titleLabel.text = article.title;
    cell.infoLabel.text = [NSString stringWithFormat:@"%@・%@・%@",
        [article.publishDate shortString], article.category, article.source.title];
    cell.descriptionLabel.text = article.articleDescription;
    if (article.imageURL == nil) {
        cell.imageWidth.constant = 0.0f;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Article *article = self.articles[indexPath.row];
    [self.navigationController pushViewController:[[ArticleDetailsVC alloc] initWithArticle:article]
                                         animated:YES];
}

@end
