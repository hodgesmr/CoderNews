//
//  StoryInfo.h
//  CoderNews
//
//  Created by hodgesmr on 2/3/13.
//  Copyright (c) 2013 Matt Hodges. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface StoryInfo : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * visited;

@end
