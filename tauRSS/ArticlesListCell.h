#import <UIKit/UIKit.h>


@interface ArticlesListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *articleImageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;
@property (strong, nonatomic) NSURL *urlForImage;

@end
