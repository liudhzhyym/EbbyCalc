//
//  EWCMathTests.m
//  EbbyCalcTests
//
//  Created by Ansel Rognlie on 11/3/19.
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

#import <XCTest/XCTest.h>
#import "../EbbyCalc/NSDecimalNumber+EWCMathCategory.h"

typedef struct {
  NSDecimalNumber *in;
  NSDecimalNumber *out;
} EWCNumberInOutTestCase;

static NSDecimalNumber *makeDecimal(double d) {
  return [[NSDecimalNumber alloc] initWithDouble:d];
}

@interface EWCMathTests : XCTestCase

@end

@implementation EWCMathTests

-(void)testSqrt {
  NSDecimalNumber *value, *result;
  EWCNumberInOutTestCase cases[] = {
    { [NSDecimalNumber zero], [NSDecimalNumber zero] },
    { [NSDecimalNumber one], [NSDecimalNumber one] },
    { makeDecimal(-1), [NSDecimalNumber notANumber] },
  };
  const int NUM_CASES = sizeof(cases) / sizeof(0[cases]);

  NSDecimalNumberHandler *handler = [NSDecimalNumberHandler
    decimalNumberHandlerWithRoundingMode:NSRoundPlain
    scale:10 raiseOnExactness:NO
    raiseOnOverflow:NO
    raiseOnUnderflow:NO
    raiseOnDivideByZero:NO];

  for (int i = 0; i < NUM_CASES; ++i) {
    value = cases[i].in;
    result = [value ewc_decimalNumberBySqrt];
    XCTAssertEqualObjects(result, cases[i].out, @"SQRT(%@)", value);
  }

  // check a bunch of numbers
  for (int i = 2; i < 500; ++i) {
    double d = i * i;
    double input = d * d;
    value = makeDecimal(input);
    result = [value ewc_decimalNumberBySqrtWithBehavior:handler];

    XCTAssertEqualObjects(result, makeDecimal(d), @"SQRT(%@)", value);
  }
}

- (void)testDigitClamp {
  NSDecimalNumber *num, *clamp;
  NSString *str;

  // positive

  num = [NSDecimalNumber decimalNumberWithMantissa:314 exponent:0 isNegative:NO]; // 314
  clamp = [num ewc_decimalNumberByRestrictingToDigits:2];
  XCTAssertNil(clamp, @"%@ doesn't fit in 2 digits", num);

  num = [NSDecimalNumber decimalNumberWithMantissa:314 exponent:-1 isNegative:NO]; // 31.4
  clamp = [num ewc_decimalNumberByRestrictingToDigits:2];
  str = [clamp stringValue];
  XCTAssertEqualObjects(@"31", str, @"should have dropped all decimals");

  num = [NSDecimalNumber decimalNumberWithMantissa:314 exponent:-2 isNegative:NO]; // 3.14
  clamp = [num ewc_decimalNumberByRestrictingToDigits:2];
  str = [clamp stringValue];
  XCTAssertEqualObjects(@"3.1", str, @"should have one decimal digit");

  num = [NSDecimalNumber decimalNumberWithMantissa:314 exponent:-3 isNegative:NO]; // 0.314
  clamp = [num ewc_decimalNumberByRestrictingToDigits:2];
  str = [clamp stringValue];
  XCTAssertEqualObjects(@"0.3", str, @"should have one decimal digit");

  num = [NSDecimalNumber decimalNumberWithMantissa:314 exponent:-4 isNegative:NO]; // 0.0314
  clamp = [num ewc_decimalNumberByRestrictingToDigits:2];
  str = [clamp stringValue];
  XCTAssertEqualObjects(@"0", str, @"should clamp to zero");

  // negative

  num = [NSDecimalNumber decimalNumberWithMantissa:314 exponent:0 isNegative:YES]; // -314
  clamp = [num ewc_decimalNumberByRestrictingToDigits:2];
  XCTAssertNil(clamp, @"%@ doesn't fit in 2 digits", num);

  num = [NSDecimalNumber decimalNumberWithMantissa:314 exponent:-1 isNegative:YES]; // -31.4
  clamp = [num ewc_decimalNumberByRestrictingToDigits:2];
  str = [clamp stringValue];
  XCTAssertEqualObjects(@"-31", str, @"should have dropped all decimals");

  num = [NSDecimalNumber decimalNumberWithMantissa:314 exponent:-2 isNegative:YES]; // -3.14
  clamp = [num ewc_decimalNumberByRestrictingToDigits:2];
  str = [clamp stringValue];
  XCTAssertEqualObjects(@"-3.1", str, @"should have one decimal digit");

  num = [NSDecimalNumber decimalNumberWithMantissa:314 exponent:-3 isNegative:YES]; // -0.314
  clamp = [num ewc_decimalNumberByRestrictingToDigits:2];
  str = [clamp stringValue];
  XCTAssertEqualObjects(@"-0.3", str, @"should have one decimal digit");

  num = [NSDecimalNumber decimalNumberWithMantissa:314 exponent:-4 isNegative:YES]; // -0.0314
  clamp = [num ewc_decimalNumberByRestrictingToDigits:2];
  str = [clamp stringValue];
  XCTAssertEqualObjects(@"0", str, @"should clamp to zero");

}

@end
