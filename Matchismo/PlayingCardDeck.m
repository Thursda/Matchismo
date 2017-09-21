//
//  PlayingCardDeck.m
//  Matchismo
//
//  Created by Jason Wang on 2016/11/27.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@implementation PlayingCardDeck

- (instancetype)init{
    self = [super init];
    if (self) {
        //初始化52张扑克
        for (int rank = 1; rank <= [PlayingCard maxRank]; rank++) {
            for (NSString *suit in [PlayingCard validSuits]) {
                PlayingCard *playingCard = [[PlayingCard alloc] initWithRank:rank suit:suit];
                [self addCard:playingCard];
            }
        }
    }
    return self;
}

@end
