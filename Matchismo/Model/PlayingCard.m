//
//  PlayingCard.m
//  Matchismo
//
//  Created by 王敏超 on 16/3/10.
//  Copyright © 2016年 Chao's Awesome App House. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

@synthesize suit = _suit;


- (int)match:(NSArray *)otherCards{
    
    int score = 0;

    NSMutableArray *allCards = [otherCards mutableCopy];
    [allCards addObject:self];
    
    for (PlayingCard *card in allCards) {
        NSUInteger index = [allCards indexOfObject:card];
        for (; index < allCards.count - 1; index++) {
            PlayingCard *otherCard = allCards[index + 1];
            if (card.rank == otherCard.rank) {
                score += 4;
            } else if ([card.suit isEqualToString:otherCard.suit]){
                score += 1;
            }
        }
    }
  
    return score;
}



- (NSString*)contents{
    
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}



- (void)setSuit:(NSString *)suit{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}


- (NSString*)suit{
    return _suit ? _suit : @"?";
}


+ (NSArray*)validSuits{
    
    return @[@"♠︎", @"♣︎", @"♥︎", @"♦︎"];
}

+ (NSArray*)rankStrings{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+ (NSUInteger)maxRank{
    
    return [[self rankStrings] count] - 1;
}

@end
