//
//  EWCGridLayoutRoundedButton.h
//  HomeCalculator
//
//  Created by Ansel Rognlie on 11/9/19.
//  Copyright © 2019 Ansel Rognlie. All rights reserved.
//

//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.

#import "EWCRoundedCornerButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface EWCAccessibleRoundedCornerButton : EWCRoundedCornerButton

+ (instancetype)buttonLabeled:(NSString *)label colored:(UIColor *)color backgroundColor:(UIColor *)backgroundColor;

- (instancetype)initWithLabel:(NSString *)label color:(UIColor *)color backgroundColor:(UIColor *)backgroundColor;

@end

NS_ASSUME_NONNULL_END
