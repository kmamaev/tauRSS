#import "AppDelegate.h"
#import "SourcesListVC.h"
#import "ArticlesListVC.h"
#import "IIViewDeckController.h"


@interface AppDelegate ()
@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
                                     didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    CGRect windowFrame = [UIScreen mainScreen].bounds;
    self.window = [[UIWindow alloc] initWithFrame:windowFrame];
    
    SourcesListVC *sourcesListVC = [[SourcesListVC alloc] init];
    ArticlesListVC *articlesListVC = sourcesListVC.articlesListVC;
    
    UINavigationController *centerController = [[UINavigationController alloc]
                                                initWithRootViewController:articlesListVC];
    
    IIViewDeckController* deckController = [[IIViewDeckController alloc]
                                            initWithCenterViewController:centerController
                                            leftViewController:sourcesListVC];
    
    // Show sources list view at start by default
    [deckController openLeftViewAnimated:NO];

    self.window.rootViewController = deckController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end