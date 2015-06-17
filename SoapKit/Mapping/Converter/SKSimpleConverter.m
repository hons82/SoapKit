//
//  SKSimpleConverter.m
//  SoapKit
//
//  Created by Hannes Tribus on 15/10/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import "SKSimpleConverter.h"
#import "SKDynamicAttribute.h"

@implementation SKSimpleConverter

- (id)transformValue:(id)value forDynamicAttribute:(SKDynamicAttribute *)attribute data:(SKData *)data parentObject:(id)parentObject {
    return value;
}

-(id)serializeValue:(id)value forDynamicAttribute:(SKDynamicAttribute *)attribute{
    return value;
}

- (BOOL)canTransformValueForClass:(Class)class {
    return YES;
}

@end
