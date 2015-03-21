#import <Foundation/Foundation.h>


@interface NSDate (DateHelper)

/**
 *  Convert date to short format in accordance with condition if the day is today. If the day is
 *  today returns only hours and minutes or day, month and year otherwise.
 *  Examples: 12:51 (if today); 21.03.15  (if not today).
 */
- (NSString *)convertToShortString;

/**
 *  Convert date to string containing day, month, year, hours and minutes.
 *  Example: 21.03.15, 12:51
 */
- (NSString *)convertToLongString;

@end
