//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by 王敏超 on 16/3/10.
//  Copyright © 2016年 Chao's Awesome App House. All rights reserved.
//

#import "CardMatchingGame.h"
#import "Deck.h"
#import "Card.h"

@interface CardMatchingGame ()

@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards; // of Card, UI上呈现多少的卡牌

@property (nonatomic, readwrite) NSInteger scoreChange;

@end



@implementation CardMatchingGame{
    NSInteger _mode;
}



- (NSMutableArray*)history{
    if (!_history) {
        _history = [[NSMutableArray alloc] init];
    }
    return _history;
}

- (void)setMode:(NSInteger)mode{
    _mode = mode; // 0 for 2-match-mode, 1 for 3-match-mode
}


- (NSMutableArray*)cards{
    if (!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}


- (NSMutableArray*)cardsForMatch{
    if (!_cardsForMatch) {
        _cardsForMatch = [[NSMutableArray alloc] init];
    }
    return _cardsForMatch;
}

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck{
    if ((self = [super init])) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard]; // different cards
            if (card){
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
        }
    }
    return self;
}

- (Card*)cardAtIndex:(NSUInteger)index{
    return (index < self.cards.count) ? self.cards[index] : nil;
}



static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

- (void)chooseCardAtIndex:(NSUInteger)index{
    
    self.currentCard = [self cardAtIndex:index];
    self.scoreChange = 0;
    self.cardsForMatch = nil; // 清空以前的记录
    NSUInteger indexForMatch = _mode;
    
    if (!self.currentCard.isMatched) {   // 选的没match的牌
        if (self.currentCard.isChosen) {
            // chosen card
            self.currentCard.chosen = NO;
            self.currentCard = nil;
        } else {
            // match against other chosen cards
            // not chosen card
            for (Card *otherCard in self.cards) {
                // match with chosen and not matched card
                if (otherCard.isChosen && !otherCard.isMatched) {
                    [self.cardsForMatch addObject:otherCard]; // 把chosen的和not matched的牌加入数组
                    if (!indexForMatch) { // 选的卡数indexForMatch才为0
                        int matchScore = [self.currentCard match:self.cardsForMatch];
                        if (matchScore) {
                            self.scoreChange = matchScore * MATCH_BONUS;
                            self.score += matchScore * MATCH_BONUS;
                            self.currentCard.matched = YES;
                            for (Card *cardForMatch in self.cardsForMatch) {
                                cardForMatch.matched = YES;
                            }
                        } else {
                            self.scoreChange = -MISMATCH_PENALTY;
                            self.score -= MISMATCH_PENALTY;
                            for (Card *cardForMatch in self.cardsForMatch) {
                                cardForMatch.chosen = NO;
                            }
                        }
                        break; // can only choose 2 cards for now
                    }
                    indexForMatch--;
                }
            }
            self.score -= COST_TO_CHOOSE;
            self.currentCard.chosen = YES;
        }
    }
    [self updateHistoryNotes];
}


- (void)updateHistoryNotes{
    
    NSString *currentNote = @"";
    if (self.scoreChange == 0) {
        if (self.currentCard) {
            currentNote = self.currentCard.contents;
        } else {
            currentNote = @"";
        }
    } else {
        NSString *str = @"";
        for (Card *card in self.cardsForMatch) {
            str = [str stringByAppendingString:card.contents];
            str = [str stringByAppendingString:@" "];
        }
        
        if (self.scoreChange > 0){
            currentNote = [NSString stringWithFormat:@"Matched %@ %@ for %ld points.", str, self.currentCard.contents, self.scoreChange];
        } else {
            currentNote = [NSString stringWithFormat:@"%@ %@ don't matched! 2 points penalty!", str, self.currentCard.contents];
        }
    }
//    [self.historyNotes addObject:currentNote];

}



@end
