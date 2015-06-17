//
//  SKDataObjectMapping.m
//  SoapKit
//
//  Created by Hannes Tribus on 21/10/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import "SKDataObjectMapping.h"

#import "SKGenericConverter.h"
#import "SKDynamicAttribute.h"
#import "SKReferenceKeyParser.h"
#import "SKPropertyFinder.h"
#import "SKAttributeSetter.h"
#import "SKDictionaryRearranger.h"
#import "SKData.h"

@interface SKDataObjectMapping()

@property(nonatomic, strong) SKGenericConverter *converter;
@property(nonatomic, strong) SKPropertyFinder *propertyFinder;
@property(nonatomic, strong) SKParserConfiguration *configuration;
@end

@implementation SKDataObjectMapping

@synthesize converter = _converter;
@synthesize propertyFinder = _propertyFinder;
@synthesize configuration = _configuration;
@synthesize classToGenerate = _classToGenerate;

+ (SKDataObjectMapping *)mapperForClass:(Class)classToGenerate; {
    return [self mapperForClass:classToGenerate andConfiguration:[SKParserConfiguration configuration]];
}

+ (SKDataObjectMapping *)mapperForClass:(Class)classToGenerate andConfiguration:(SKParserConfiguration *)configuration {
    return [[self alloc] initWithClass: classToGenerate
                      forConfiguration: configuration];
}

- (id) initWithClass: (Class) classToGenerate forConfiguration: (SKParserConfiguration *) configuration {
    self = [super init];
    if (self) {
        _configuration = configuration;
        _classToGenerate = classToGenerate;
        SKReferenceKeyParser *keyParser = [SKReferenceKeyParser parserForToken:self.configuration.splitToken];
        
        self.propertyFinder = [SKPropertyFinder finderWithKeyParser:keyParser];
        [self.propertyFinder setMappers:[configuration objectMappers]];
        
        self.converter = [[SKGenericConverter alloc] initWithConfiguration:configuration];
    }
    return self;
}

#pragma mark - Parsing

- (NSArray *)parseArray:(NSArray *)array {
    return [self parseArray:array forParentObject:nil];
}

- (NSArray *)parseArray:(NSArray *)array forParentObject:(id)parentObject {
    if(!array){
        return nil;
    }
    NSMutableArray *values = [[NSMutableArray alloc] initWithCapacity:[array count]];
    for (id data in array) {
        id value = [self parseData:data forParentObject:parentObject];
        [values addObject:value];
    }
    return [NSArray arrayWithArray:values];
}

- (id)parseData:(SKData *)data {
    return [self parseData:data forParentObject:nil];
}

- (id)parseData:(SKData *)data forParentObject:(id)parentObject {
    if (!data || !self.classToGenerate) {
        return nil;
    }
    NSObject *object = [[self configuration] instantiateObjectForClass:self.classToGenerate withData:data parentObject:parentObject];
    
    [self setValuesOnObject:object withData:data];
    return object;
}

- (void)setValuesOnObject:(id)object withData:(SKData *)data {
    if([object class] != self.classToGenerate){
        return;
    }
    
    // TODO
    // dictionary = [SKDictionaryRearranger rearrangedata:data forConfiguration:self.configuration];
    
    for (SKData *dataItem in data.children) {
        SKDynamicAttribute *dynamicAttribute = [self.propertyFinder findAttributeForKey:dataItem.name onClass:self.classToGenerate];
        if(dynamicAttribute){
            [self parseValue:dataItem.stringValue forObject:object inAttribute:dynamicAttribute data:data];
        }

    }
    
    
    /*for (NSString *key in keys) {
     id value = [dictionary valueForKey:key];
     SKDynamicAttribute *dynamicAttribute = [self.propertyFinder findAttributeForKey:key onClass:self.classToGenerate];
     if(dynamicAttribute){
     [self parseValue:value forObject:object inAttribute:dynamicAttribute data:data];
     }
     }*/
}


- (void)parseValue:(id)value forObject:(id)object inAttribute:(SKDynamicAttribute *)dynamicAttribute data:(SKData *)data {
    SKObjectMapping *objectMapping = dynamicAttribute.objectMapping;
    NSString *attributeName = objectMapping.attributeName;
    
    if (objectMapping.converter) {
        value = [objectMapping.converter transformValue:value forDynamicAttribute:dynamicAttribute data:data parentObject:object];
    } else {
        value = [self.converter transformValue:value forDynamicAttribute:dynamicAttribute data:data parentObject:object];
    }
    
    [SKAttributeSetter assingValue:value
                  forAttributeName:attributeName
                 andAttributeClass:objectMapping.classReference
                          onObject:object];
}

- (void)updateObject:(id)object withData:(SKData *)data {
    if (!data || !self.classToGenerate || !object || ![object isKindOfClass:self.classToGenerate])
        return;
    
    [self setValuesOnObject:object withData:data];
    return;
}

@end
