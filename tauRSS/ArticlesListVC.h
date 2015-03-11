#import <UIKit/UIKit.h>
#import "ArticleDetailsVC.h"
#import "Article.h"


@interface ArticlesListVC : UIViewController

@property (nonatomic, strong) NSArray *articles;
@property (strong, nonatomic) IBOutlet UITableView *articlesTable;

@end
