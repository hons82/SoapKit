//
//  SKArrayMapping.m
//  SoapKit
//
//  Created by Hannes Tribus on 02/09/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import "SKArrayMapping.h"

@implementation SKArrayMapping
@synthesize objectMapping = _objectMapping;
@synthesize classForElementsOnArray = _classForElementsOnArray;

+ (SKArrayMapping *) mapperForClassElements: (Class) classForElementsOnArray 
                               forAttribute: (NSString *) attribute 
                                    onClass: (Class) classReference{
    
    SKObjectMapping *objectMapping = [SKObjectMapping mapKeyPath:attribute 
                                                     toAttribute:attribute 
                                                         onClass:classReference];
    
    return  [[self alloc] initWithObjectMapping:objectMapping 
                          forArrayElementOfType:classForElementsOnArray];
}

+ (SKArrayMapping *) mapperForClass: (Class) classForElementsOnArray 
                          onMapping: (SKObjectMapping *) objectMapping {
    return [[self alloc] initWithObjectMapping:objectMapping 
                         forArrayElementOfType:classForElementsOnArray];
}

- (id)initWithObjectMapping: (SKObjectMapping *) objectMapping
      forArrayElementOfType: (Class) classForElementsOnArray {
    
    self = [super init];
    if (self) {
        _objectMapping = objectMapping;
        _classForElementsOnArray = classForElementsOnArray;
    }
    return self;
}

@end
