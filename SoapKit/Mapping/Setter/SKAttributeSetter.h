//
//  SKAttributeSetter.h
//  SoapKit
//
//  Created by Hannes Tribus on 15/10/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKAttributeSetter : NSObject

+ (void)assingValue: (id)value
   forAttributeName: (NSString *)attributeName
  andAttributeClass: (Class) attributeClass
           onObject:(id)object;

@end
