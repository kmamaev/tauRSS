#import "ArticleWebVC.h"
#import "ArticleDetailsVC.h"
#import "AlertUtils.h"
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>


@interface ArticleWebVC ()

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *planetButton;

@end


@implementation ArticleWebVC

#pragma mark - Initialization

- (instancetype)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self != nil) {
        _url = url;
    }
    return self;
}

#pragma mark - View's lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:urlRequest];
    
    // Initialize 'planet' button
    UIImage *planetImage = [[UIImage imageNamed:@"planet.png"]
        imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton *planetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    planetButton.frame = (CGRect){0, 0, 30, 30};
    [planetButton setImage:planetImage forState:UIControlStateNormal];
    [planetButton addTarget:self.articleDetailsVC action:@selector(didTapPlanetButton:)
        forControlEvents:UIControlEventTouchUpInside];
    self.planetButton.customView = planetButton;
}

#pragma mark - Actions

- (void)didTapPlanetButton:(UIButton *)sender
{
    [self.articleDetailsVC didTapPlanetButton:sender];
}

#pragma mark - UIWebView delegate methods

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    showInfoAlert(NSLocalizedString(@"errorLoadingPage",), error.localizedDescription, self);
    [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
}

#pragma mark - Dealloc

- (void)dealloc
{
    [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
}

@end
