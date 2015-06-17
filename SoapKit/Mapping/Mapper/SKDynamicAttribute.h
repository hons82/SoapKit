//
//  SKDynamicAttribute.h
//  SoapKit
//
//  Created by Hannes Tribus on 15/10/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKObjectMapping.h"
#import "SKValueConverter.h"
@interface SKDynamicAttribute : NSObject

@property(nonatomic, readonly) SKObjectMapping *objectMapping;
@property(nonatomic, readonly) NSString *typeName;
@property(nonatomic, readonly) Class classe;
@property(nonatomic, readonly, getter = isPrimitive) BOOL primitive;
@property(nonatomic, readonly, getter = isIdType) BOOL idType;
@property(nonatomic, readonly, getter = isValidObject) BOOL validObject;

- (id)initWithClass: (Class) classs;
- (id)initWithAttributeDescription: (NSString *) description
                            forKey: (NSString *) key
                           onClass: (Class) classe;

- (id)initWithAttributeDescription: (NSString *) description
                            forKey: (NSString *) key
                           onClass: (Class) classe
                     attributeName: (NSString *) attibuteName;

- (id)initWithAttributeDescription: (NSString *) description
                            forKey: (NSString *) key
                           onClass: (Class) classe
                     attributeName: (NSString *) attibuteName 
                         converter:(id<SKValueConverter>) converter;
@end
