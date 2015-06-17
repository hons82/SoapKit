//
//  SKPropertyAggregator.h
//  SoapKit
//
//  Created by Hannes Tribus on 02/09/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKPropertyAggregator : NSObject

@property(nonatomic, readonly) NSSet *keysToAggregate;
@property(nonatomic, readonly) NSString *attribute;

+ (SKPropertyAggregator *) aggregateKeys: (NSSet *) keys intoAttribute: (NSString *) attribute;

- (NSDictionary *) aggregateKeysOnDictionary: (NSDictionary *) baseDictionary;

@end
