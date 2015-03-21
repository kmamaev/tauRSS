#import <UIKit/UIKit.h>
#import "Article.h"


@interface ArticleDetailsVC : UIViewController

- (instancetype)initWithArticle:(Article *)article;
- (void)didTapPlanetButton:(UIButton *)sender;

@end
