//
//  CustomTableViewCell.m
//  CoderNews
//
//  Created by Matt Hodges on 5/5/13.
//  Copyright (c) 2013 Matt Hodges. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

@synthesize ribbon;

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if(self) {
        UIImage* ribbonImage = [UIImage imageNamed:@"ribbon.png"];
        self.ribbon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        [self.ribbon setImage:ribbonImage];
        [self addSubview:self.ribbon];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
