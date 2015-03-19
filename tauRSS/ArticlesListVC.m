#import "ArticlesListVC.h"
#import "IIViewDeckController.h"
#import "ArticlesListCell.h"
#import "NSDate+DateHelper.h"


static NSString *const reuseIDcellWithImage = @"ArticlesListCell1";
static NSString *const reuseIDcellWithoutImage = @"ArticlesListCell2";
static const CGFloat cellHeight = 96.0f;


@interface ArticlesListVC ()
@end


@implementation ArticlesListVC

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _articles = [NSArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
        initWithTitle:@"left" style:UIBarButtonItemStylePlain target:self.viewDeckController
        action:@selector(toggleLeftView)];
    
    [self.articlesTable
        registerNib:[UINib nibWithNibName:NSStringFromClass([ArticlesListCell class])
            bundle:[NSBundle mainBundle]]
        forCellReuseIdentifier:reuseIDcellWithImage];
    
    [self.articlesTable
        registerNib:[UINib nibWithNibName:NSStringFromClass([ArticlesListCell class])
            bundle:[NSBundle mainBundle]]
        forCellReuseIdentifier:reuseIDcellWithoutImage];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.articles.count;
}

// Set articles array and reload data of articles table
- (void)setArticles:(NSArray *)articles {
    _articles = [articles copy];
    [self.articlesTable reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Article *article = self.articles[indexPath.row];
    
    NSString *reuseId = article.imageURL ? reuseIDcellWithImage : reuseIDcellWithoutImage;
    
    ArticlesListCell *cell = [self.articlesTable dequeueReusableCellWithIdentifier:reuseId];
    cell.titleLabel.text = article.title;
#warning source of an article should not be hardcoded
    cell.infoLabel.text = [NSString stringWithFormat:@"%@・%@・%@",
        [article.publishDate convertToSpecialString], article.category, @"НГС RSS"];
    cell.descriptionLabel.text = article.articleDescription;
    if (article.imageURL == nil) {
        cell.imageWidth.constant = 0.0f;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)ip {
    Article *article = self.articles[ip.row];
    [self.navigationController pushViewController:[[ArticleDetailsVC alloc] initWithArticle:article]
                                         animated:YES];
}

@end
