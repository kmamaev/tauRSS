

#import "SettingsVC.h"
#import "SettingsSwitchCell.h"

static NSString *const kSectionTitle = @"SectionTitle";
static NSString *const kSectionItems = @"SectionItems";

static NSString *const reuseIDswitchCell = @"SettingsSwitchCell";

typedef NS_ENUM(NSInteger, Sections) {
    sectionClear = 0,
    sectionReading = 1,
    sectionAbout = 2
};

typedef NS_ENUM(NSInteger, ReadingSettings) {
    darkMode = 0,
    fontSelect = 1
};

@interface SettingsVC () <UITableViewDataSource, UITableViewDelegate>
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
        
        NSDictionary *sectionReading =
            @{kSectionTitle: NSLocalizedString(@"reading", ),
              kSectionItems: @[NSLocalizedString(@"darkMode", ), NSLocalizedString(@"fontSize", )]};
        
        NSDictionary *sectionAbout =
        @{kSectionTitle: @"",
          kSectionItems: @[NSLocalizedString(@"about", )]};
        
        _sections = @[sectionClear, sectionReading, sectionAbout];
        
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
    
    [self.tableView
     registerNib:[UINib nibWithNibName:NSStringFromClass([SettingsSwitchCell class])
                                bundle:[NSBundle mainBundle]]
     forCellReuseIdentifier:reuseIDswitchCell];
    
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

#define REUSABLE_CELL_ID @"ReuseID"

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *section = self.sections[indexPath.section];
    NSString *title = (section[kSectionItems])[indexPath.row];
    
    if ((indexPath.section == sectionReading) && (indexPath.row == darkMode))
    {
        SettingsSwitchCell *switchCell = [self.tableView dequeueReusableCellWithIdentifier:reuseIDswitchCell];
        switchCell.titleLabel.text = title;
        switchCell.cellSwitch.on = NO;
        
        return switchCell;
    }
    else
    {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:REUSABLE_CELL_ID];
        cell.textLabel.text = title;
    
        return cell;
    }
}


@end
