#import "ArticleDetailsVC.h"
#import "ArticleWebVC.h"
#import "Source.h"
#import "AlertUtils.h"
#import <UIImageView+AFNetworking.h>


@interface ArticleDetailsVC ()

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UIImageView *articleImageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *leftArrowButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *rightArrowButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *planetButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *starButton;

@end


@implementation ArticleDetailsVC

#pragma mark - Initialization

- (instancetype)initWithArticle:(Article *)article image:(UIImage *)articleImage
{
    self = [self init];
    if (self != nil) {
        _article = article;
        _articleImage = articleImage;
    }
    return self;
}

#pragma mark - View's lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // Initialize article's title, info and description
    self.titleLabel.text = self.article.title;
    self.descriptionLabel.text = self.article.articleDescription;
    self.infoLabel.text = [Article buildLongArticleInfo:self.article];
    
    if (self.article.imageURL == nil) {
        self.imageHeight.constant = 0.0f;
    }
    
    // Initialize article image
    if (self.articleImage) {
        self.articleImageView.image = self.articleImage;
    }
    else {
        [self.articleImageView setImageWithURL:self.article.imageURL];
    }
    
    // Initialize toolbar items
    [self initializeToolbarItems];
}

- (void)initializeToolbarItems
{
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
    UIImage *starImage;
    
    if (self.article.isFavorite == NO)
    {
        starImage = [[UIImage imageNamed:@"star_empty.png"]
                              imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    else
    {
        starImage = [[UIImage imageNamed:@"star_filled.png"]
                              imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
    UIButton *starButton = [UIButton buttonWithType:UIButtonTypeCustom];
    starButton.frame = toolBarIconFrame;
    [starButton setImage:starImage forState:UIControlStateNormal];
    [starButton addTarget:self action:@selector(didTapEmptyStarButton:)
         forControlEvents:UIControlEventTouchUpInside];
    self.starButton.customView = starButton;
}

#pragma mark - Actions

- (IBAction)didTapLinkButton:(UIButton *)sender
{
    ArticleWebVC *articleWebVC = [[ArticleWebVC alloc] initWithURL:self.article.link];
    articleWebVC.articleDetailsVC = self;
    [self.navigationController pushViewController:articleWebVC animated:YES];
}

- (void)didTapLeftArrowButton:(UIButton *)sender
{
#warning resolve TODO mark
    // TODO: implement this
}

- (void)didTapRightArrowButton:(UIButton *)sender
{
#warning resolve TODO mark
    // TODO: implement this
}

- (void)didTapPlanetButton:(UIButton *)sender
{
    UIApplication *app = [UIApplication sharedApplication];
    if ([app canOpenURL:self.article.link]) {
        [app openURL:self.article.link];
    }
    else {
        showInfoAlert(NSLocalizedString(@"cantOpenUrlTitle",),
            NSLocalizedString(@"cantOpenUrlDescription",),
            self);
    }
}

- (void)didTapEmptyStarButton:(UIButton *)sender
{
    ArticlesController *articlesController = [ArticlesController sharedInstance];
    [articlesController setFavorite:!(self.article.isFavorite) forArticle:self.article];
    
    UIImage *starImage;
    
    if (self.article.isFavorite == NO)
    {
        starImage = [[UIImage imageNamed:@"star_empty.png"]
                     imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    else
    {
        starImage = [[UIImage imageNamed:@"star_filled.png"]
                     imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    [(UIButton *)self.starButton.customView setImage:starImage forState:UIControlStateNormal];
}

- (IBAction)didTapActionButton:(UIBarButtonItem *)sender
{
#warning resolve TODO mark
    // TODO: implement this
}

@end
