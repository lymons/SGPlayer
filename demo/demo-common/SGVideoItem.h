//
//  SGVideoItem.h
//  demo-common
//
//  Created by Single on 2017/3/15.
//  Copyright © 2017年 single. All rights reserved.
//

#import <SGPlayer/SGPlayer.h>

@interface SGVideoItem : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) SGAsset *asset;
@property (nonatomic) SGDisplayMode displayMode;
@property (nonatomic) BOOL liveMode;
@property (nonatomic) BOOL tcpMode;             // IP Camera using TCP socket.

+ (NSArray<SGVideoItem *> *)videoItems;

@end

