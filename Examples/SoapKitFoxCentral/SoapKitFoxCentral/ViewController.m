//
//  ViewController.m
//  SoapKitFoxCentral
//
//  Created by Hannes Tribus on 16/06/15.
//  Copyright (c) 2015 3Bus. All rights reserved.
//

#import "ViewController.h"
#import <SoapKit/SoapKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self loadItemsofType:@"NEWS" withinLast:365 onCompletion:^(NSArray *lectures, NSError *error) {
        NSLog(@"Done");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadItemsofType:(NSString *)type withinLast:(NSUInteger)days
                onCompletion:(void (^)(NSArray *lectures, NSError *error))completion {
    SKRequest *request = [[SKRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.foxcentral.net/foxcentral.asmx"] operation:@"GetNewsItems" andNamespaceURL:[NSURL URLWithString:@"http://www.west-wind.com/foxcentral"]];
    [request addInputs:@[[SKData dataWithName:@"Days" andIntValue:days],
                         [SKData dataWithName:@"Provider" andIntValue:0],
                         [SKData dataWithName:@"Type" andStringValue:type]]
                        ];
    
    SKService *soapService = [[SKService alloc] init];
    [soapService performRequest:request onSuccess:^(SKService *soapService, SKData *data) {
        NSLog(@"Name: %@",data.name);
         [self.textView setText:data.stringValue];
    } onFailure:^(SKService *soapService, NSError *error) {
        NSLog(@"Error: %@",[error localizedDescription]);
    }];
}


@end
