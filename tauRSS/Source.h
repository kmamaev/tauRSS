#import <Foundation/Foundation.h>


@interface Source : NSObject

@property (nonatomic, copy) NSString *sourceId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray *articles;
@property (nonatomic, strong) NSURL *iconURL;
@property (nonatomic, strong) NSURL *sourceURL;

- (instancetype)initWithTitle:(NSString *)title;

@end
