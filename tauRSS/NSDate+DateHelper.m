#import "NSDate+DateHelper.h"


@implementation NSDate (DateHelper)

- (NSString *)convertToSpecialString {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"];
    
    NSDateComponents *selfDay = [[NSCalendar currentCalendar]
        components:NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay
        fromDate:self];
    NSDateComponents *today = [[NSCalendar currentCalendar]
        components:NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay
        fromDate:[NSDate date]];
        if ([today day] == [selfDay day] &&
            [today month] == [selfDay month] &&
            [today year] == [selfDay year] &&
            [today era] == [selfDay era]) {
            dateFormatter.timeStyle = NSDateFormatterShortStyle;
        }
        else {
            dateFormatter.dateStyle = NSDateFormatterShortStyle;
        }
    return [dateFormatter stringFromDate:self];
}

@end
