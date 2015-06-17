//
//  SKPropertyFinder.h
//  SoapKit
//
//  Created by Hannes Tribus on 15/10/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKDynamicAttribute.h"
#import "SKReferenceKeyParser.h"

@interface SKPropertyFinder : NSObject

@property(nonatomic, strong) NSArray *mappers;

+ (SKPropertyFinder *) finderWithKeyParser: (SKReferenceKeyParser *) keyParser;
- (SKDynamicAttribute *) findAttributeForKey: (NSString *) key 
                                     onClass: (Class) className;

@end
