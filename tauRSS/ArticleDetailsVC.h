#import <UIKit/UIKit.h>
#import "Article.h"


@interface ArticleDetailsVC : UIViewController

@property (strong, nonatomic) Article *article;
@property (strong, nonatomic) UIImage *articleImage;

- (instancetype)initWithArticle:(Article *)article image:(UIImage *)articleImage;
- (void)didTapPlanetButton:(UIButton *)sender;

@end
