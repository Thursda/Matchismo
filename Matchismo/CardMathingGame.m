//
//  CardMathingGame.m
//  Matchismo
//
//  Created by Jason Wang on 2016/11/28.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "CardMathingGame.h"
#import "Card.h"

@interface CardMathingGame()

@property (nonatomic, strong) NSMutableArray *cards;
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic)NSUInteger numOfMatch;

@property (nonatomic, strong) Card *firstChosenCard;
@property (nonatomic, strong) Card *secondChosenCard;
@property (nonatomic, strong) NSMutableArray *matchingCardsQueue;
@end

@implementation CardMathingGame

- (instancetype)initWithDeck:(Deck *)deck count:(NSUInteger)count type:(CardMatchingGameType)type{
    self = [super init];
    if (!self) return nil;
    
    switch (type) {
        case CardMatchingGameTypeTwo:
            self.numOfMatch = 2;
            break;
        case CardMatchingGameTypeThree:
            self.numOfMatch = 3;
            break;
    }
    for (int i = 0; i < count; i++) {
        Card *card = [deck drawRandomCard];
        if (card) {
            [self.cards addObject:card];
        }else{
            self = nil;
            break;
        }
    }
    return  self;
}

- (instancetype)initWithDeck:(Deck *)deck count:(NSUInteger)count{
   return [self initWithDeck:deck count:count type:CardMatchingGameTypeTwo];
}

- (NSMutableArray *)cards{
    if(!_cards){
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}
#pragma mark - Matching Card Queue Methods
- (NSMutableArray *)matchingCardsQueue{
    if (!_matchingCardsQueue) {
        _matchingCardsQueue = [NSMutableArray arrayWithCapacity:self.numOfMatch - 1];
    }
    return _matchingCardsQueue;
}

- (BOOL)isMatchingQueueFull{
    return [self.matchingCardsQueue count] == (self.numOfMatch - 1);
}
- (void)enQueue:(Card *)card{
    if([self isMatchingQueueFull]){
        Card *firtCard = [self.matchingCardsQueue firstObject];
        firtCard.chosen = NO;
        [self.matchingCardsQueue removeObjectAtIndex:0];
    }
    card.chosen = YES;
    [self.matchingCardsQueue addObject:card];
}

//- (Card *)deQueue{
//    Card *card = [self.matchingCardsQueue firstObject];
//    [self.matchingCardsQueue removeObjectAtIndex:0];
//    return card;
//}

- (void)removeChosenCard:(Card *)card{
    card.chosen = NO;
    [self.matchingCardsQueue removeObject:card];
}

- (void)setCardsMatchedAndEmptyQueue{
    [self.matchingCardsQueue enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [(Card *)obj setMatched:YES];
    }];
    [self.matchingCardsQueue removeAllObjects];
}

#pragma mark - Public Method
- (Card *)cardAtIndex:(NSUInteger)index{
    return (index < [self.cards count] ? [self.cards objectAtIndex:index] : nil);
}

static const int MATCH_BONUS = 4;
static const int MISMATCH_PENANITY = 2;
static const int COST_TO_CHOOSE = 1;

- (void)chooseCardAtIndex:(NSUInteger)index{
    if(index >= [self.cards count]) return;
    Card *card = [self.cards objectAtIndex:index];
    if (card.isMatched) return;
    
    //A chosen card is already in the mathing queue, dechosen and remove it. Else matching with the chosen cards or enqueue with it.
    if (card.isChosen) {
        [self removeChosenCard:card];
    }else{
        int matchScore = 0;
        if ([self isMatchingQueueFull]){
            matchScore = [card match:self.matchingCardsQueue];
            if (matchScore) { //match sucess, add bonus
                card.chosen = YES;
                card.matched = YES;
                [self setCardsMatchedAndEmptyQueue];
                self.score += matchScore * MATCH_BONUS;
            }else{// mis match, minus penanity
                self.score -= MISMATCH_PENANITY;
                [self enQueue:card];
            }
        }else{//didn't match, minus choosen cost
            [self enQueue:card];
            self.score -= COST_TO_CHOOSE;
        }
    }
}

// too complicated 
- (void)chooseCardAtIndex2:(NSUInteger)index{
    if(index >= [self.cards count]) return;
    
    Card *card = [self.cards objectAtIndex:index];
    if (card.isMatched) return;
    
    if (card.isChosen) {
        if (card == self.firstChosenCard) {
            self.firstChosenCard = self.secondChosenCard;
            self.secondChosenCard = nil;
        }
        card.chosen = NO;
    }else{
        //if there is zero or one card isChosen, add to chosen list
        // else if there two card is choosen, then compare current chosen card with those two.
        //      if match score is more then zero, set these tree cards' isMathed true;
        //      else set the fist choose card's isChosen false
        //-------------------
        if (self.firstChosenCard.isChosen && self.secondChosenCard.isChosen) {
            int matchScore = [card match:@[self.firstChosenCard, self.secondChosenCard]];
            if (matchScore) {
                self.firstChosenCard.matched = YES;
                self.secondChosenCard.matched = YES;
                card.matched = YES;
                self.firstChosenCard = nil;
                self.secondChosenCard = nil;
                
                self.score += matchScore * MATCH_BONUS;
            }else{
                self.firstChosenCard.chosen = NO;
                self.firstChosenCard = self.secondChosenCard;
                self.secondChosenCard = card;
                self.score -= MISMATCH_PENANITY;
            }
        }else{
            if (!self.firstChosenCard.isChosen) {
                self.firstChosenCard = card;
            }else{
                self.secondChosenCard = card;
            }
        }
        //-------------------
        /* two card Game
         for (Card *otherCard in self.cards) {
            
            if (otherCard.isChosen && !otherCard.isMatched) {
                int matchScore = [card match:@[otherCard]];
                if (matchScore) {
                    self.score += matchScore * MATCH_BONUS;
                    card.matched = YES;
                    otherCard.matched = YES;
                }else{
                    self.score -= MISMATCH_PENANITY;
                    otherCard.chosen = NO;
                }
                 break;
            }
        } */
        //-----------
        self.score -= COST_TO_CHOOSE;
        card.chosen = YES;
    }
}


@end

