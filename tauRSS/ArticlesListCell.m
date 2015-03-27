#import "ArticlesListCell.h"
#import <UIImageView+AFNetworking.h>


@implementation ArticlesListCell

- (void)setUrlForImage:(NSURL *)urlForImage
{
    if (urlForImage == nil) {
        self.imageWidth.constant = 0.0f;
    }
    else {
        [self.articleImageView setImageWithURL:urlForImage];
    }
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    static UIImage *placeholderImage = nil;
    if (!placeholderImage) {
        placeholderImage = [UIImage imageNamed:@"image_placeholder.png"];
    }
    self.articleImageView.image = placeholderImage;
}

@end
