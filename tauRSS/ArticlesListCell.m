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
    self.articleImageView.image = [[self class] placeholderImage];
    [self setStyle:CellStyleNormal];
}

+ (UIImage *)placeholderImage
{
    static UIImage *placeholderImage = nil;
    if (!placeholderImage) {
        placeholderImage = [UIImage imageNamed:@"image_placeholder.png"];
    }
    return placeholderImage;
}

- (void)setStyle:(CellStyle)cellStyle
{
    if (cellStyle == CellStyleMuted) {
        static UIColor *mutedColor = nil;
        if (!mutedColor) {
            mutedColor = [UIColor lightGrayColor];
        }
        self.titleLabel.textColor = mutedColor;
        self.descriptionLabel.textColor = mutedColor;
        self.infoLabel.textColor = mutedColor;
        self.articleImageView.alpha = 0.5f;
    }
    else if (cellStyle == CellStyleNormal) {
        static UIColor *titleColor = nil;
        static UIColor *desriptionColor = nil;
        static UIColor *infoColor = nil;
        if (!titleColor) {
            titleColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f];
        }
        if (!desriptionColor) {
            desriptionColor = [UIColor colorWithRed:0.25f green:0.25f blue:0.25f alpha:1.0f];
        }
        if (!infoColor) {
            infoColor = [UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1.0f];
        }
        self.titleLabel.textColor = titleColor;
        self.descriptionLabel.textColor = desriptionColor;
        self.infoLabel.textColor = infoColor;
        self.articleImageView.alpha = 1.0f;
    }
}

@end
