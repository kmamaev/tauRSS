#import <UIKit/UIKit.h>
#import "ArticlesListVC.h"
#import "SourcesController.h"
#import <IIViewDeckController.h>


@interface SourcesListVC : UIViewController <IIViewDeckControllerDelegate>
@property (strong, nonatomic, readonly) ArticlesListVC *articlesListVC;
@end
