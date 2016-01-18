//
//  TestDataRequest.m
//  iTotemMinFramework
//
//  Created by Sword Zhou on 7/17/13.
//
//

#import "TestDataRequest.h"

@implementation TestDataRequest

- (NSString*)getRequestUrl
{
    return @"http://localhost/position1.php";
}

- (BOOL)useDumpyData
{
    return TRUE;
}

- (NSString*)dumpyResponseString
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mapping3" ofType:@"json"];
    NSString *response = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    return response;
}

@end
