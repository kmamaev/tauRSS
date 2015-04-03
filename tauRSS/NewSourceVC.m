
#import "NewSourceVC.h"
#import "Source.h"
#import <AFHTTPRequestOperationManager.h>
#import "AlertUtils.h"

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
    self.checkingIndicator.hidden = YES;
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
    if ((self.isSourceAddressCorrect == YES) && (self.sourceNameTextField.text !=nil || [self.sourceNameTextField.text isEqual:@""]))
    {
        Source *source = [[Source alloc]init];
        source.title = self.sourceNameTextField.text;
        
        NSString *stringURL = [NSString stringWithFormat:@"http://%@", self.sourceAddressTextField.text];
        NSURL *sourceURL = [NSURL URLWithString:stringURL];
        
        source.sourceURL = sourceURL;
        
        [self.delegate newSourceViewController:self didFinishWithSource:source];
    }
    else
    {
        showInfoAlert(NSLocalizedString(@"errorAdditionSource",), NSLocalizedString(@"AllFieldMustBeFilled",), self);
    }
}

- (IBAction)doneEdittingSourceAddressTextField:(UITextField *)sender
{
    self.checkingIndicator.hidden = NO;
    [self.checkingIndicator startAnimating];
    self.sourceStatusImageView.hidden = YES;
    NSString *stringURL = [NSString stringWithFormat:@"http://%@", self.sourceAddressTextField.text];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =
    [NSSet setWithObject:@"application/rss+xml"];
    [manager GET:stringURL
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             self.isSourceAddressCorrect = YES;
             [self.checkingIndicator stopAnimating];
             self.checkingIndicator.hidden = YES;
             UIImage *correctImage = [UIImage imageNamed:@"correct.png"];
             self.sourceStatusImageView.image = correctImage;
             self.sourceStatusImageView.hidden = NO;
             
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             self.isSourceAddressCorrect = NO;
             [self.checkingIndicator stopAnimating];
             self.checkingIndicator.hidden = YES;
             UIImage *errorImage = [UIImage imageNamed:@"error.png"];
             self.sourceStatusImageView.image = errorImage;
             self.sourceStatusImageView.hidden = NO;
             
         }];
    
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
