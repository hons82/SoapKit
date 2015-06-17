//
//  SKData.h
//  SoapKit
//
//  Created by Hannes Tribus on 02/09/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKRequest;

@interface SKData : NSObject <NSCopying>;

+ (instancetype)dataWithName:(NSString *)name;
+ (instancetype)dataWithName:(NSString *)name andStringValue:(NSString *)value;
+ (instancetype)dataWithName:(NSString *)name andBoolValue:(BOOL)value;
+ (instancetype)dataWithName:(NSString *)name andIntValue:(NSInteger)value;
+ (instancetype)dataWithName:(NSString *)name andDateValue:(NSDate *)value;
+ (instancetype)dataWithName:(NSString *)name andChild:(SKData *)child;
+ (instancetype)dataWithName:(NSString *)name andChildren:(NSArray *)children;

- (instancetype)initWithName:(NSString *)name;

- (void)addChild:(SKData *)child;
- (void)addChildren:(NSArray *)children;

- (NSArray *)children;
- (SKData *)childByName:(NSString *)name;
- (NSArray *)childrenByName:(NSString *)name;
- (NSArray *)descendantsByName:(NSString *)name;

@property (strong, nonatomic) NSString *stringValue;
@property (nonatomic)         NSInteger intValue;
@property (nonatomic)         BOOL boolValue;
@property (strong, nonatomic) NSDate *dateValue;

- (NSString *)name;
- (NSArray *)attributes;
- (NSString *)description;

@end
