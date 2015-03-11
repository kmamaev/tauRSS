#import "Article.h"


@implementation Article

- (instancetype)initWithTitle:(NSString *)title
                      link:(NSURL *)link
               description:(NSString *)articleDescription
                  category:(NSString *)category
                  imageURL:(NSURL *)imageURL
               publishDate:(NSDate *)publishDate {
    self = [self init];
    if (self != nil) {
        _title = title;
        _link = link;
        _articleDescription = articleDescription;
        _category = category;
        _imageURL = imageURL;
        _publishDate = publishDate;
    }
    return self;
}

@end
