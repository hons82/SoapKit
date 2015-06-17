//
//  SKPropertyFinder.m
//  SoapKit
//
//  Created by Hannes Tribus on 15/10/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import "SKPropertyFinder.h"
#import <objc/runtime.h>

@interface SKPropertyFinder()

@property(nonatomic, strong) SKReferenceKeyParser *keyParser;

@end

@implementation SKPropertyFinder
@synthesize keyParser = _keyParser;
@synthesize mappers = _mappers;

#pragma mark - public methods

+ (SKPropertyFinder *) finderWithKeyParser: (SKReferenceKeyParser *) _keyParser {
    return [[self alloc] initWithKeyParser:_keyParser];
}

- (SKDynamicAttribute *) findAttributeForKey: (NSString *) key onClass: (Class) cls {
    NSString *originalKey = key;
    
    SKObjectMapping *mapper = [self findMapperForKey:key onClass:cls];
    
    if(mapper){
        key = mapper.attributeName;
    }
    
    NSString *propertyDetails = [self findPropertyDetailsForKey:key onClass:cls];
    if(!propertyDetails){
        key = [self.keyParser splitKeyAndMakeCamelcased:key];
        propertyDetails = [self findPropertyDetailsForKey:key onClass:cls];
    }
    
    if(!propertyDetails)
        return nil;

    SKDynamicAttribute *dynamicAttribute;
    if (mapper && mapper.converter) {
        dynamicAttribute = [[SKDynamicAttribute alloc] initWithAttributeDescription:propertyDetails
                                                                             forKey:originalKey
                                                                            onClass:cls
                                                                      attributeName:key
                                                                          converter:mapper.converter];
    }
    else {
        dynamicAttribute = [[SKDynamicAttribute alloc] initWithAttributeDescription:propertyDetails
                                                                             forKey:originalKey
                                                                            onClass:cls
                                                                      attributeName:key];
    }

    return dynamicAttribute;
}

- (void) setMappers: (NSArray *) mappers{
    _mappers = [NSArray arrayWithArray:mappers];
}

#pragma mark - private methods
- (id)initWithKeyParser: (SKReferenceKeyParser *) keyParser {
    self = [super init];
    if (self) {
        _keyParser = keyParser;
        _mappers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSString *) findPropertyDetailsForKey: (NSString *)key onClass: (Class)class{
    objc_property_t property = class_getProperty(class, [key UTF8String]);
    if (property) {
        NSString *attributeDetails = [NSString stringWithUTF8String:property_getAttributes(property)];
        return attributeDetails;
    }
    return nil;
}

- (SKObjectMapping *) findMapperForKey: (NSString *) key onClass: (Class) cls {
    for(SKObjectMapping *mapper in self.mappers){
        if([mapper sameKey:key andClassReference:cls]){
            return mapper;
        }
    }
    return nil;
}
@end
