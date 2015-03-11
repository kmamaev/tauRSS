#import "ArticlesListVC.h"
#import "IIViewDeckController.h"


@interface ArticlesListVC ()

@property (nonatomic, strong) NSArray *articles;

@end


@implementation ArticlesListVC

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.articles = @[@"Доллар подорожал",
                          @"Выпало рекордное количество снега",
                          @"13ый трамвай устроил дтп",
                          @"Apple продали много iphone'ов",
                          @"Президент подписал указ"];
    }
    return self;
}

- (void)viewDidLoad {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@"left"
                                             style:UIBarButtonItemStylePlain
                                             target:self.viewDeckController
                                             action:@selector(toggleLeftView)];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.articles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:@"reuseID2"];
    cell.textLabel.text = self.articles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)ip {
    [self.navigationController pushViewController:[[ArticleDetailsVC alloc] init] animated:YES];
}

@end
