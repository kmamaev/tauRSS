#import "ArticlesListVC.h"
#import "IIViewDeckController.h"


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

- (void)viewDidLoad {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@"left"
                                             style:UIBarButtonItemStylePlain
                                             target:self.viewDeckController
                                             action:@selector(toggleLeftView)];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.articles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                   reuseIdentifier:@"reuseID2"];
    Article *article = self.articles[indexPath.row];
    
    cell.textLabel.text = article.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@\n%@",
                                 article.category,
                                 article.publishDate,
                                 article.articleDescription];
    cell.detailTextLabel.numberOfLines = 0;
    [cell.detailTextLabel sizeToFit];
    return cell;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)ip {
    Article *article = self.articles[ip.row];
    [self.navigationController pushViewController:[[ArticleDetailsVC alloc] initWithArticle:article]
                                         animated:YES];
}

@end
