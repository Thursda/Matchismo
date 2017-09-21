//
//  PlayingCard.m
//  Matchismo
//
//  Created by Jason Wang on 2016/11/27.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard
@synthesize suit = _suit;

- (instancetype)initWithRank:(NSInteger)rank suit:(NSString *)suit{
    self = [super init];
    self.rank = rank;
    self.suit = suit;
    
    return self;
}

- (int)match:(NSArray *)cards{
    int score = 0;
    if ([cards count] == 1) {
        PlayingCard *otherCard = [cards firstObject];
        score = [self scoreOfMatchCard:otherCard];
    }else if([cards count] == 2){
        PlayingCard *firstCard = cards[0];
        PlayingCard *secondCard = cards[1];
        
        //tree cards match, same suit or same rank
        if ([firstCard.suit isEqualToString:secondCard.suit] && [secondCard.suit isEqualToString: self.suit]) {
            score = 3;
        }else if (firstCard.rank == secondCard.rank && secondCard.rank == self.rank){
            score = 12;
        }else{  //two cards match
            int score1 = [self scoreOfMatchCard:firstCard];
            int score2 = [self scoreOfMatchCard:secondCard];
            int score3 = [firstCard scoreOfMatchCard:secondCard];
            score = (score1 > score2) ? score1 : score2;
            score = (score > score3) ? score : score3;
        }
    }
    return score;
}

- (int)scoreOfMatchCard:(PlayingCard *)card{
    int score = 0;
    if (self.rank == card.rank) {
        score = 4;
    } else if([self.suit isEqualToString:card.suit]) {
        score = 1;
    }
    return score;
}


+ (NSArray *)rankStrings{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}
+ (NSUInteger)maxRank{
    return ([[PlayingCard rankStrings] count] - 1);
}

- (void)setRank:(NSUInteger)rank{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

- (NSString *)contents{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

+ (NSArray *)validSuits{
    return @[@"♠︎", @"♣︎", @"♥︎", @"♦︎"];
}
- (void)setSuit:(NSString *)suit{
    if([[PlayingCard validSuits] containsObject:suit]){
        _suit = suit;
    }
}

- (NSString *)suit{
    return _suit ? _suit : @"";
}


@end
