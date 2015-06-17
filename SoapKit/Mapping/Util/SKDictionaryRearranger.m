//
//  SKDictionaryRearranger.m
//  SoapKit
//
//  Created by Hannes Tribus on 15/10/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import "SKDictionaryRearranger.h"

#import "SKObjectMapping.h"
#import "SKPropertyAggregator.h"

@implementation SKDictionaryRearranger


+ (NSDictionary *) rearrangeDictionary: (NSDictionary *) dictionary forConfiguration: (SKParserConfiguration *) configuration {
    NSMutableArray* aggregators = [NSMutableArray arrayWithArray:[[configuration.aggregators reverseObjectEnumerator] allObjects]];
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    if(aggregators && [aggregators count] > 0){
        for(int i=(int)[aggregators count] - 1; i >= 0; --i){
            SKPropertyAggregator* aggregator = [aggregators objectAtIndex:i];
            [aggregators removeObject:aggregator];
            NSMutableDictionary *aggregatedValues = [[aggregator aggregateKeysOnDictionary:mutableDictionary] mutableCopy];
            if([mutableDictionary objectForKey:aggregator.attribute]){
                [aggregatedValues addEntriesFromDictionary:[mutableDictionary objectForKey:aggregator.attribute]];
            }
            [mutableDictionary setValue:aggregatedValues forKey:aggregator.attribute];
        }
    }
    
    for (SKObjectMapping* mapper in configuration.objectMappers) {
        NSArray* keys = [mapper.keyReference componentsSeparatedByString:configuration.nestedPrepertiesSplitToken];
        // Composed key
        id value;
        if (keys.count >1) {
            
            for (NSString* key in keys) {
                if ([key isEqualToString:keys[0]]) {
                    value = [mutableDictionary objectForKey:key];
                } else if ([value isKindOfClass:[NSDictionary class]]) {
                    NSDictionary* dict = (NSDictionary*)value;
                    value = [dict objectForKey:key];
                    if ([key isEqualToString:[keys lastObject]]) {
                        [mutableDictionary setValue:value forKey:mapper.keyReference];
                    }
                }
            }
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:mutableDictionary];
}


@end
