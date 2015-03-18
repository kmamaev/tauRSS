#import "ArticleWebVC.h"


@interface ArticleWebVC ()

@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end


@implementation ArticleWebVC

- initWithURL:(NSURL *)url {
    self = [super init];
    if (self != nil) {
        _url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:urlRequest];
}

- (IBAction)didTapSafariButton:(UIButton *)sender {
    UIApplication *app = [UIApplication sharedApplication];
    
    if ([app canOpenURL:self.url]) {
        [app openURL:self.url];
    }
}

@end
