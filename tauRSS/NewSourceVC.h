
#import <UIKit/UIKit.h>
@class NewSourceVC;
@class Source;

@protocol NewSourceDelegate <NSObject>

- (void)newSourceViewController:(NewSourceVC *)sender didFinishWithSource:(Source *)sourse;

@end

@interface NewSourceVC : UIViewController

@property (nonatomic, weak) id<NewSourceDelegate> delegate;

@end
