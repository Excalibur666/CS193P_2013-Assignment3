//
//  SetGameViewController.m
//  Matchismo
//
//  Created by 王敏超 on 16/3/13.
//  Copyright © 2016年 Chao's Awesome App House. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCardGame.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "GameHistoryViewController.h"

@interface SetGameViewController ()
@property (strong, nonatomic) SetCardGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
- (IBAction)resetGame:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end

@implementation SetGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self updateUI];
}


- (Deck*)createDeck{
    return [[SetCardDeck alloc] init];
}

- (SetCardGame*)game{
    if (!_game) {
        _game = [[SetCardGame alloc] initWithCardCount:self.cardButtons.count usingDeck:[self createDeck]];
    }
    return _game;
}


#pragma mark 辅助方法

- (UIImage*)backgroundImageForCard:(Card*)card{
    return card.chosen ? [UIImage imageNamed:@"yellowbg"] : [UIImage imageNamed:@"greybg"];
}


// 根据给定的card和方向返回对应的NSMutableAttributedString，由于卡牌为竖向，因此对应的长度不一样
- (NSMutableAttributedString*)getAttributesForCard:(Card*)card isProtrait:(BOOL)isProtrait{
    SetCard *setCard = (SetCard*)card;
    
    // symbol with numbers
    NSString *string;
    if (isProtrait) {
        if (setCard.number == 1) {
            string = setCard.symbol;
        } else if (setCard.number == 2) {
            string = [setCard.symbol stringByAppendingString:[NSString stringWithFormat:@"\n%@", setCard.symbol]];
        } else {
            string = [setCard.symbol stringByAppendingString:[NSString stringWithFormat:@"\n%@\n%@", setCard.symbol, setCard.symbol]];
        }
    } else {
        if (setCard.number == 1) {
            string = setCard.symbol;
        } else if (setCard.number == 2) {
            string = [setCard.symbol stringByAppendingString:setCard.symbol];
        } else {
            string = [setCard.symbol stringByAppendingString:[NSString stringWithFormat:@"%@%@", setCard.symbol, setCard.symbol]];
        }
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange range = {0, string.length}; // only one character here
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    
    // color
    UIColor *color;
    if ([setCard.color isEqualToString:@"brown"]) {
        color = [UIColor brownColor];
    } else if ([setCard.color isEqualToString:@"purple"]){
        color = [UIColor purpleColor];
    } else {
        color = [UIColor redColor];
    }
    
    // shaping
    if ([setCard.shaping isEqualToString:@"solid"]) {
        [attributes addEntriesFromDictionary:@{NSForegroundColorAttributeName : [color colorWithAlphaComponent:1], NSStrokeWidthAttributeName : @-10, NSStrokeColorAttributeName  : color}];
    } else if ([setCard.shaping isEqualToString:@"striped"]) {
        [attributes addEntriesFromDictionary:@{NSForegroundColorAttributeName : [color colorWithAlphaComponent:0.3], NSStrokeWidthAttributeName : @-10, NSStrokeColorAttributeName : color}];
    } else if ([setCard.shaping isEqualToString:@"open"]){
        [attributes addEntriesFromDictionary:@{NSForegroundColorAttributeName : [color colorWithAlphaComponent:0], NSStrokeWidthAttributeName : @-10, NSStrokeColorAttributeName  : color}];
    }
    
    [attributedString addAttributes:attributes range:range];
    return attributedString;
}


- (void)updateButton:(UIButton*)button forCard:(Card*)card{
    NSMutableAttributedString *attributedString = [self getAttributesForCard:card isProtrait:YES];
    [button setAttributedTitle:attributedString forState:UIControlStateNormal];
}

// 根据每个card取得的NSMutableAttributedString组成对应的提示
- (NSAttributedString*)getDetailAttributedString{
    NSMutableAttributedString *string;
    NSMutableAttributedString *currentCardString;
    
    string = [[NSMutableAttributedString alloc] init];
    currentCardString = [self getAttributesForCard:self.game.currentCard isProtrait:NO]; // current chosen card
    
    if (self.game.scoreChange) {
        NSMutableAttributedString *cardsForSetString = [[NSMutableAttributedString alloc] init];
        
        for (Card *card in self.game.cardsForSet) {
            NSMutableAttributedString *attributedString = [self getAttributesForCard:card isProtrait:NO];
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


- (void)updateDetail{
    //  只有当currentCard不为nil时才能更新detailLabel
    if (self.game.currentCard) {
        NSAttributedString *string = [self getDetailAttributedString];
        self.detailLabel.attributedText = string;
    } else {
        self.detailLabel.text = @"";
    }
}

- (void)updateScore{
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];
}

- (void)updateUI{
    for (UIButton *button in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:button]];
        [button setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        [self updateButton:button forCard:card];
        button.enabled = !card.matched;
    }
    [self updateDetail];
    [self updateScore];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark 动作方法

- (IBAction)touchCardButton:(UIButton *)sender {
    NSUInteger chooseCardIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chooseCardIndex];
    [self updateUI];
}


- (IBAction)resetGame:(UIButton *)sender {
    self.game = nil;
    [self updateUI];
}


#pragma mark segue

- (void)prepareForSegue:(nonnull UIStoryboardSegue *)segue sender:(nullable id)sender{
    if ([segue.identifier isEqualToString:@"ShowSetHistory"]) {
        GameHistoryViewController *historyController = segue.destinationViewController;
        historyController.history = self.game.history;
    }
}
@end
