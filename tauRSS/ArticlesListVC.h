#import <UIKit/UIKit.h>
#import "ArticlesController.h"
#import "Source.h"


@interface ArticlesListVC : UIViewController <UIGestureRecognizerDelegate>

@property (strong, nonatomic) Source *source;
@property (strong, nonatomic) IBOutlet UITableView *articlesTableView;

- (void)setRead:(BOOL)isRead forArticle:(Article *)article atIndexPath:(NSIndexPath *)indexPath;

@end
