//
//  SKObjectMapping.h
//  SoapKit
//
//  Created by Hannes Tribus on 02/09/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKValueConverter.h"

@interface SKObjectMapping : NSObject

@property(nonatomic, readonly) NSString *keyReference;
@property(nonatomic, readonly) NSString *attributeName;
@property(nonatomic, readonly) Class classReference;
@property(nonatomic, readonly) id <SKValueConverter> converter;

+ (SKObjectMapping *) mapKeyPath: (NSString *) keyPath 
                     toAttribute: (NSString *) attributeName 
                         onClass: (Class) attributeClass;

+ (SKObjectMapping *) mapKeyPath: (NSString *) keyPath 
                     toAttribute: (NSString *) attributeName 
                         onClass: (Class) attributeClass
                       converter:(id <SKValueConverter>)converter;

- (id)initWithClass: (Class) classReference;
- (BOOL) sameKey: (NSString *) key andClassReference: (Class) classReference;

@end
