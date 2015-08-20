//
//  SeismicXML_Tests.m
//  SeismicXML Tests
//
//  Created by Ho Nguyen Binh on 8/19/15.
//  Copyright (c) 2015 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "APLParseOperation.h"
@interface SeismicXML_Tests : XCTestCase<APLParseOperationDelegate>
@property XCTestExpectation *didFinishedExpectation;
@end

@implementation SeismicXML_Tests

- (void)parseOperationDidFinished:(APLParseOperation*)parseOperation{
    [self.didFinishedExpectation fulfill];
}

- (void)testParsingValidateXML {
    //Get URL to resource bundle
    NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
    NSURL *resourceURL = [testBundle URLForResource:@"7day-M2.5" withExtension:@"xml"];
    //Load XML data
    NSData *XMLData = [NSData dataWithContentsOfURL:resourceURL];
    //Create parse operation
    APLParseOperation *parseOperation = [[APLParseOperation alloc] initWithData:XMLData];
    
    // Run operation
    [parseOperation start];
    
    // Check number of earthwake
    XCTAssertEqual(parseOperation.earthquakeList.count, 150);
}

- (void)testParsingInTheBackGround {
    //Get URL to resource bundle
    NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
    NSURL *resourceURL = [testBundle URLForResource:@"7day-M2.5" withExtension:@"xml"];
    //Load XML data
    NSData *XMLData = [NSData dataWithContentsOfURL:resourceURL];
    
    self.didFinishedExpectation = [self expectationWithDescription:@"parsing finished"];
    
    //Create parse operation
    APLParseOperation *parseOperation = [[APLParseOperation alloc] initWithData:XMLData];
    parseOperation.delegate = self;
    // Run operation
    NSOperationQueue *parseQueue = [NSOperationQueue new];
    [parseQueue addOperation:parseOperation];
    
    //wait for operation finished
    [self waitForExpectationsWithTimeout:1.01 handler:nil];
    
    // Check number of earthwake
    XCTAssertEqual(parseOperation.earthquakeList.count, 150);
}

@end
