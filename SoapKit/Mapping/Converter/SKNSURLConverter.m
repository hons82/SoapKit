//
//  SKNSURLConverter.m
//  SoapKit
//
//  Created by Hannes Tribus on 15/10/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import "SKNSURLConverter.h"
#import "SKDynamicAttribute.h"

@implementation SKNSURLConverter

+ (SKNSURLConverter *) urlConverter {
    return [[self alloc] init];
}

- (id)transformValue:(id)value forDynamicAttribute:(SKDynamicAttribute *)attribute data:(SKData *)data parentObject:(id)parentObject {
    return [NSURL URLWithString:[value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}
- (id)serializeValue:(id)value forDynamicAttribute:(SKDynamicAttribute *)attribute {
    return [((NSURL *)value) absoluteString];
}
- (BOOL)canTransformValueForClass: (Class) cls {
    return [cls isSubclassOfClass:[NSURL class]];
}

@end
