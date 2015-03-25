#import "NSDate+DateHelper.h"


@implementation NSDate (DateHelper)

- (NSString *)shortString {
    static NSDateFormatter *dateFormatterShortStyle = nil;
    if (!dateFormatterShortStyle) {
        dateFormatterShortStyle = [[NSDateFormatter alloc] init];
    }
    dateFormatterShortStyle.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"];
    
    static NSCalendar *calendar = nil;
    if (!calendar) {
        calendar = [NSCalendar currentCalendar];
    }
    
    NSDateComponents *selfDay = [calendar
        components:NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay
        fromDate:self];
    NSDateComponents *today = [calendar
        components:NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay
        fromDate:[NSDate date]];
        if ([today day] == [selfDay day] &&
            [today month] == [selfDay month] &&
            [today year] == [selfDay year] &&
            [today era] == [selfDay era]) {
            dateFormatterShortStyle.timeStyle = NSDateFormatterShortStyle;
            dateFormatterShortStyle.dateStyle = NSDateFormatterNoStyle;
        }
        else {
            dateFormatterShortStyle.dateStyle = NSDateFormatterShortStyle;
            dateFormatterShortStyle.timeStyle = NSDateFormatterNoStyle;
        }
    return [dateFormatterShortStyle stringFromDate:self];
}

- (NSString *)longString {
    static NSDateFormatter *dateFormatterLongStyle = nil;
    if (!dateFormatterLongStyle) {
        dateFormatterLongStyle = [[NSDateFormatter alloc] init];
    }
    dateFormatterLongStyle.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"];
    dateFormatterLongStyle.timeStyle = NSDateFormatterShortStyle;
    dateFormatterLongStyle.dateStyle = NSDateFormatterShortStyle;
    return [dateFormatterLongStyle stringFromDate:self];
}

@end
