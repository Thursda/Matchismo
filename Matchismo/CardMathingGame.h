//
//  CardMathingGame.h
//  Matchismo
//
//  Created by Jason Wang on 2016/11/28.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "Deck.h"

typedef NS_ENUM(NSUInteger, CardMatchingGameType) {
    CardMatchingGameTypeTwo,
    CardMatchingGameTypeThree,
};

@interface CardMathingGame : NSObject

@property (nonatomic, readonly) NSInteger score;

- (instancetype)initWithDeck:(Deck *)deck count:(NSUInteger)count;

- (instancetype)initWithDeck:(Deck *)deck count:(NSUInteger)count type:(CardMatchingGameType)type;

- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

@end
