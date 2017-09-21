//
//  Deck.h
//  Matchismo
//
//  Created by Jason Wang on 2016/11/27.
//  Copyright © 2016年 wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Card;


@interface Deck : NSObject


- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (void)addCard:(Card *)card;
- (Card *)drawRandomCard;



@end
