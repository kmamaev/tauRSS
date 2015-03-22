
#import "NewSourceVC.h"
#import "Source.h"

@interface NewSourceVC ()

@property (strong, nonatomic) IBOutlet UITextField *sourceAddressTextField;
@property (strong, nonatomic) IBOutlet UITextField *sourceNameTextField;
@property (strong, nonatomic) IBOutlet UIImageView *sourceStatusImageView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *checkingIndicator;
@property (strong, nonatomic) IBOutlet UILabel *sourceAddressLable;
@property (strong, nonatomic) IBOutlet UILabel *sourceNameLable;
@property (strong, nonatomic) IBOutlet UIButton *addSourceButton;


@property (nonatomic) BOOL isSourceAddressCorrect;

- (IBAction)didTapAddSourceButton:(UIButton *)sender;
- (IBAction)doneEdittingSourceAddressTextField:(UITextField *)sender;
- (IBAction)doneEditingSourceNameTextField:(UITextField *)sender;
- (IBAction)didBeginEditingSourceNameTextField:(UITextField *)sender;

@end

@implementation NewSourceVC

- (instancetype)init
{
    if (self = [super init])
    {
        _isSourceAddressCorrect = NO;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.navigationItem) {
        UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                              target:self
                                              action:@selector(didTouchCancelBarButtonItem:)];
        [self.navigationItem setLeftBarButtonItem:cancelBarButtonItem];
        self.navigationItem.title = NSLocalizedString(@"addSource", );
    }
    self.sourceAddressLable.text = NSLocalizedString(@"enterRSSaddress", );
    self.sourceNameLable.text = NSLocalizedString(@"sourceName", );
    self.addSourceButton.titleLabel.text = NSLocalizedString(@"add", );
    self.sourceNameTextField.placeholder = NSLocalizedString(@"newSource", );
}

- (void)didTouchCancelBarButtonItem:(UIBarButtonItem *)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}



#define kOFFSET_FOR_KEYBOARD 80.0


//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

#pragma mark - Actions

- (IBAction)didTapAddSourceButton:(UIButton *)sender
{
    if ((self.isSourceAddressCorrect == YES) && (self.sourceNameTextField.text !=nil))
    {
        Source *source = [[Source alloc]init];
        source.title = self.sourceNameTextField.text;
        
        NSMutableString *stringURL = [@"http://" mutableCopy];
        [stringURL appendString:self.sourceAddressTextField.text];
        NSURL *sourceURL = [NSURL URLWithString:stringURL];
        
        source.sourceURL = sourceURL;
        
        [self.delegate newSourceViewController:self didFinishWithSource:source];
    }
    else
    {
        
    }
}

- (IBAction)doneEdittingSourceAddressTextField:(UITextField *)sender
{
    [self.checkingIndicator startAnimating];
    self.sourceStatusImageView.hidden = YES;
    
    
    #warning resolve TODO mark
    // TODO: send a check request
    
    [sender resignFirstResponder];
}

- (IBAction)doneEditingSourceNameTextField:(UITextField *)sender
{
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        [self setViewMovedUp:NO];
    }
    [sender resignFirstResponder];
}

- (IBAction)didBeginEditingSourceNameTextField:(UITextField *)sender
{
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        [self setViewMovedUp:YES];
    }
}
@end
