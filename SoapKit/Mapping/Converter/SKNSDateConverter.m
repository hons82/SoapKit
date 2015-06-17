//
//  SKNSDateConverter.m
//  SoapKit
//
//  Created by Hannes Tribus on 15/10/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import "SKNSDateConverter.h"
#import "SKDynamicAttribute.h"

@interface SKNSDateConverter()
@property(nonatomic, strong) NSString *pattern;
- (BOOL) validDouble: (NSString *) doubleValue;
@end

@implementation SKNSDateConverter
@synthesize pattern = _pattern;


+ (SKNSDateConverter *) dateConverterForPattern: (NSString *) pattern{
    return [[self alloc] initWithDatePattern: pattern];
}

- (id) initWithDatePattern: (NSString *) pattern {
    self = [super init];
    if (self) {
        _pattern = pattern;
    }
    return self;
}

- (id)transformValue:(id)value forDynamicAttribute:(SKDynamicAttribute *)attribute data:(SKData *)data parentObject:(id)parentObject {
    BOOL validDouble = [self validDouble:[NSString stringWithFormat:@"%@", value]];
    if(validDouble){
        return [NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
    }else{
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = self.pattern;
        return [formatter dateFromString:value];
    }
}
- (id)serializeValue:(id)value forDynamicAttribute:(SKDynamicAttribute *)attribute {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = self.pattern;
    return [formatter stringFromDate:value];    
}
- (BOOL)canTransformValueForClass: (Class) cls {
    return [cls isSubclassOfClass:[NSDate class]];
}
- (BOOL) validDouble: (NSString *) doubleValue {
  return [[[NSNumberFormatter alloc] init] numberFromString:doubleValue] != nil;
}
@end
