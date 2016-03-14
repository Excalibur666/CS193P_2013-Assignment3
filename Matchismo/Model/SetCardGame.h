//
//  SetCardGame.h
//  Matchismo
//
//  Created by 王敏超 on 16/3/13.
//  Copyright © 2016年 Chao's Awesome App House. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Deck;
@class Card;


@interface SetCardGame : NSObject

@property (nonatomic) NSInteger score;
@property (nonatomic, strong) NSMutableArray *history;
@property (nonatomic, strong) Card *currentCard;
@property (nonatomic) NSInteger scoreChange;
@property (nonatomic, strong) NSMutableArray *cardsForSet; // Of Card


- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck*)deck;

- (Card*)cardAtIndex:(NSUInteger)index;
- (void)chooseCardAtIndex:(NSUInteger)index;




@end
