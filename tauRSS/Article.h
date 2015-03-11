#import <Foundation/Foundation.h>


@interface Article : NSObject

@property (nonatomic, copy) NSString *articleId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSURL *link;
@property (nonatomic, copy) NSString *articleDescription;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, assign) BOOL isRead;
@property (nonatomic, assign) BOOL isFavorite;
@property (nonatomic, strong) NSDate *publishDate;

@end
