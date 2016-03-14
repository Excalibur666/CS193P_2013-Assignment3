//
//  SetCardGame.m
//  Matchismo
//
//  Created by 王敏超 on 16/3/13.
//  Copyright © 2016年 Chao's Awesome App House. All rights reserved.
//

#import "SetCardGame.h"
#import "Card.h"
#import "Deck.h"

@interface SetCardGame ()
@property (nonatomic, strong) NSMutableArray *cards; // Of Card
@end



@implementation SetCardGame

- (NSMutableArray*)history{
    if (!_history) {
        _history = [[NSMutableArray alloc] init];
    }
    return _history;
}

- (NSMutableArray*)cardsForSet{
    if (!_cardsForSet) {
        _cardsForSet = [[NSMutableArray alloc] init];
    }
    return _cardsForSet;
}

- (NSMutableArray*)cards{
    if (!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck*)deck{
    if ((self = [super init])) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
        }
    }
    return self;
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

- (Card*)cardAtIndex:(NSUInteger)index{
    return index < self.cards.count ? self.cards[index] : nil;
}


- (void)chooseCardAtIndex:(NSUInteger)index{
    self.currentCard = [self cardAtIndex:index]; // card chosen now
    self.cardsForSet = nil; // clear cardsForSet before
    int countForSet = 2; // there are 2 cards should be put in cardsForSet
    BOOL failToMatchWhenThreeCardsSelected = NO;
    self.scoreChange = 0;
    
    if (self.currentCard.chosen) {
        self.currentCard.chosen = NO;
    } else {
        for (Card *otherCard in self.cards) {
            if (otherCard.isChosen && !otherCard.matched) {
                [self.cardsForSet addObject:otherCard]; // cards chosen before will be added
                countForSet--;
                
                if (!countForSet) {  // 3-cards selected! let's match!
                    int scoreForSet = [self.currentCard match:self.cardsForSet];
                    if (scoreForSet) {
                        for (Card *card in self.cardsForSet) {
                            card.matched = YES;
                        }
                        self.currentCard.matched = YES;
                        self.scoreChange += scoreForSet * MATCH_BONUS;
                    } else {
                        for (Card *card in self.cardsForSet) {
                            card.chosen = NO;
                        }
                        failToMatchWhenThreeCardsSelected = YES;
                        self.scoreChange -= MISMATCH_PENALTY;
                    }
                    break;
                }
            }
            
        }
        if (!failToMatchWhenThreeCardsSelected) {
            self.currentCard.chosen = YES;
        }
        self.score += self.scoreChange;
        self.score -= COST_TO_CHOOSE;
    }
}





@end
