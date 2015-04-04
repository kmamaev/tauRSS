#import "SettingsVC.h"
#import "SettingsSwitchCell.h"
#import "AboutVC.h"


static NSString *const kSectionTitle = @"SectionTitle";
static NSString *const kSectionItems = @"SectionItems";

static NSString *const reuseIDCell = @"ReuseID";

typedef NS_ENUM(NSInteger, Sections) {
    sectionClear = 0,
    sectionAbout = 1
};


@interface SettingsVC () <UITableViewDataSource, UITableViewDelegate> {
    NSString *_aboutItem;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *sections;

@end

@implementation SettingsVC

- (instancetype)init
{
    if(self = [super init])
    {
        NSDictionary *sectionClear =
            @{kSectionTitle: @"",
              kSectionItems: @[NSLocalizedString(@"clearCache", )]};
        
        
        _aboutItem = NSLocalizedString(@"about", );
        NSDictionary *sectionAbout =
        @{kSectionTitle: @"",
          kSectionItems: @[_aboutItem]};
        
        _sections = @[sectionClear, sectionAbout];
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.navigationItem) {
        UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                              target:self
                                              action:@selector(didTouchDoneBarButtonItem:)];
        [self.navigationItem setRightBarButtonItem:doneBarButtonItem];
        self.navigationItem.title = NSLocalizedString(@"settings", );
    }
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
        style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)didTouchDoneBarButtonItem:(UIBarButtonItem *)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *sectionDict = self.sections[section];
    return ((NSArray *)sectionDict[kSectionItems]).count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *sectionDict = self.sections[section];
    return sectionDict[kSectionTitle];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *section = self.sections[indexPath.section];
    NSString *title = (section[kSectionItems])[indexPath.row];

        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIDCell];
        cell.textLabel.text = title;
        NSString *selectedItem = section[kSectionItems][indexPath.row];
        if (selectedItem == _aboutItem) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *section = self.sections[indexPath.section];
    NSString *selectedItem = section[kSectionItems][indexPath.row];
    if (selectedItem == _aboutItem) {
        AboutVC *aboutVC = [[AboutVC alloc] init];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }
}

@end
