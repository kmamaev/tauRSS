#import <Foundation/Foundation.h>


@interface Article : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSURL *link;
@property (nonatomic, copy) NSString *articleDescription;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) NSDate *publishDate;
@property (nonatomic, assign) BOOL isRead;
@property (nonatomic, assign) BOOL isFavorite;

- (instancetype)initWithTitle:(NSString *)title
                      link:(NSURL *)link
               description:(NSString *)articleDescription
                  category:(NSString *)category
                  imageURL:(NSURL *)imageURL
               publishDate:(NSDate *)publishDate;

@end
