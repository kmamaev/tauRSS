#import "ArticleDetailsVC.h"
#import "ArticleWebVC.h"


@interface ArticleDetailsVC ()

// UI elements
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;

// Other properties
@property (strong, nonatomic) Article *article;

@end


@implementation ArticleDetailsVC

- (instancetype)initWithArticle:(Article *)article {
    self = [self init];
    if (self != nil) {
        _article = article;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = self.article.title;
    self.descriptionLabel.text = self.article.articleDescription;
}

- (IBAction)didTapLinkButton:(UIButton *)sender {
    ArticleWebVC *articleWebVC = [[ArticleWebVC alloc] initWithURL:self.article.link];
    [self.navigationController pushViewController:articleWebVC
                                         animated:YES];

}

@end
