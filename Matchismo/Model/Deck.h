//
//  Deck.h
//  Matchismo
//
//  Created by 王敏超 on 16/3/10.
//  Copyright © 2016年 Chao's Awesome App House. All rights reserved.
//
// 声明一个卡组包含的方法
#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card*)card atTop:(BOOL)atTop;

- (void)addCard:(Card*)card;

- (Card*)drawRandomCard;

@end
