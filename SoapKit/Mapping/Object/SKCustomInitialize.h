//
//  SKCustomInitialize.h
//  SoapKit
//
//  Created by Hannes Tribus on 15/10/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id(^SKCustomInitializeBlock)(__weak Class classOfObjectToGenerate, __weak id values, __weak id parentObject);

@interface SKCustomInitialize : NSObject

@property(nonatomic, readonly) SKCustomInitializeBlock blockInitialize;
@property(nonatomic, readonly) Class classOfObjectToGenerate;

- (id) initWithBlockInitialize: (SKCustomInitializeBlock) blockInitialize
                      forClass: (Class) classOfObjectToGenerate;
- (BOOL) isValidToPerformBlock: (Class) classOfObjectToGenerate;
@end
