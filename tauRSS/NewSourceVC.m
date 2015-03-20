
#import "NewSourceVC.h"

@interface NewSourceVC ()

@end

@implementation NewSourceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.navigationItem) {
        UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                              target:self
                                              action:@selector(didTouchCancelBarButtonItem:)];
        [self.navigationItem setLeftBarButtonItem:cancelBarButtonItem];
        self.navigationItem.title = @"Добавить источник";
    }
}

- (void)didTouchCancelBarButtonItem:(UIBarButtonItem *)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


@end
