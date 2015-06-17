//
//  SKCustomInitialize.m
//  SoapKit
//
//  Created by Hannes Tribus on 15/10/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import "SKCustomInitialize.h"

@implementation SKCustomInitialize
@synthesize blockInitialize = _blockInitialize;
@synthesize classOfObjectToGenerate = _classOfObjectToGenerate;
- (id) initWithBlockInitialize: (SKCustomInitializeBlock) blockInitialize
                      forClass: (Class) classOfObjectToGenerate {
    self = [super init];
    if (self) {
        _blockInitialize = [blockInitialize copy];
        _classOfObjectToGenerate = classOfObjectToGenerate;
    }
    return self;
}

- (BOOL) isValidToPerformBlock: (Class) classOfObjectToGenerate {
    return _classOfObjectToGenerate == classOfObjectToGenerate;
}
@end
