//
//  telstra_pocTests.m
//  telstra_pocTests
//
//  Created by Mehak Kalra on 7/22/17.
//  Copyright © 2017 Mehak Kalra. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "telstraTableViewController.h"
#import "AFNetworking.h"

@interface telstra_pocTests : XCTestCase

@property telstraTableViewController *tableViewController;
@end

@implementation telstra_pocTests

- (void)setUp {
    [super setUp];
    self.tableViewController = [[telstraTableViewController alloc] init];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testUrlReturningJson {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
   // XCTestExpectation *expectation = [self expectationWithDescription:@"asynchronous request"];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if(error){
              XCTAssertNil(error, @"dataTaskWithURL error %@", error);
        }
      else{
          if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
              NSInteger statusCode = [(NSHTTPURLResponse *) response statusCode];
              XCTAssertEqual(statusCode, 200, @"status code was not 200; was %ld", (long)statusCode);
          }
          
           dispatch_semaphore_signal(semaphore);
          
        }
    }];
    [downloadTask resume];
    
    long rc = dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, 60.0 * NSEC_PER_SEC));
    XCTAssertEqual(rc, 0, @"network request timed out");
    
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
