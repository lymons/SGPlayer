//
//  SGDemuxerOptions.m
//  SGPlayer
//
//  Created by Single on 2019/6/14.
//  Copyright © 2019 single. All rights reserved.
//

#import "SGDemuxerOptions.h"

@interface SGDemuxerOptions()

@property (nonatomic, copy) NSMutableDictionary<NSString*, id> *opts;

@end

@implementation SGDemuxerOptions

- (id)copyWithZone:(NSZone *)zone
{
    SGDemuxerOptions *obj = [[SGDemuxerOptions alloc] init];
    obj->_opts = self->_opts;
    obj->_options = obj->_opts;
    return obj;
}

- (instancetype)init
{
    if (self = [super init]) {
        self->_opts =  [[NSMutableDictionary alloc] initWithDictionary:@{@"reconnect" : @(1),
                                                                            @"user-agent" : @"SGPlayer",
                                                                            @"timeout" : @(20 * 1000 * 1000)}];
        self->_options = _opts;
    }
    return self;
}

- (void)setTcpOptions
{
    [self->_opts setObject:@"tcp" forKey:@"rtsp_transport"];
}

@end
