//
//  NSDate+toString.m
//  CoreMainDemo
//
//  Created by 郑红 on 10/03/2017.
//  Copyright © 2017 zhenghong. All rights reserved.
//

#import "NSDate+toString.h"

static NSDateFormatter * DateFormatter;
static NSCalendar * DateCalendar;

@implementation NSDate (toString)


- (NSString*)toMailString {
    if (DateCalendar == nil) {
        DateCalendar = [NSCalendar currentCalendar];
    }
    
    if ([DateCalendar isDateInToday:self]) {
        NSInteger hour = [DateCalendar component:NSCalendarUnitHour fromDate:self];
        NSInteger minute = [DateCalendar component:NSCalendarUnitMinute fromDate:self];
        NSString * description;
        if (hour < 12) {
            description = @"上午";
        } else {
            description = @"下午";
        }
        
        return [description stringByAppendingFormat:@" %ld:%ld",(long)hour,(long)minute];
    } else if ([DateCalendar isDateInYesterday:self]) {
        return @"昨天";
    }
//    else
//        if ([DateCalendar isDateInWeekend:self]) {
//        return <#expression#>
//    }

    return [self toString];
}

- (NSString*)toString {
    return [self toString:@"yyyy/MM/dd"];
}

- (NSString*)toString:(NSString *)formatter {
    if (DateFormatter == nil) {
        DateFormatter = [[NSDateFormatter alloc] init];
    }
    [DateFormatter setDateFormat:formatter];
    return [DateFormatter stringFromDate:self];
}


@end
