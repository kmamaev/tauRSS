#import "ArticleDetailsVC.h"


@interface ArticleDetailsVC ()
@end


@implementation ArticleDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){10, 100, 300, 50}];
    label.text = @"Доллар подорожал";
    [self.view addSubview:label];
}

@end
