//
//  SKParserConfiguration.h
//  SoapKit
//
//  Created by Hannes Tribus on 15/10/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKArrayMapping, SKPropertyAggregator, SKObjectMapping, SKCustomInitialize, SKCustomParser;
@interface SKParserConfiguration : NSObject

@property(nonatomic, strong) NSString *datePattern;
@property(nonatomic, strong) NSString *splitToken;
@property(nonatomic, strong) NSString *nestedPrepertiesSplitToken;
@property(nonatomic, readonly) NSMutableArray *objectMappers;
@property(nonatomic, readonly) NSMutableArray *aggregators;
@property(nonatomic, readonly) NSMutableArray *customInitializers;
@property(nonatomic, readonly) NSMutableArray *customParsers;

+ (SKParserConfiguration *) configuration;

- (id)instantiateObjectForClass:(Class)classOfObjectToGenerate withData:(id)data;
- (id)instantiateObjectForClass:(Class)classOfObjectToGenerate withData:(id)data parentObject:(id)parentObject;

- (void) addArrayMapper: (SKArrayMapping *)mapper;
- (void) addObjectMapping: (SKObjectMapping *) mapper;
- (void) addObjectMappings: (NSArray *)mappers;
- (void) addAggregator: (SKPropertyAggregator *) aggregator;
- (void) addCustomInitializersObject:(SKCustomInitialize *) customInitialize;
- (void) addCustomParsersObject:(SKCustomParser *)parser;

- (SKArrayMapping *) arrayMapperForMapper: (SKObjectMapping *) mapper;
@end

