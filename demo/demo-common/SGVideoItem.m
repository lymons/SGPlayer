//
//  SGVideoItem.m
//  demo-common
//
//  Created by Single on 2017/3/15.
//  Copyright © 2017年 single. All rights reserved.
//

#import "SGVideoItem.h"

@implementation SGVideoItem

+ (NSArray<SGVideoItem *> *)videoItems
{
    NSURL *i_see_fire = [[NSBundle mainBundle] URLForResource:@"i-see-fire" withExtension:@"mp4"];
    NSURL *google_help_vr = [[NSBundle mainBundle] URLForResource:@"google-help-vr" withExtension:@"mp4"];
    
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:11];
    {
        NSURL *url = [[NSURL alloc] initWithString:@"rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mov"];
        SGVideoItem *item = [[SGVideoItem alloc] init];
        item.name = @"RSTP + H264: BigBuckBunny_115k";
        item.asset = [SGAsset assetWithURL:url];
        item.displayMode = SGDisplayModePlane;
        [items addObject:item];
    }
    {
        NSURL *url = [[NSURL alloc] initWithString:@"rtsp://192.168.10.235/videodevice"];
        SGVideoItem *item = [[SGVideoItem alloc] init];
        item.name = @"RSTP + H265: IPCamera";
        item.asset = [SGAsset assetWithURL:url];
        item.displayMode = SGDisplayModePlane;
        [items addObject:item];
    }
    {
        NSURL *url = [[NSURL alloc] initWithString:@"rtsp://192.168.10.235/test.mp4&t=unicast&p=rtsp&ve=H265&w=1280&h=720"];
        SGVideoItem *item = [[SGVideoItem alloc] init];
        item.name = @"RSTP + H265: IPCamera unicast 1280x720";
        item.asset = [SGAsset assetWithURL:url];
        item.displayMode = SGDisplayModePlane;
        [items addObject:item];
    }
    {
        SGVideoItem *item = [[SGVideoItem alloc] init];
        item.name = @"I See Fire";
        item.asset = [SGAsset assetWithURL:i_see_fire];
        item.displayMode = SGDisplayModePlane;
        [items addObject:item];
    }
    {
        SGMutableAsset *asset = [[SGMutableAsset alloc] init];
        SGMutableTrack *track = [asset addTrack:SGMediaTypeVideo];
        SGSegment *segment = [SGSegment segmentWithURL:i_see_fire index:0];
        [track appendSegment:segment];
        
        SGVideoItem *item = [[SGVideoItem alloc] init];
        item.name = @"I See Fire, Video Track";
        item.asset = asset;
        item.displayMode = SGDisplayModePlane;
        [items addObject:item];
    }
    {
        SGMutableAsset *asset = [[SGMutableAsset alloc] init];
        SGMutableTrack *track = [asset addTrack:SGMediaTypeAudio];
        SGSegment *segment = [SGSegment segmentWithURL:i_see_fire index:1];
        [track appendSegment:segment];
        
        SGVideoItem *item = [[SGVideoItem alloc] init];
        item.name = @"I See Fire, Audio Track";
        item.asset = asset;
        item.displayMode = SGDisplayModePlane;
        [items addObject:item];
    }
    {
        CMTime scale = kCMTimeInvalid;
        CMTimeRange timeRange = CMTimeRangeMake(CMTimeMake(30, 1), CMTimeMake(10, 1));
        
        SGMutableAsset *asset = [[SGMutableAsset alloc] init];
        {
            SGMutableTrack *track = [asset addTrack:SGMediaTypeAudio];
            SGSegment *segment = [SGSegment segmentWithURL:i_see_fire index:1 timeRange:timeRange scale:scale];
            [track appendSegment:segment];
        }
        {
            SGMutableTrack *track = [asset addTrack:SGMediaTypeVideo];
            SGSegment *segment = [SGSegment segmentWithURL:i_see_fire index:0 timeRange:timeRange scale:scale];
            [track appendSegment:segment];
        }
        
        SGVideoItem *item = [[SGVideoItem alloc] init];
        item.name = @"I See Fire, Range: 30s-40s";
        item.asset = asset;
        item.displayMode = SGDisplayModePlane;
        [items addObject:item];
    }
    {
        CMTime scale = CMTimeMake(1, 2);
        CMTimeRange timeRange = CMTimeRangeMake(CMTimeMake(30, 1), CMTimeMake(20, 1));
        
        SGMutableAsset *asset = [[SGMutableAsset alloc] init];
        {
            SGMutableTrack *track = [asset addTrack:SGMediaTypeAudio];
            SGSegment *segment = [SGSegment segmentWithURL:i_see_fire index:1 timeRange:timeRange scale:scale];
            [track appendSegment:segment];
        }
        {
            SGMutableTrack *track = [asset addTrack:SGMediaTypeVideo];
            SGSegment *segment = [SGSegment segmentWithURL:i_see_fire index:0 timeRange:timeRange scale:scale];
            [track appendSegment:segment];
        }
        
        SGVideoItem *item = [[SGVideoItem alloc] init];
        item.name = @"I See Fire, Range: 30s-50s, Scale: 0.5";
        item.asset = asset;
        item.displayMode = SGDisplayModePlane;
        [items addObject:item];
    }
    {
        SGMutableAsset *asset = [[SGMutableAsset alloc] init];
        {
            SGMutableTrack *track = [asset addTrack:SGMediaTypeAudio];
            SGSegment *segment1 = [SGURLSegment segmentWithURL:i_see_fire index:1];
            SGSegment *segment2 = [SGURLSegment segmentWithURL:google_help_vr index:1];
            [track appendSegment:segment1];
            [track appendSegment:segment2];
        }
        {
            SGMutableTrack *track = [asset addTrack:SGMediaTypeVideo];
            SGSegment *segment1 = [SGURLSegment segmentWithURL:i_see_fire index:0];
            SGSegment *segment2 = [SGURLSegment segmentWithURL:google_help_vr index:0];
            [track appendSegment:segment1];
            [track appendSegment:segment2];
        }
        
        SGVideoItem *item = [[SGVideoItem alloc] init];
        item.name = @"I See Fire + Google Help (Crashing)";
        item.asset = asset;
        item.displayMode = SGDisplayModePlane;
        [items addObject:item];
    }
    {
        SGMutableAsset *asset = [[SGMutableAsset alloc] init];
        {
            SGMutableTrack *track = [asset addTrack:SGMediaTypeAudio];
            SGSegment *segment1 = [SGSegment segmentWithDuration:CMTimeMake(5, 1)];
            SGSegment *segment2 = [SGSegment segmentWithURL:i_see_fire index:1];
            [track appendSegment:segment1];
            [track appendSegment:segment2];
        }
        {
            SGMutableTrack *track = [asset addTrack:SGMediaTypeVideo];
            SGSegment *segment1 = [SGSegment segmentWithDuration:CMTimeMake(5, 1)];
            SGSegment *segment2 = [SGSegment segmentWithURL:i_see_fire index:0];
            [track appendSegment:segment1];
            [track appendSegment:segment2];
        }
        
        SGVideoItem *item = [[SGVideoItem alloc] init];
        item.name = @"5s Padding + I See Fire";
        item.asset = asset;
        item.displayMode = SGDisplayModePlane;
        [items addObject:item];
    }
    {
        SGVideoItem *item = [[SGVideoItem alloc] init];
        item.name = @"Google Help VR";
        item.asset = [SGAsset assetWithURL:google_help_vr];
        item.displayMode = SGDisplayModeVR;
        [items addObject:item];
    }
    return items;
}

@end
