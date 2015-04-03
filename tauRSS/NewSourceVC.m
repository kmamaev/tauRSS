
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
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;


@property (nonatomic) BOOL isSourceAddressCorrect;
@property (nonatomic) CGSize contentSize;
@property (strong, nonatomic) UITextField *activeTextField;

- (IBAction)didTapAddSourceButton:(UIButton *)sender;
- (IBAction)doneEdittingSourceAddressTextField:(UITextField *)sender;
- (IBAction)doneEditingSourceNameTextField:(UITextField *)sender;
- (IBAction)didEditingBeginTextField:(UITextField *)sender;

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
    self.contentSize = self.scrollView.contentSize;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    
}

- (void)didTouchCancelBarButtonItem:(UIBarButtonItem *)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}



- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary* userInfo = [notification userInfo];
    
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    CGRect rect = self.contentView.frame;
    
    rect.size.height -= keyboardSize.height;
    self.contentView.frame = rect;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.scrollView.contentSize = self.contentSize;
    }];

    
}

- (void)keyboardWillShow:(NSNotification *)notification
{

    NSDictionary* userInfo = [notification userInfo];
    
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGRect rect = self.contentView.frame;
    rect.size.height += keyboardSize.height;
    self.contentView.frame = rect;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.scrollView.contentSize = self.contentView.frame.size;
        if ((self.activeTextField.frame.origin.y + self.activeTextField.frame.size.height) > (self.view.frame.size.height - keyboardSize.height))
        {
            CGPoint scrollPoint = CGPointMake(0.0, keyboardSize.height - self.activeTextField.frame.origin.y);
            [self.scrollView setContentOffset:scrollPoint animated:YES];
        }
    }];
}

- (void)orientationChanged:(NSNotification *)notification{
    self.scrollView.contentSize = self.contentView.frame.size;
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
    
    self.activeTextField = nil;
    [sender resignFirstResponder];
}

- (IBAction)doneEditingSourceNameTextField:(UITextField *)sender
{
    self.activeTextField = nil;
    [sender resignFirstResponder];
}

- (IBAction)didEditingBeginTextField:(UITextField *)sender
{
    self.activeTextField = sender;
}


-(void)dismissKeyboard {
    [self.sourceAddressTextField resignFirstResponder];
    [self.sourceNameTextField resignFirstResponder];
}

@end
