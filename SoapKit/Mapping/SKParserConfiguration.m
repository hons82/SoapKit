//
//  SKParserConfiguration.m
//  SoapKit
//
//  Created by Hannes Tribus on 15/10/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import "SKParserConfiguration.h"
#import "SKArrayMapping.h"
#import "SKPropertyAggregator.h"
#import "SKCustomInitialize.h"

@interface SKParserConfiguration()

@property(nonatomic, strong) NSMutableArray *arrayMappers;

@end

@implementation SKParserConfiguration

@synthesize datePattern = _datePattern;
@synthesize splitToken = _splitToken;
@synthesize arrayMappers = _arrayMappers;
@synthesize objectMappers = _objectMappers;
@synthesize aggregators = _aggregators;
@synthesize customInitializers = _customInitializers;
@synthesize customParsers = _customParsers;

+ (SKParserConfiguration *) configuration {
    return [[self alloc] init];
}

- (id)init {
    self = [super init];
    if (self) {
        _arrayMappers = [[NSMutableArray alloc] init];
        _objectMappers = [[NSMutableArray alloc] init];
        _aggregators = [[NSMutableArray alloc] init];
        _customInitializers = [[NSMutableArray alloc] init];
        _customParsers = [[NSMutableArray alloc] init];
        _splitToken = @"_";
        _nestedPrepertiesSplitToken = @".";
        _datePattern = @"eee MMM dd HH:mm:ss ZZZZ yyyy";
    }
    return self;
}

- (void)setSplitToken:(NSString *)splitToken
{
    if (splitToken &&
        ![splitToken isEqualToString:_splitToken] &&
        ![splitToken isEqualToString:_nestedPrepertiesSplitToken]) {
        _splitToken = splitToken;
    }
}

- (void)addArrayMapper: (SKArrayMapping *)mapper {
    [self.arrayMappers addObject:mapper];
    [self.objectMappers addObject:mapper.objectMapping];
}
- (void) addObjectMapping: (SKObjectMapping *) mapper {
    [self.objectMappers addObject:mapper];
}
- (void) addObjectMappings: (NSArray *)mappers {
    for (SKObjectMapping *mapper in mappers) {
        [self.objectMappers addObject:mapper];
    }
}
- (void) addAggregator: (SKPropertyAggregator *) aggregator {
    [self.aggregators addObject:aggregator];
}
- (void) addCustomInitializersObject:(SKCustomInitialize *) customInitialize {
    [self.customInitializers addObject:customInitialize];
}
- (void) addCustomParsersObject:(SKCustomParser *)parser {
    [self.customParsers addObject:parser];
}

- (id)instantiateObjectForClass:(Class)classOfObjectToGenerate withData:(id)data {
    return [self instantiateObjectForClass:classOfObjectToGenerate withData:data parentObject:nil];
}

- (id)instantiateObjectForClass:(Class)classOfObjectToGenerate withData:(id)data parentObject:(id)parentObject {
    for(SKCustomInitialize *customInitialize in self.customInitializers){
        if([customInitialize isValidToPerformBlock:classOfObjectToGenerate]){
            return customInitialize.blockInitialize(classOfObjectToGenerate, data, parentObject);
        }
    }
    return [[classOfObjectToGenerate alloc] init];
}

- (SKArrayMapping *) arrayMapperForMapper: (SKObjectMapping *) mapper {
    for(SKArrayMapping *arrayMapper in self.arrayMappers){
        SKObjectMapping *mapping = arrayMapper.objectMapping;
        BOOL sameKey = [mapping.keyReference isEqualToString:mapper.keyReference];
        BOOL sameAttributeName = [mapping.attributeName isEqualToString:mapper.attributeName];
        BOOL sameAttributeNameWithUnderscore = [[self addUnderScoreToPropertyName:mapping.attributeName] isEqualToString:mapper.attributeName];
        if(sameKey && (sameAttributeName || sameAttributeNameWithUnderscore)){
            return arrayMapper;
        }
    }
    return nil;
}

- (NSString *)addUnderScoreToPropertyName:(NSString *)key {
    return (!key || [key isEqualToString:@""]) ? [NSString stringWithFormat:@"_%@", key] : @"";
}
@end
