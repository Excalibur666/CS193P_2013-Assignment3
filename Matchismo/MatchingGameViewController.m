//
//  ViewController.m
//  Matchismo
//
//  Created by 王敏超 on 16/3/9.
//  Copyright © 2016年 Chao's Awesome App House. All rights reserved.
//

#import "MatchingGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "CardMatchingGame.h"
#import "GameHistoryViewController.h"

@interface MatchingGameViewController ()
@property (nonatomic, strong) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;


- (IBAction)resetButton:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

//- (IBAction)representHistorySlider:(UISlider *)sender;
//@property (weak, nonatomic) IBOutlet UISlider *historySlider;




@end


@implementation MatchingGameViewController
//{
//    BOOL _isGameStarted;
//    NSUInteger _count; // count every changes at the detailLabel
//    NSUInteger _currentSliderIndex; // index of the slider
//}


- (void)viewDidLoad{
    [self resetGame];
}




- (CardMatchingGame*)game{
    
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
    }
    return _game;
}




- (Deck*)createDeck{
    return [[PlayingCardDeck alloc] init];
}


//- (void)updateHistorySlider{
//    
//    [self.historySlider setValue:_currentSliderIndex animated:YES];
//}



#pragma mark 辅助方法


// 根据给定的card和方向返回对应的NSMutableAttributedString
- (NSMutableAttributedString*)getAttributesForCard:(Card*)card{
    PlayingCard *playingCard = (PlayingCard*)card;
    
    NSString *string = card.contents;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange range = {0, string.length}; // only one character here
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    
    // color
    UIColor *color;
    if ([playingCard.suit isEqualToString:@"♠︎"] || [playingCard.suit isEqualToString:@"♣︎"]) {
        color = [UIColor blackColor];
    } else {
        color = [UIColor redColor];
    }
    
    // 上色
    [attributes addEntriesFromDictionary:@{NSForegroundColorAttributeName : [color colorWithAlphaComponent:1]}];

    
    [attributedString addAttributes:attributes range:range];
    return attributedString;
}


// 根据每个card取得的NSMutableAttributedString组成对应的提示
- (NSAttributedString*)getDetailAttributedString{
    NSMutableAttributedString *string;
    NSMutableAttributedString *currentCardString;
    
    string = [[NSMutableAttributedString alloc] init];
    currentCardString = [self getAttributesForCard:self.game.currentCard]; // current chosen card
    
    if (self.game.scoreChange) {
        NSMutableAttributedString *cardsForSetString = [[NSMutableAttributedString alloc] init];
        
        for (Card *card in self.game.cardsForMatch) {
            NSMutableAttributedString *attributedString = [self getAttributesForCard:card];
            [cardsForSetString appendAttributedString:attributedString];  // all cardForSet
            [cardsForSetString appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
        }
        
        if (self.game.scoreChange > 0) {
            [string appendAttributedString:[[NSAttributedString alloc] initWithString:@"Matched "]];
            [string appendAttributedString:cardsForSetString];
            [string appendAttributedString:currentCardString];
            [string appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" for %ld points.", self.game.scoreChange]]];
            
        } else {
            [string appendAttributedString:cardsForSetString];
            [string appendAttributedString:currentCardString];
            [string appendAttributedString:[[NSAttributedString alloc] initWithString:@" don't matched! 2 points penalty!"]];
        }
    } else {
        if (self.game.currentCard.chosen) {
            [string appendAttributedString:currentCardString];
        }
    }
    
    [self.game.history addObject:string];
    return string;
}


- (void)updateDetailLabel{
    //  只有当currentCard不为nil时才能更新detailLabel
    if (self.game.currentCard) {
        NSAttributedString *string = [self getDetailAttributedString];
        self.detailLabel.attributedText = string;
    } else {
        self.detailLabel.text = @"";
    }
}

- (void)updateUI{
    
    for (UIButton *cardButton in self.cardButtons) {
        NSUInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
    }
//    [self updateHistorySlider];
    [self updateDetailLabel];
}






- (NSString*)titleForCard:(Card*)card{
    
    return card.isChosen ? card.contents : @"";
}

- (UIImage*)backgroundImageForCard:(Card*)card{
    
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

- (void)resetGame{
    //    _isGameStarted = NO;
    // init the first note
    //    [self.game.historyNotes addObject:@"Let the game begin!!!"];
    //    _currentSliderIndex = 0; // index begin with 0
    //    _count = 1; // count begin with 1
    //    [self.historySlider setValue:_currentSliderIndex animated:YES];
    //    self.cardModeControl.enabled = YES;
    
    self.game = nil;
    [self updateUI];
}

#pragma mark 动作方法

- (IBAction)resetButton:(UIButton *)sender {
    
    [self resetGame];
}

- (IBAction)touchCardButton:(UIButton *)sender {
    NSUInteger chooseButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chooseButtonIndex];    // lazy instantiation, instead of init method
    
    //    _count++;
    //    _currentSliderIndex++; // count and index increase when tap a card
    
    [self updateUI];
    
    //    if (!_isGameStarted) {
    //        _isGameStarted = YES;
    //        self.cardModeControl.enabled = NO;
    //        [self.game setMode:self.cardModeControl.selectedSegmentIndex]; // index begin with 0, 0 for 2-match-mode, 1 for 3-match-mode
    //    }
    
}

//- (IBAction)representHistorySlider:(UISlider *)sender {
//    
//    self.detailLabel.alpha = 1;
//    _currentSliderIndex = self.historySlider.value;
//    NSString *history = @""; // when value is bigger than count
//    if (_currentSliderIndex < _count && _count > 1) { // that is history not current index
//        history = self.game.historyNotes[_currentSliderIndex];
//        self.detailLabel.alpha = 0.5f;
//    }
//    self.detailLabel.text = history;
//    _currentSliderIndex = _count - 1;
//}

#pragma mark segue

- (void)prepareForSegue:(nonnull UIStoryboardSegue *)segue sender:(nullable id)sender{
    if ([segue.identifier isEqualToString:@"ShowMatchHistory"]) {
        GameHistoryViewController *historyController = segue.destinationViewController;
        historyController.history = self.game.history;
    }
}

@end
