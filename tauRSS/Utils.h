#import <Foundation/Foundation.h>


@interface Utils : NSObject

/**
 *  Shows informational alert view with the specified title and description and only "Close" button
 */
+ (void)showInfoAlertWithTitle:(NSString *)title
    description:(NSString *)description
    delegate:(id)delegate;

@end
