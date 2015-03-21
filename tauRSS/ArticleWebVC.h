#import <UIKit/UIKit.h>


@class ArticleDetailsVC;

@interface ArticleWebVC : UIViewController

@property (weak, nonatomic) ArticleDetailsVC *articleDetailsVC;

- initWithURL:(NSURL *)url;

@end
