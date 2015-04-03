#import <UIKit/UIKit.h>
#import "ArticlesController.h"
#import "Source.h"


@interface ArticlesListVC : UIViewController <UIGestureRecognizerDelegate>

@property (weak, nonatomic) Source *source;

- (void)setRead:(BOOL)isRead forArticle:(Article *)article atIndexPath:(NSIndexPath *)indexPath;

@end
