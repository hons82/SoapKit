//
//  SKObjectMapping.m
//  SoapKit
//
//  Created by Hannes Tribus on 02/09/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import "SKObjectMapping.h"

@implementation SKObjectMapping
@synthesize attributeName = _attributeName;
@synthesize keyReference = _keyReference;
@synthesize classReference = _classReference;
@synthesize converter = _converter;

- (id)initWithClass: (Class) classReference {
    self = [super init];
    if (self) {
        _classReference = classReference;
    }
    return self;
}

+ (SKObjectMapping *) mapKeyPath: (NSString *) keyPath 
                     toAttribute: (NSString *) attributeName 
                         onClass: (Class) attributeClass {
    
    return [[self alloc] initWithKeyPath:keyPath 
                             toAttribute:attributeName 
                                 onClass:attributeClass 
                               converter:nil];
}

+ (SKObjectMapping *) mapKeyPath: (NSString *) keyPath 
                     toAttribute: (NSString *) attributeName 
                         onClass: (Class) attributeClass
                       converter:(id <SKValueConverter>)converter {
    return [[self alloc] initWithKeyPath:keyPath 
                             toAttribute:attributeName 
                                 onClass:attributeClass 
                               converter:converter];
}

- (id)initWithKeyPath: (NSString *) keyReference
          toAttribute: (NSString *) attributeName
              onClass: (Class) classReference
            converter: (id <SKValueConverter>) converter {
    
    self = [super init];
    if (self) {
        _attributeName = attributeName;
        _keyReference = keyReference;
        _classReference = classReference;
        _converter = converter;
    }
    return self;
}

- (BOOL) sameKey: (NSString *) key andClassReference: (Class) classReference {
    BOOL sameProperty = [self.keyReference isEqualToString:key];
    if( sameProperty && self.classReference == classReference){
        return YES;
    }
    return NO;
}
@end
