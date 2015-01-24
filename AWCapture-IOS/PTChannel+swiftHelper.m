//
//  PTChannel+swiftHelper.m
//  AppleWatchSimulator
//
//  Created by nan.tang on 15/1/21.
//
//

#import "PTChannel+swiftHelper.h"

@implementation PTChannel (swiftHelper)
- (void)listenOnPort:(in_port_t)port  callback:(void(^)(NSError *error))callback{
    [self listenOnPort:port IPv4Address:INADDR_LOOPBACK callback:callback];
}
@end
