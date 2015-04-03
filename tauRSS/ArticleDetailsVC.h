#import <UIKit/UIKit.h>
#import "Article.h"


@class ArticlesListVC;

@interface ArticleDetailsVC : UIViewController

@property (strong, nonatomic) Article *article;
@property (assign, nonatomic) NSInteger index;
@property (weak, nonatomic) ArticlesListVC *articlesListVC;

- (instancetype)initWithArticle:(Article *)article;
- (void)didTapPlanetButton:(UIButton *)sender;

@end
