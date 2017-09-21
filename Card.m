//
//  Card.m
//  Matchismo
//
//  Created by Jason Wang on 2016/11/27.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "Card.h"

@implementation Card

- (int)match:(NSArray *)cards{
    int score = 0;
    
    for (Card *card in cards) {
        if([self.contents isEqualToString:card.contents]){
            score = 1;
        }
    }
    return score;
}

@end
