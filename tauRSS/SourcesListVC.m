#import "SourcesListVC.h"
#import "IIViewDeckController.h"


@interface SourcesListVC ()

@property (nonatomic, strong) NSArray *sources;

@end


@implementation SourcesListVC

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.sources = @[@"",
                         @"",
                         @"Все новости",
                         @"Закладки",
                         @"",
                         @"Лента RSS",
                         @"НГС RSS",
                         @"Яндекс RSS"];
        self.articlesListVC = [[ArticlesListVC alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:@"reuseID1"];
    cell.textLabel.text = self.sources[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)ip {
    // TODO: send to articlesVC updated articles list    
    [self.viewDeckController closeLeftViewAnimated:YES];
}

@end
