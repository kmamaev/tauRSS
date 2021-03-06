#import "ArticleDetailsVC.h"
#import "ArticleWebVC.h"
#import "Source.h"
#import "AlertUtils.h"
#import "ArticlesListCell.h"
#import "ArticlesListVC.h"
#import <UIImageView+AFNetworking.h>


static float const defaultImageHeight = 180.0f;


@interface ArticleDetailsVC () {
    UIButton *_leftArrow;
    UIButton *_rightArrow;
}

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

- (instancetype)initWithArticle:(Article *)article
{
    self = [self init];
    if (self != nil) {
        _article = article;
    }
    return self;
}

#pragma mark - View's lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // Initialize article's title, info, description and image
    [self setUpArticle:self.article];
    
    // Initialize toolbar items
    [self initializeToolbarItems];
    
    // Set up index and disable "left/right" toolbar buttons if needed
    self.index = [self.articlesListVC.source.articles indexOfObject:self.article];
    [self setUpLeftRightButtonsStates];
}

- (void)initializeToolbarItems
{
    CGRect toolBarIconFrame = (CGRect){0, 0, 30, 30};
    
    // Initialize 'left arrow' button
    UIImage *leftArrowImage = [[UIImage imageNamed:@"left_arrow.png"]
        imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _leftArrow = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftArrow.frame = toolBarIconFrame;
    [_leftArrow setImage:leftArrowImage forState:UIControlStateNormal];
    [_leftArrow addTarget:self action:@selector(didTapArrowButton:)
        forControlEvents:UIControlEventTouchUpInside];
    self.leftArrowButton.customView = _leftArrow;
    
    // Initialize 'right arrow' button
    UIImage *rightArrowImage = [[UIImage imageNamed:@"right_arrow.png"]
        imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _rightArrow = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightArrow.frame = toolBarIconFrame;
    [_rightArrow setImage:rightArrowImage forState:UIControlStateNormal];
    [_rightArrow addTarget:self action:@selector(didTapArrowButton:)
        forControlEvents:UIControlEventTouchUpInside];
    self.rightArrowButton.customView = _rightArrow;
    
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

- (void)didTapArrowButton:(UIButton *)sender
{
    if (sender == _leftArrow) {
        self.index--;
    }
    else if (sender == _rightArrow) {
        self.index++;
    }
    [self setUpLeftRightButtonsStates];
    [self setUpArticle:self.articlesListVC.source.articles[self.index]];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.index inSection:0];
    [self.articlesListVC.articlesTableView scrollToRowAtIndexPath:indexPath
        atScrollPosition:UITableViewScrollPositionTop animated:NO];
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
    if (self.articlesListVC.source.sourceId == sourceIdFavorites) {
        [self.articlesListVC.articlesTableView reloadData];
    }
}

- (IBAction)didTapActionButton:(UIBarButtonItem *)sender
{
    NSMutableArray *activityItems = [@[self.article.title, self.article.link] mutableCopy];
    if (self.articleImageView.image) {
        [activityItems addObject:self.articleImageView.image];
    }
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]
        initWithActivityItems:activityItems applicationActivities:nil];
    
    activityViewController.excludedActivityTypes = @[
        UIActivityTypePostToWeibo,
        UIActivityTypeMessage,
        UIActivityTypeMail,
        UIActivityTypePrint,
        UIActivityTypeCopyToPasteboard,
        UIActivityTypeAssignToContact,
        UIActivityTypeSaveToCameraRoll,
        UIActivityTypeAddToReadingList,
        UIActivityTypePostToFlickr,
        UIActivityTypePostToVimeo,
        UIActivityTypePostToTencentWeibo,
        UIActivityTypeAirDrop
    ];
    
    [self.navigationController presentViewController:activityViewController
        animated:YES
        completion:nil];
}

#pragma mark - Auxiliaries

- (void)setUpArticle:(Article *)article
{
    // Set up article property
    self.article = article;
    
    // Set read state
    if (!article.isRead) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.index inSection:0];
        [self.articlesListVC setRead:YES forArticle:article atIndexPath:indexPath];
    }
    
    // Initialize article's title, info and description
    self.titleLabel.text = article.title;
    NSMutableAttributedString *attributedDescription = [[NSMutableAttributedString alloc]
        initWithString:article.articleDescription];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4.0f;
    [attributedDescription addAttribute:NSParagraphStyleAttributeName
        value:paragraphStyle
        range:NSMakeRange(0, article.articleDescription.length)];
    self.descriptionLabel.attributedText = attributedDescription;
    self.infoLabel.text = [Article buildLongArticleInfo:article];
    
    // Set up image height
    self.imageHeight.constant = article.imageURL == nil ? 0.0f : defaultImageHeight;
    
    // Initialize article image
    [self.articleImageView setImageWithURL:article.imageURL
        placeholderImage:[ArticlesListCell placeholderImage]];
}

- (void)setUpLeftRightButtonsStates
{
    NSInteger articlesCount = self.articlesListVC.source.articles.count;
    self.leftArrowButton.enabled = self.index == 0 ? NO : YES;
    self.rightArrowButton.enabled = self.index == articlesCount - 1 ? NO : YES;
}

@end
