#import "AppDelegate.h"
#import "SourcesListVC.h"
#import "ArticlesListVC.h"
#import "IIViewDeckController.h"
#import <AFNetworkActivityIndicatorManager.h>


@interface AppDelegate ()
@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
                                     didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    CGRect windowFrame = [UIScreen mainScreen].bounds;
    self.window = [[UIWindow alloc] initWithFrame:windowFrame];
    
    // Set up activity indicator
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    // Set base color for the application
    self.window.tintColor = [UIColor orangeColor];
    
    // Initialize deck with sources list screen and articles list screen
    SourcesListVC *sourcesListVC = [[SourcesListVC alloc] init];
    ArticlesListVC *articlesListVC = sourcesListVC.articlesListVC;
    
    UINavigationController *centerController = [[UINavigationController alloc]
                                                initWithRootViewController:articlesListVC];
    
    UINavigationController *leftController = [[UINavigationController alloc]
                                                initWithRootViewController:sourcesListVC];
    
    IIViewDeckController* deckController = [[IIViewDeckController alloc]
                                            initWithCenterViewController:centerController
                                            leftViewController:leftController];
    
    // Show sources list view at start by default
    [deckController openLeftViewAnimated:NO];

    self.window.rootViewController = deckController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end