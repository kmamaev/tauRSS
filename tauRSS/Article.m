#import "Article.h"


@implementation Article

- (instancetype)initWithTitle:(NSString *)title
    link:(NSURL *)link
    description:(NSString *)articleDescription
    category:(NSString *)category
    imageURL:(NSURL *)imageURL
    publishDate:(NSDate *)publishDate
{
    self = [self init];
    if (self != nil) {
        _title = [title copy];
        _link = link;
        _articleDescription = [articleDescription copy];
        _category = [category copy];
        _imageURL = imageURL;
        _publishDate = publishDate;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: {"
            "\n\ttitle: %@,"
            "\n\tlink: %@,"
            "\n\tdescription: %@,"
            "\n\tcategory: %@,"
            "\n\timage URL: %@,"
            "\n\tpublish date: %@"
        "\n}>",
        NSStringFromClass([self class]),
        self.title,
        self.link.absoluteString,
        self.articleDescription,
        self.category,
        self.imageURL.absoluteString,
        self.publishDate];
}

@end
