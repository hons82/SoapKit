//
//  NAICSItem.h
//  SoapKitNAICS
//
//  Created by Hannes Tribus on 16/06/15.
//  Copyright (c) 2015 3Bus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NAICSItem : NSObject

@property (nonatomic,strong)NSString *NAICSCode;
@property (nonatomic,strong)NSString *NAICSTitle;
@property (nonatomic,strong)NSString *Country;
@property (nonatomic,strong)NSString *IndustryDescription;

@end
