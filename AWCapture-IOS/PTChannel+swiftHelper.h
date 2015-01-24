//
//  PTChannel+swiftHelper.h
//  AppleWatchSimulator
//
//  Created by nan.tang on 15/1/21.
//
//

#import "PTChannel.h"

@interface PTChannel (swiftHelper)
- (void)listenOnPort:(in_port_t)port  callback:(void(^)(NSError *error))callback;
@end
