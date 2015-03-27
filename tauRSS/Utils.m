#import "Utils.h"
#import <UIKit/UIKit.h>
#import "NSDate+DateHelper.h"
#import "Source.h"


@implementation Utils

+ (void)showInfoAlertWithTitle:(NSString *)title
    description:(NSString *)description
    delegate:(id)delegate
{
    NSString *cancelButtonTitle = NSLocalizedString(@"close",);
    if ([UIAlertController class]) {
        UIAlertController *alert = [UIAlertController
            alertControllerWithTitle:title
            message:description
            preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *closeAlert = [UIAlertAction
            actionWithTitle:cancelButtonTitle
            style:UIAlertActionStyleDefault
            handler:nil];
        [alert addAction:closeAlert];
        [delegate presentViewController:alert animated:YES completion:nil];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc]
            initWithTitle:title
            message:description
            delegate:delegate
            cancelButtonTitle:cancelButtonTitle
            otherButtonTitles:nil];
        [alertView show];
    }
}

+ (NSString *)buildShortArticleInfo:(Article *)article
{
    NSMutableString *articleInfo = [[NSMutableString alloc] initWithString:@""];
    if (article.publishDate) {
        [articleInfo appendString:[article.publishDate shortString]];
    }
    if (article.category) {
        [articleInfo appendFormat:@"・%@", article.category];
    }
    if (article.source.title) {
        [articleInfo appendFormat:@"・%@", article.source.title];
    }
    return articleInfo;
}

+ (NSString *)buildLongArticleInfo:(Article *)article
{
    NSMutableString *articleInfo = [[NSMutableString alloc] initWithString:@""];
    if (article.publishDate) {
        [articleInfo appendString:[article.publishDate longString]];
    }
    if (article.category) {
        [articleInfo appendFormat:@"・%@", article.category];
    }
    if (article.source.title) {
        [articleInfo appendFormat:@"・%@", article.source.title];
    }
    return articleInfo;
}

@end
