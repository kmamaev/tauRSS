#import <UIKit/UIKit.h>
#import "ArticleDetailsVC.h"
#import "Article.h"


@interface ArticlesListVC : UIViewController

@property (copy, nonatomic) NSArray *articles;
@property (strong, nonatomic) IBOutlet UITableView *articlesTable;

@end
