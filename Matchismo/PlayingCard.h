//
//  PlayingCard.h
//  Matchismo
//
//  Created by Jason Wang on 2016/11/27.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (nonatomic, strong) NSString *suit;
@property (nonatomic) NSUInteger rank;

- (instancetype )initWithRank:(NSInteger)rank suit:(NSString *)suit;
+ (NSArray *)validSuits;
+ (NSArray *)rankStrings;
+ (NSUInteger)maxRank;

@end
