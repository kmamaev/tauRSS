#import "AboutVC.h"


@interface AboutVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *authors;

@end


@implementation AboutVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _authors = @[NSLocalizedString(@"konstantin",), NSLocalizedString(@"aleksandr",)];
        self.title = NSLocalizedString(@"aboutApp",);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // Initialize app name and version
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    NSString *appVersion = [[NSBundle mainBundle]
        objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    self.titleLabel.text = [NSString stringWithFormat:@"%@ %@", appName, appVersion];
    
    // Initialize app description
    NSString *appDescription = [NSString stringWithFormat: @"%@ «%@» %@",
        NSLocalizedString(@"application",), appName, NSLocalizedString(@"appDescription",)];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
        initWithString:appDescription];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4.0f;
    [attributedString addAttribute:NSParagraphStyleAttributeName
        value:paragraphStyle
        range:NSMakeRange(0, appDescription.length)];
    self.descriptionLabel.attributedText = attributedString;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.authors.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return NSLocalizedString(@"authors",);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 32.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = self.authors[indexPath.row];
    return cell;
}

@end
