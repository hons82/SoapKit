//
//  SKArrayMapping.h
//  SoapKit
//
//  Created by Hannes Tribus on 02/09/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKObjectMapping.h"
@interface SKArrayMapping : NSObject

@property(nonatomic, readonly) SKObjectMapping *objectMapping;
@property(nonatomic, readonly) Class classForElementsOnArray;


+ (SKArrayMapping *) mapperForClassElements: (Class) classForElementsOnArray 
                               forAttribute: (NSString *) attribute 
                                    onClass: (Class) classReference;

+ (SKArrayMapping *) mapperForClass: (Class) classForElementsOnArray 
                          onMapping: (SKObjectMapping *) objectMapping;

@end
