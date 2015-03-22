#import "ArticleDetailsVC.h"
#import "ArticleWebVC.h"
#import "NSDate+DateHelper.h"
#import "Source.h"


@interface ArticleDetailsVC ()

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *leftArrowButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *rightArrowButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *planetButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *starButton;


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
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.titleLabel.text = self.article.title;
    self.descriptionLabel.text = self.article.articleDescription;
    self.infoLabel.text = [NSString stringWithFormat:@"%@・%@・%@",
        [self.article.publishDate convertToLongString],
        self.article.category, self.article.source.title];
    if (self.article.imageURL == nil) {
        self.imageHeight.constant = 0.0f;
    }
    
    // Initialize toolbar items
    [self initializeToolbarItems];
}

- (void)initializeToolbarItems {
    CGRect toolBarIconFrame = (CGRect){0, 0, 30, 30};
    
    // Initialize 'left arrow' button
    UIImage *leftArrowImage = [[UIImage imageNamed:@"left_arrow.png"]
        imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton *lestArrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    lestArrowButton.frame = toolBarIconFrame;
    [lestArrowButton setImage:leftArrowImage forState:UIControlStateNormal];
    [lestArrowButton addTarget:self action:@selector(didTapLeftArrowButton:)
        forControlEvents:UIControlEventTouchUpInside];
    self.leftArrowButton.customView = lestArrowButton;
    
    // Initialize 'right arrow' button
    UIImage *rightArrowImage = [[UIImage imageNamed:@"right_arrow.png"]
        imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton *rightArrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightArrowButton.frame = toolBarIconFrame;
    [rightArrowButton setImage:rightArrowImage forState:UIControlStateNormal];
    [rightArrowButton addTarget:self action:@selector(didTapRightArrowButton:)
        forControlEvents:UIControlEventTouchUpInside];
    self.rightArrowButton.customView = rightArrowButton;
    
    // Initialize 'planet' button
    UIImage *planetImage = [[UIImage imageNamed:@"planet.png"]
        imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton *planetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    planetButton.frame = toolBarIconFrame;
    [planetButton setImage:planetImage forState:UIControlStateNormal];
    [planetButton addTarget:self action:@selector(didTapPlanetButton:)
        forControlEvents:UIControlEventTouchUpInside];
    self.planetButton.customView = planetButton;
    
    // Initialize 'star' button
    UIImage *starImage = [[UIImage imageNamed:@"star_empty.png"]
        imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton *starButton = [UIButton buttonWithType:UIButtonTypeCustom];
    starButton.frame = toolBarIconFrame;
    [starButton setImage:starImage forState:UIControlStateNormal];
    [starButton addTarget:self action:@selector(didTapEmptyStarButton:)
         forControlEvents:UIControlEventTouchUpInside];
    self.starButton.customView = starButton;
}

#pragma mark - Actions

- (IBAction)didTapLinkButton:(UIButton *)sender {
    ArticleWebVC *articleWebVC = [[ArticleWebVC alloc] initWithURL:self.article.link];
    articleWebVC.articleDetailsVC = self;
    [self.navigationController pushViewController:articleWebVC animated:YES];
}

- (void)didTapLeftArrowButton:(UIButton *)sender {
#warning resolve TODO mark
    // TODO: implement this
}

- (void)didTapRightArrowButton:(UIButton *)sender {
#warning resolve TODO mark
    // TODO: implement this
}

- (void)didTapPlanetButton:(UIButton *)sender {
    UIApplication *app = [UIApplication sharedApplication];
    if ([app canOpenURL:self.article.link]) {
        [app openURL:self.article.link];
    }
    else {
#warning resolve TODO mark
    // TODO: make correct handling
    }
}

- (void)didTapEmptyStarButton:(UIButton *)sender {
#warning resolve TODO mark
    // TODO: implement this
}

- (IBAction)didTapActionButton:(UIBarButtonItem *)sender {
#warning resolve TODO mark
    // TODO: implement this
}

@end
