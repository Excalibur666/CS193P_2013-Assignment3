//
//  SetCard.m
//  Matchismo
//
//  Created by 王敏超 on 16/3/13.
//  Copyright © 2016年 Chao's Awesome App House. All rights reserved.
//

#import "SetCard.h"

@interface SetCard ()
+ (NSArray*)validNumber;
@end


@implementation SetCard


@synthesize symbol = _symbol;
@synthesize shaping = _shaping;
@synthesize color = _color;

- (int)match:(NSArray*)otherCards{
    int score, countNumberMatchOrNot, countSymbolMatchOrNot, countShapingMatchOrNot, countColorMatchOrNot;
    countNumberMatchOrNot = 0;
    countSymbolMatchOrNot = 0;
    countShapingMatchOrNot = 0;
    countColorMatchOrNot = 0;
    NSMutableArray *allCards = [otherCards mutableCopy];
    [allCards addObject:self];
    
    for (int i = 0; i < allCards.count; i++) {
        for (int j = i + 1; j < allCards.count; j++) { // j is always bigger than i
            SetCard *card = allCards[i];
            SetCard *otherCard = allCards[j];
            
            if (card.number == otherCard.number) {
                countNumberMatchOrNot++;
            } else {
                countNumberMatchOrNot--;
            }
            
            if ([card.symbol isEqualToString:otherCard.symbol]) {
                countSymbolMatchOrNot++;
            } else {
                countSymbolMatchOrNot--;
            }
            
            if ([card.shaping isEqualToString:otherCard.shaping]) {
                countShapingMatchOrNot++;
            } else {
                countShapingMatchOrNot--;
            }
            
            if ([card.color isEqualToString:otherCard.color]) {
                countColorMatchOrNot++;
            } else {
                countColorMatchOrNot--;
            }
            
        }
    }
    
    score = 0;
    // Only when every figture is match or not match with each other, score is 1
    if (abs(countNumberMatchOrNot) == allCards.count && abs(countSymbolMatchOrNot) == allCards.count && abs(countShapingMatchOrNot) == allCards.count && abs(countColorMatchOrNot) == allCards.count){
        score = 4;
    }

    return score;
}



- (NSString*)symbol{
    return _symbol ? _symbol : @"?";
}

- (void)setSymbol:(NSString *)symbol{
    if ([[SetCard validSymbol] containsObject:symbol]) {
        _symbol = symbol;
    }
}

- (NSString*)shaping{
    return _shaping ? _shaping : @"?";
}

- (void)setShaping:(NSString *)shaping{
    if ([[SetCard validShaping] containsObject:shaping]) {
        _shaping = shaping;
    }
}

- (NSString*)color{
    return _color ? _color : @"?";
}

- (void)setColor:(NSString *)color{
    if ([[SetCard validColor] containsObject:color]) {
        _color = color;
    }
}




+ (NSArray*)validNumber{
    return @[@1, @2, @3];
}

+ (NSArray*)validSymbol{
    return @[@"▲", @"●", @"◼︎"];
}

+ (NSArray*)validShaping{
    return @[@"solid", @"striped", @"open"];
}


+ (NSArray*)validColor{
    return @[@"brown", @"purple", @"red"];
}

+ (NSUInteger)maxNumber{
    return [[SetCard validNumber] count];
}











@end
