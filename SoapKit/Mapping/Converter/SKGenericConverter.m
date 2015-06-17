//
//  SKGenericConverter.m
//  SoapKit
//
//  Created by Hannes Tribus on 15/10/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import "SKGenericConverter.h"
#import "SKNSDateConverter.h"
#import "SKNSURLConverter.h"
#import "SKSimpleConverter.h"
#import "SKNSArrayConverter.h"
#import "SKNSSetConverter.h"
#import "SKCustomParser.h"
#import "SKDataObjectMapping.h"

@interface SKGenericConverter()
@property(nonatomic, strong) SKParserConfiguration *configuration;
@property(nonatomic, strong) NSArray *parsers;
@end

@implementation SKGenericConverter
@synthesize configuration = _configuration;
@synthesize parsers = _parsers;

- (id)initWithConfiguration:(SKParserConfiguration *) configuration {
    self = [super init];
    if (self) {
        _configuration = configuration;
        _parsers = [NSArray arrayWithObjects:
                   [SKNSDateConverter dateConverterForPattern:self.configuration.datePattern],
                   [SKNSURLConverter urlConverter],
                   [SKNSArrayConverter arrayConverterForConfiguration: self.configuration], 
                   [SKNSSetConverter setConverterForConfiguration: self.configuration], nil];
    }
    return self;
}

- (id)transformValue:(id)value forDynamicAttribute:(SKDynamicAttribute *)attribute data:(SKData *)data parentObject:(id)parentObject {
    if([attribute isValidObject]){
        BOOL valueIsKindOfSKData = [value isKindOfClass:[SKData class]];
        BOOL attributeNotKindOfSKData = ![attribute.objectMapping.classReference isSubclassOfClass:[SKData class]];
        if (valueIsKindOfSKData && attributeNotKindOfSKData) {
            id parsedValue = [self parseValueForBlock:value forObjectMapping:attribute data:data parentObject:parentObject];
            if (parsedValue) {
                return parsedValue;
            }

            SKDataObjectMapping *parser = [SKDataObjectMapping mapperForClass:attribute.objectMapping.classReference
                                                                     andConfiguration:self.configuration];
            value = [parser parseData:(SKData *)value forParentObject:parentObject];
        }else {
            id parsedValue = [self parseSimpleValue:value forDynamicAttribute:attribute data:data parentObject:parentObject];
            if (parsedValue) return parsedValue;
        }
    }
    SKSimpleConverter *simpleParser = [[SKSimpleConverter alloc] init];
    return [simpleParser transformValue:value forDynamicAttribute:attribute data:data parentObject:parentObject];
}

- (id)serializeValue:(id)value forDynamicAttribute: (SKDynamicAttribute *) attribute {
    for (id<SKValueConverter> parser in self.parsers) {
        if([parser canTransformValueForClass:attribute.objectMapping.classReference]){
            return [parser serializeValue:value forDynamicAttribute:attribute];
        }
    }
    
    SKSimpleConverter *simpleParser = [[SKSimpleConverter alloc] init];	
    return [simpleParser serializeValue:value forDynamicAttribute:attribute];
}

#pragma mark - private methods

- (id)parseSimpleValue:(id)value forDynamicAttribute:(SKDynamicAttribute *)attribute data:(SKData *)data parentObject:(id)parentObject {
    id parsedValue = [self parseValueForBlock:value forObjectMapping:attribute data:data parentObject:parentObject];
    
    if(parsedValue){
        return parsedValue;
    }
    
    return [self parseValueForParsers:value forDynamicAttribute:attribute data:data parentObject:parentObject];
}

- (id)parseValueForParsers:(id)value forDynamicAttribute:(SKDynamicAttribute *)attribute data:(SKData *)data parentObject:(id)parentObject {
    for (id<SKValueConverter> parser in self.parsers) {
        if([parser canTransformValueForClass:attribute.objectMapping.classReference]){
            return [parser transformValue:value forDynamicAttribute:attribute data:data parentObject:parentObject];
        }
    }
    return nil;
}

- (id)parseValueForBlock:(id)value forObjectMapping:(SKDynamicAttribute *)attribute data:(SKData *)data parentObject:(id)parentObject {
    SKObjectMapping *objectMapping = attribute.objectMapping;
    for(SKCustomParser *parser in self.configuration.customParsers){
        if ([parser isValidToPerformBlockOnAttributeName:objectMapping.attributeName
                                               forClass:attribute.classe]) {
            
            return parser.blockParser(data, objectMapping.attributeName, attribute.classe, value);
        }
    }
    return nil;
}

@end