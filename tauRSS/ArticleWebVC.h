#import <UIKit/UIKit.h>


@class ArticleDetailsVC;

@interface ArticleWebVC : UIViewController

@property (weak, nonatomic) ArticleDetailsVC *articleDetailsVC;
@property (strong, nonatomic) NSURL *url;

- initWithURL:(NSURL *)url;

@end
