//
//  SKNSSetConverter.m
//  SoapKit
//
//  Created by Hannes Tribus on 15/10/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import "SKNSSetConverter.h"
#import "SKNSArrayConverter.h"
#import "SKDynamicAttribute.h"

@interface SKNSSetConverter()

@property(nonatomic, strong) SKParserConfiguration *configuration;
@property(nonatomic, strong) SKNSArrayConverter *arrayConverter;

@end

@implementation SKNSSetConverter
@synthesize arrayConverter = _arrayConverter;
@synthesize configuration = _configuration;
+ (SKNSSetConverter *) setConverterForConfiguration: (SKParserConfiguration *) configuration {
    return [[self alloc] initWithConfiguration: configuration];
}

- (id)initWithConfiguration: (SKParserConfiguration *) configuration {
    self = [super init];
    if (self) {
        self.configuration = configuration;
        self.arrayConverter = [SKNSArrayConverter arrayConverterForConfiguration:self.configuration];
    }
    return self;
}

- (id)transformValue:(id)values forDynamicAttribute:(SKDynamicAttribute *)attribute data:(SKData *)data parentObject:(id)parentObject {
    NSArray *result = [self.arrayConverter transformValue:values forDynamicAttribute:attribute data:data parentObject:parentObject];
    return [NSSet setWithArray:result];
}

- (id)serializeValue:(id)value forDynamicAttribute:(SKDynamicAttribute *)attribute {
    return [self.arrayConverter serializeValue:value forDynamicAttribute:attribute];
}

- (BOOL)canTransformValueForClass:(Class)class {
    return [class isSubclassOfClass:[NSSet class]];
}

@end
