//
//  SKPropertyAggregator.m
//  SoapKit
//
//  Created by Hannes Tribus on 02/09/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import "SKPropertyAggregator.h"

@implementation SKPropertyAggregator
@synthesize keysToAggregate = _keysToAggregate;
@synthesize attribute = _attribute;

+ (SKPropertyAggregator *) aggregateKeys: (NSSet *) keys intoAttribute: (NSString *) attribute {
    return [[self alloc] initWithKeysToAggregate:keys intoAttribute:attribute];
}

- (id)initWithKeysToAggregate: (NSSet *) keysToAggregate intoAttribute: (NSString *) attribute  {
    self = [super init];
    if (self) {
        _keysToAggregate = keysToAggregate;
        _attribute = attribute;
    }
    return self;
}

- (NSDictionary *) aggregateKeysOnDictionary: (NSDictionary *) baseDictionary {
    NSMutableDictionary *aggregateHolder = [[NSMutableDictionary alloc] init];
    for (NSString *key in baseDictionary) {
        if([self.keysToAggregate containsObject:key]){
            [aggregateHolder setValue:[baseDictionary objectForKey:key] forKey:key];
        }
    }
    return [NSDictionary dictionaryWithDictionary:aggregateHolder];
}

@end
