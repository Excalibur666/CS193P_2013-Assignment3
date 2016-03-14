//
//  SetCardDeck.m
//  Matchismo
//
//  Created by 王敏超 on 16/3/13.
//  Copyright © 2016年 Chao's Awesome App House. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck


- (instancetype)init{
    if ((self = [super init])) {
        for (NSString *symbol in [SetCard validSymbol]) {
            for (NSString *shaping in [SetCard validShaping]) {
                for (NSString *color in [SetCard validColor]) {
                    for (int number = 1; number <= [SetCard maxNumber]; number++) {
                        SetCard *setCard = [[SetCard alloc] init];
                        setCard.number = number;
                        setCard.symbol = symbol;
                        setCard.shaping = shaping;
                        setCard.color = color;
                        
                        [self addCard:setCard];
                    }
                }
            }
        }
    }

    return self;
}





@end
