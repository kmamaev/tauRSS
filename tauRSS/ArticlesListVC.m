#import "ArticlesListVC.h"
#import <IIViewDeckController.h>
#import "ArticlesListCell.h"
#import "Source.h"
#import "ArticleDetailsVC.h"
#import "Utils.h"


static NSString *const reuseIDcellWithImage = @"ArticlesListCell1";
static NSString *const reuseIDcellWithoutImage = @"ArticlesListCell2";


@interface ArticlesListVC ()

@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end


@implementation ArticlesListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialize main menu button
    UIImage *barsIcon = [[UIImage imageNamed:@"bars.png"]
        imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
        initWithImage:barsIcon
        style:UIBarButtonItemStylePlain
        target:self.viewDeckController
        action:@selector(toggleLeftView)];
    
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

- (NSArray *)tableView:(UITableView *)tableView
    editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *markAsReadAction = [UITableViewRowAction
        rowActionWithStyle:UITableViewRowActionStyleDefault
        title:NSLocalizedString(@"markAsRead",)
        handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            [self.articlesTable setEditing:NO];
#warning Need to implement marking as read
            NSLog(@"Marked as read");
        }];
    markAsReadAction.backgroundColor = [UIColor lightGrayColor];
    return @[markAsReadAction];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
    shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Need for working of row editing
}

- (void)setSource:(Source *)source {
    _source = source;
    [self.articlesTable reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.source.articles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Article *article = self.source.articles[indexPath.row];
    
    NSString *reuseId = article.imageURL ? reuseIDcellWithImage : reuseIDcellWithoutImage;
    
    ArticlesListCell *cell = [self.articlesTable dequeueReusableCellWithIdentifier:reuseId];
    cell.titleLabel.text = article.title;

    cell.infoLabel.text = [Utils buildShortArticleInfo:article];
    cell.descriptionLabel.text = article.articleDescription;
    cell.urlForImage = article.imageURL;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Article *article = self.source.articles[indexPath.row];
    
    ArticlesListCell *selectedCell = (ArticlesListCell *)[tableView cellForRowAtIndexPath:indexPath];
    UIImage *articleImage;
    if (selectedCell.articleImageView.image != [ArticlesListCell placeholderImage]) {
        articleImage = selectedCell.articleImageView.image;
    }
    
    ArticleDetailsVC *articleDetailsVC = [[ArticleDetailsVC alloc]
        initWithArticle:article image:articleImage];
    
    [self.navigationController pushViewController:articleDetailsVC animated:YES];
}

- (void)refreshArticles
{
    [self.articlesController
        updateArticlesForSource:self.source
        success:^(BOOL areNewArticlesAdded) {
            [self.refreshControl endRefreshing];
            if (areNewArticlesAdded) {
                [self.articlesTable reloadData];
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

@end
