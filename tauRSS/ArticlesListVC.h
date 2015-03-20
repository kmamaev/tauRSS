#import <UIKit/UIKit.h>


@interface ArticlesListVC : UIViewController

@property (copy, nonatomic) NSArray *articles;
@property (strong, nonatomic) IBOutlet UITableView *articlesTable;

@end
