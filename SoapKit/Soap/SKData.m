//
//  SKData.m
//  SoapKit
//
//  Created by Hannes Tribus on 02/09/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import "SKData.h"
#import "GDataXMLNode.h"
#import "ISO8601DateFormatter.h"

@interface SKData ()
@property (strong, nonatomic) GDataXMLElement *xml;
@end

@implementation SKData

+ (instancetype)dataWithName:(NSString *)name
{
    SKData *arg = [[SKData alloc] initWithName:name];
    return arg;
}

+ (instancetype)dataWithName:(NSString *)name andChild:(SKData *)child
{
    SKData *arg = [SKData dataWithName:name];
    [arg addChild:child];
    return arg;
}

+ (instancetype)dataWithName:(NSString *)name andChildren:(NSArray *)children
{
    SKData *arg = [SKData dataWithName:name];
    [arg addChildren:children];
    return arg;
}

+ (instancetype)dataWithName:(NSString *)name andStringValue:(NSString *)value
{
    SKData *arg = [SKData dataWithName:name];
    [arg setStringValue:value];
    return arg;
}

+ (instancetype)dataWithName:(NSString *)name andBoolValue:(BOOL)value
{
    SKData *arg = [SKData dataWithName:name];
    [arg setBoolValue:value];
    return arg;
}

+ (instancetype)dataWithName:(NSString *)name andIntValue:(NSInteger)value
{
    SKData *arg = [SKData dataWithName:name];
    [arg setIntValue:value];
    return arg;
}

+ (instancetype)dataWithName:(NSString *)name andDateValue:(NSDate *)value
{
    SKData *arg = [SKData dataWithName:name];
    [arg setDateValue:value];
    return arg;
}

+ (instancetype)dataWithXMLElement:(GDataXMLElement *)element
{
    SKData *arg;
    
    if(!element)
        return nil;
    
    arg = [[SKData alloc] init];
    arg.xml = element;
    return arg;
}

- (void)addChild:(SKData *)child
{
    [self.xml addChild:child.xml];
}

- (void)addChildren:(NSArray *)children
{
    for(SKData *child in children)
        [self addChild:child];
}

- (NSArray *)children
{
    NSMutableArray *children = [[NSMutableArray alloc] init];
    
    for(GDataXMLElement *element in self.xml.children)
        [children addObject:[SKData dataWithXMLElement:element]];
    
    return children;
}

- (SKData *)childByName:(NSString *)name
{
    GDataXMLElement *node = [self.xml elementsForName:name].firstObject;
    return [SKData dataWithXMLElement:node];
}

- (NSArray *)childrenByName:(NSString *)name
{
    NSMutableArray *children = [[NSMutableArray alloc] init];
    NSArray *gchildren = [self.xml elementsForName:name];
    
    for(GDataXMLElement *element in gchildren)
        [children addObject:[SKData dataWithXMLElement:element]];
    
    return children;
}

- (NSArray *)descendantsByName:(NSString *)name
{
    NSMutableArray *children = [[NSMutableArray alloc] init];
    NSArray *gchildren = [self.xml nodesForXPath:[NSString stringWithFormat:@".//%@", name] error:nil];
    
    for(GDataXMLElement *element in gchildren)
        [children addObject:[SKData dataWithXMLElement:element]];
    
    return children;
}

- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    if(!self)
        return nil;
    
    self.xml = [GDataXMLElement elementWithName:name];
    return self;
}

- (NSString *)stringValue
{
    return self.xml.stringValue;
}

- (void)setStringValue:(NSString *)value {
    self.xml.stringValue = value;
}

//TODO: what about invalid values?
- (BOOL)boolValue {
    return [self.xml.stringValue caseInsensitiveCompare:@"true"] == NSOrderedSame;
}

- (void)setBoolValue:(BOOL)value
{
    NSString *str = value ? @"true" : @"false";
    [self setStringValue:str];
}

- (NSInteger)intValue
{
    return self.xml.stringValue.integerValue;
}

- (void)setIntValue:(NSInteger)value
{
    [self setStringValue:[NSString stringWithFormat:@"%@\n", @(value)]];
}

- (NSDate *)dateValue
{
    ISO8601DateFormatter *formatter = [[ISO8601DateFormatter alloc] init];
    return [formatter dateFromString:self.xml.stringValue];
}

- (void)setDateValue:(NSDate *)value
{
    //proper ISO 8601 dates (with timezone offset) are not accepted by the server
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
    self.xml.stringValue = [formatter stringFromDate:value];
}

- (id)copyWithZone:(NSZone *)zone
{
    SKData *copy = [[[self class] allocWithZone:zone] init];
    copy.xml = [self.xml copyWithZone:zone];
    return copy;
}

- (NSArray *)attributes {
    return self.xml.attributes;
}

- (NSString *)name {
    return self.xml.name;
}

- (NSString *)description {
    return self.xml.XMLString;
}

@end
