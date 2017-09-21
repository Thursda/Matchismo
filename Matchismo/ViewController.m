//
//  ViewController.m
//  Matchismo
//
//  Created by Jason Wang on 2016/11/27.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "ViewController.h"
#import "Deck.h"
#import "PlayingCardDeck.h"
#import "Card.h"
#import "CardMathingGame.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *flipCountLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;

@property (nonatomic)NSUInteger flipCount;
//@property (nonatomic, strong) Deck *deck;
@property (nonatomic, strong) CardMathingGame *game;
@end

@implementation ViewController

- (CardMathingGame *)game{
    if (!_game) {
        _game = [[CardMathingGame alloc] initWithDeck:[self creatDeck]
                                                count:[self.cardButtons count]];
    }
    return _game;
}
- (IBAction)GameSwitch:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {//two cards game 
        self.game = [[CardMathingGame alloc] initWithDeck:[self creatDeck] count:[self.cardButtons count] type:CardMatchingGameTypeTwo];
    }else{//three Card Game
        self.game = [[CardMathingGame alloc] initWithDeck:[self creatDeck] count:[self.cardButtons count] type:CardMatchingGameTypeThree];
    }
    [self updateUI];
}

- (Deck *)creatDeck{
    return [[PlayingCardDeck alloc] init];
}

- (IBAction)touchNewGameButton:(UIBarButtonItem *)sender {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"重新开始新游戏？"
                                                                   message:@"重置游戏进度，开始新游戏。"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              self.game = [[CardMathingGame alloc] initWithDeck:[self creatDeck]
                                                                                                          count:[self.cardButtons count]];
                                                              [self updateUI];

                                                          }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    [alert addAction:defaultAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    }

- (IBAction)touchCardButton:(UIButton *)sender {
    NSUInteger index = [self.cardButtons indexOfObject:sender];
//    Card *card = [self.game cardAtIndex:index];
    [self.game chooseCardAtIndex:index];
    [self updateUI];
    
    
//    if ([[sender currentTitle] length]) {
//        [sender setBackgroundImage:[UIImage imageNamed:@"card_back"] forState:UIControlStateNormal];
//        [sender setTitle:@"" forState:UIControlStateNormal];
//    }else{
//        Card *randomCard = [self.deck drawRandomCard];
//        if (randomCard) {
//            [sender setBackgroundImage:[UIImage imageNamed:@"card_front"] forState:UIControlStateNormal];
//            [sender setTitle:randomCard.contents forState:UIControlStateNormal];
//            self.flipCount++;
//        }
//    }
}
- (void)updateUI{
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
       
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setEnabled:!card.isMatched];
    }
    self.flipCountLabel.text = [NSString stringWithFormat:@"Score:  %ld", self.game.score];
}

- (NSString *)titleForCard:(Card *) card{
    return card.isChosen ? card.contents :@"";
}
- (UIImage *)backgroundImageForCard:(Card *)card{
    return [UIImage imageNamed:card.isChosen ? @"card_front" : @"card_back"];
}

@end
