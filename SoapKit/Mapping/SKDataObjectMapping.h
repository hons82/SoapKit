//
//  SKDataObjectMapping.h
//  SoapKit
//
//  Created by Hannes Tribus on 21/10/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKParserConfiguration, SKData;

@interface SKDataObjectMapping : NSObject

@property(nonatomic, readonly) Class classToGenerate;

+ (SKDataObjectMapping *)mapperForClass:(Class)classToGenerate;
+ (SKDataObjectMapping *)mapperForClass:(Class)classToGenerate andConfiguration:(SKParserConfiguration *)configuration;

- (id)initWithClass:(Class)classToGenerate forConfiguration:(SKParserConfiguration *)configuration;

- (id)parseData:(SKData *)data;
- (id)parseData:(SKData *)data forParentObject:(id)parentObject;

- (NSArray *)parseArray:(NSArray *)array;
- (NSArray *)parseArray:(NSArray *)array forParentObject:(id)parentObject;

/*
- (NSDictionary *)serializeObject:(id)object;
- (NSArray *)serializeObjectArray:(NSArray *)objectArray;
*/
- (void)updateObject:(id)object withData:(SKData *)data;

@end
