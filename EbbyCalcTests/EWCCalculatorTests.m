//
//  EWCCalculatorTests.m
//  EbbyCalcTests
//
//  Created by Ansel Rognlie on 11/1/19.
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
#import "../EbbyCalc/EWCCalculator.h"

@interface EWCCalculatorTests : XCTestCase {
  EWCCalculator *_calculator;
}

@end

@implementation EWCCalculatorTests

- (void)applyKeys:(NSArray *)keys {
  for (id value in keys) {
    EWCCalculatorKey key = (EWCCalculatorKey)[(NSNumber *)value intValue];
    [_calculator pressKey:key];
  }
}

- (void)binaryOperation:(EWCCalculatorKey)op {
  [self applyKeys:@[
    @(EWCCalculatorThreeKey),
    @(op),
    @(EWCCalculatorTwoKey),
  ]];
}

- (void)binaryCalculation:(EWCCalculatorKey)op {
  [self binaryOperation:op];
  [self applyKeys:@[@(EWCCalculatorEqualKey)]];
}

- (void)helperForUnaryOperation:(EWCCalculatorKey)op
  forDigit:(EWCCalculatorKey)digit
  withResults:(NSArray *)results {
  [self applyKeys:@[
    @(digit),
    @(op),
  ]];
  for (NSString *result in results) {
    [self applyKeys:@[@(EWCCalculatorEqualKey)]];
    XCTAssertEqualObjects(_calculator.displayContent, result);
  }
}

- (void)helperForChainedOperation:(EWCCalculatorKey)op
  withResults:(NSArray *)results {
  [self binaryOperation:op];
  for (NSString *result in results) {
    [self applyKeys:@[@(EWCCalculatorEqualKey)]];
    XCTAssertEqualObjects(_calculator.displayContent, result);
  }
}

- (void)helperForMultipleOperation:(EWCCalculatorKey)op
  withResult:(NSString *)result {
  [self binaryOperation:EWCCalculatorMultiplyKey];
  [self applyKeys:@[
    @(op),
    @(EWCCalculatorTwoKey),
    @(EWCCalculatorEqualKey),
  ]];
  XCTAssertEqualObjects(_calculator.displayContent, result);
}

- (void)setUp {
  _calculator = [EWCCalculator new];

  // make sure we test in en_US
  _calculator.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
//  _calculator.locale = [NSLocale localeWithLocaleIdentifier:@"ja_JP"];
//  _calculator.locale = [NSLocale localeWithLocaleIdentifier:@"fr_FR"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testNoInput {
  XCTAssertEqualObjects(_calculator.displayContent, @"0.");
}

- (void)testDigitInput {
  [self applyKeys:@[
    @(EWCCalculatorOneKey),
    @(EWCCalculatorZeroKey),
    @(EWCCalculatorTwoKey),
    @(EWCCalculatorThreeKey),
    @(EWCCalculatorFourKey),
    @(EWCCalculatorDecimalKey),
    @(EWCCalculatorFiveKey),
    @(EWCCalculatorSixKey),
    @(EWCCalculatorSevenKey),
    @(EWCCalculatorEightKey),
    @(EWCCalculatorSignKey),
    @(EWCCalculatorNineKey),
  ]];
  XCTAssertEqualObjects(_calculator.displayContent, @"-10,234.56789");
}

- (void)testAddOperation {
  [self binaryCalculation:EWCCalculatorAddKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"5.");
}

- (void)testSubtractOperation {
  [self binaryCalculation:EWCCalculatorSubtractKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"1.");
}

- (void)testMultiplyOperation {
  [self binaryCalculation:EWCCalculatorMultiplyKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"6.");
}

- (void)testDivideOperation {
  [self binaryCalculation:EWCCalculatorDivideKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"1.5");
}

- (void)testUnaryAddOperation {
  [self helperForUnaryOperation:EWCCalculatorAddKey forDigit:EWCCalculatorThreeKey withResults:@[
    @"3.",
    @"6.",
    @"9.",
  ]];
}

- (void)testUnarySubtractOperation {
  [self helperForUnaryOperation:EWCCalculatorSubtractKey forDigit:EWCCalculatorThreeKey withResults:@[
    @"-3.",
    @"-6.",
    @"-9.",
  ]];
}

- (void)testUnaryMultiplyOperation {
  [self helperForUnaryOperation:EWCCalculatorMultiplyKey forDigit:EWCCalculatorThreeKey withResults:@[
    @"9.",
    @"27.",
    @"81.",
  ]];
}

- (void)testUnaryDivideOperation {
  [self helperForUnaryOperation:EWCCalculatorDivideKey forDigit:EWCCalculatorTwoKey withResults:@[
    @"0.5",
    @"0.25",
    @"0.125",
  ]];
}

- (void)testChainedAddOperation {
  [self helperForChainedOperation:EWCCalculatorAddKey withResults:@[
    @"5.",
    @"7.",
    @"9.",
  ]];
}

- (void)testChainedSubtractOperation {
  [self helperForChainedOperation:EWCCalculatorSubtractKey withResults:@[
    @"1.",
    @"-1.",
    @"-3.",
  ]];
}

- (void)testChainedMultiplyOperation {
  [self helperForChainedOperation:EWCCalculatorMultiplyKey withResults:@[
    @"6.",
    @"12.",
    @"24.",
  ]];
}

- (void)testChainedDivideOperation {
  [self helperForChainedOperation:EWCCalculatorDivideKey withResults:@[
    @"1.5",
    @"0.75",
    @"0.375",
  ]];
}

- (void)testMultipleAddOperation {
  [self helperForMultipleOperation:EWCCalculatorAddKey withResult:@"8."];
}

- (void)testMultipleSubtractOperation {
  [self helperForMultipleOperation:EWCCalculatorSubtractKey withResult:@"4."];
}

- (void)testMultipleMultiplyOperation {
  [self helperForMultipleOperation:EWCCalculatorMultiplyKey withResult:@"12."];
}

- (void)testMultipleDivideOperation {
  [self helperForMultipleOperation:EWCCalculatorDivideKey withResult:@"3."];
}

- (void)testChainedMultiplyWithSignChange {
  [self applyKeys:@[
    @(EWCCalculatorThreeKey),
    @(EWCCalculatorMultiplyKey),
    @(EWCCalculatorThreeKey),
    @(EWCCalculatorMultiplyKey),
    @(EWCCalculatorSignKey),
    @(EWCCalculatorEqualKey),
  ]];
  XCTAssertEqualObjects(_calculator.displayContent, @"-81.");
}

- (void)testChainedAddWithSignChange {
  [self applyKeys:@[
    @(EWCCalculatorThreeKey),
    @(EWCCalculatorMultiplyKey),
    @(EWCCalculatorThreeKey),
    @(EWCCalculatorAddKey),
    @(EWCCalculatorSignKey),
    @(EWCCalculatorEqualKey),
  ]];
  XCTAssertEqualObjects(_calculator.displayContent, @"0.");
}

// need other operator variants

- (void)testUnaryMultiplyWithSignChange {
  [self applyKeys:@[
    @(EWCCalculatorThreeKey),
    @(EWCCalculatorMultiplyKey),
    @(EWCCalculatorThreeKey),
    @(EWCCalculatorEqualKey),
    @(EWCCalculatorSignKey),
    @(EWCCalculatorEqualKey),
  ]];
  XCTAssertEqualObjects(_calculator.displayContent, @"-27.");
}

- (void)testUnaryAddWithSignChange {
  [self applyKeys:@[
    @(EWCCalculatorThreeKey),
    @(EWCCalculatorAddKey),
    @(EWCCalculatorThreeKey),
    @(EWCCalculatorEqualKey),
    @(EWCCalculatorSignKey),
    @(EWCCalculatorEqualKey),
  ]];
  XCTAssertEqualObjects(_calculator.displayContent, @"-3.");
}

// need other operator variants

- (void)testContinuedMultiplyWithSignChange {
  [self applyKeys:@[
    @(EWCCalculatorThreeKey),
    @(EWCCalculatorMultiplyKey),
    @(EWCCalculatorThreeKey),
    @(EWCCalculatorEqualKey),
    @(EWCCalculatorSignKey),
    @(EWCCalculatorMultiplyKey),
    @(EWCCalculatorThreeKey),
    @(EWCCalculatorEqualKey),
  ]];
  XCTAssertEqualObjects(_calculator.displayContent, @"-27.");
}

- (void)testContinuedAddWithSignChange {
  [self applyKeys:@[
    @(EWCCalculatorThreeKey),
    @(EWCCalculatorMultiplyKey),
    @(EWCCalculatorThreeKey),
    @(EWCCalculatorEqualKey),
    @(EWCCalculatorSignKey),
    @(EWCCalculatorAddKey),
    @(EWCCalculatorThreeKey),
    @(EWCCalculatorEqualKey),
  ]];
  XCTAssertEqualObjects(_calculator.displayContent, @"-6.");
}

- (void)testSimpleSqrt {
  [self applyKeys:@[
    @(EWCCalculatorFourKey),
    @(EWCCalculatorSqrtKey),
  ]];
  XCTAssertEqualObjects(_calculator.displayContent, @"2.");
}

- (void)testSimpleSqrtError {
  [self applyKeys:@[
    @(EWCCalculatorFourKey),
    @(EWCCalculatorSignKey),
    @(EWCCalculatorSqrtKey),
  ]];
  XCTAssertEqualObjects(_calculator.displayContent, @"2.");
  XCTAssertTrue(_calculator.hasError, @"Error should be visible");
}

- (void)testSimpleSqrtErrorResume {
  [self applyKeys:@[
    @(EWCCalculatorFourKey),
    @(EWCCalculatorSignKey),
    @(EWCCalculatorSqrtKey),
    @(EWCCalculatorClearKey),
    @(EWCCalculatorAddKey),
    @(EWCCalculatorFourKey),
    @(EWCCalculatorEqualKey),
  ]];
  XCTAssertEqualObjects(_calculator.displayContent, @"6.");
  XCTAssertFalse(_calculator.hasError, @"Error should NOT be visible");
}

- (void)testUnarySqrtErrorResume {
  [self applyKeys:@[
    @(EWCCalculatorOneKey),
    @(EWCCalculatorSubtractKey),
    @(EWCCalculatorEqualKey),
    @(EWCCalculatorEqualKey),
    @(EWCCalculatorEqualKey),
    @(EWCCalculatorEqualKey),
    @(EWCCalculatorSqrtKey),
    @(EWCCalculatorClearKey),
    @(EWCCalculatorAddKey),  // this is the step that errored in the past
  ]];
  XCTAssertEqualObjects(_calculator.displayContent, @"2.");  // this would error as 1 (the input)
  XCTAssertFalse(_calculator.hasError, @"Error should NOT be visible");

  [self applyKeys:@[
    @(EWCCalculatorFourKey),
    @(EWCCalculatorEqualKey),
  ]];
  XCTAssertEqualObjects(_calculator.displayContent, @"6.");
}

- (void)testTaxPlusDisplayBehavior {
  XCTAssertFalse(_calculator.isTaxPlusStatusVisible, @"tax plus should NOT be visible");
  XCTAssertFalse(_calculator.isTaxStatusVisible, @"tax should NOT be visible");
  [_calculator pressKey:EWCCalculatorTaxPlusKey];
  XCTAssertTrue(_calculator.isTaxPlusStatusVisible, @"tax plus SHOULD be visible");
  XCTAssertFalse(_calculator.isTaxStatusVisible, @"tax should NOT be visible");
  [_calculator pressKey:EWCCalculatorTaxPlusKey];
  XCTAssertFalse(_calculator.isTaxPlusStatusVisible, @"tax plus should NOT be visible");
  XCTAssertTrue(_calculator.isTaxStatusVisible, @"tax SHOULD be visible");
  [_calculator pressKey:EWCCalculatorTaxPlusKey];
  XCTAssertTrue(_calculator.isTaxPlusStatusVisible, @"tax plus SHOULD be visible");
  XCTAssertFalse(_calculator.isTaxStatusVisible, @"tax should NOT be visible");
  [_calculator pressKey:EWCCalculatorClearKey];
  XCTAssertFalse(_calculator.isTaxPlusStatusVisible, @"tax plus should NOT be visible");
  XCTAssertFalse(_calculator.isTaxStatusVisible, @"tax should NOT be visible");
}

- (void)testTaxMinusDisplayBehavior {
  XCTAssertFalse(_calculator.isTaxMinusStatusVisible, @"tax minus should NOT be visible");
  XCTAssertFalse(_calculator.isTaxStatusVisible, @"tax should NOT be visible");
  [_calculator pressKey:EWCCalculatorTaxMinusKey];
  XCTAssertTrue(_calculator.isTaxMinusStatusVisible, @"tax minus SHOULD be visible");
  XCTAssertFalse(_calculator.isTaxStatusVisible, @"tax should NOT be visible");
  [_calculator pressKey:EWCCalculatorTaxMinusKey];
  XCTAssertFalse(_calculator.isTaxMinusStatusVisible, @"tax minus should NOT be visible");
  XCTAssertTrue(_calculator.isTaxStatusVisible, @"tax SHOULD be visible");
  [_calculator pressKey:EWCCalculatorTaxMinusKey];
  XCTAssertTrue(_calculator.isTaxMinusStatusVisible, @"tax minus SHOULD be visible");
  XCTAssertFalse(_calculator.isTaxStatusVisible, @"tax should NOT be visible");
  [_calculator pressKey:EWCCalculatorClearKey];
  XCTAssertFalse(_calculator.isTaxMinusStatusVisible, @"tax minus should NOT be visible");
  XCTAssertFalse(_calculator.isTaxStatusVisible, @"tax should NOT be visible");
}

- (void)testOperandEdit {
  [self applyKeys:@[
    @(EWCCalculatorOneKey),
    @(EWCCalculatorZeroKey),
    @(EWCCalculatorSubtractKey),
    @(EWCCalculatorOneKey),
    @(EWCCalculatorClearKey),
  ]];
  XCTAssertEqualObjects(_calculator.displayContent, @"0.");
  [self applyKeys:@[
    @(EWCCalculatorTwoKey),
    @(EWCCalculatorEqualKey),
  ]];
  XCTAssertEqualObjects(_calculator.displayContent, @"8.");
}

- (void)testOperationTerminate {
  [self applyKeys:@[
    @(EWCCalculatorOneKey),
    @(EWCCalculatorZeroKey),
    @(EWCCalculatorSubtractKey),
    @(EWCCalculatorOneKey),
    @(EWCCalculatorClearKey),
    @(EWCCalculatorClearKey),
    @(EWCCalculatorTwoKey),
    @(EWCCalculatorEqualKey),
  ]];
  XCTAssertEqualObjects(_calculator.displayContent, @"2.");
}

-(void)testUnaryAfterEqual {
  [self applyKeys:@[
    @(EWCCalculatorThreeKey),
    @(EWCCalculatorEqualKey),
    @(EWCCalculatorAddKey),
    @(EWCCalculatorEqualKey),
  ]];
  XCTAssertEqualObjects(_calculator.displayContent, @"3.");
  [_calculator pressKey:EWCCalculatorEqualKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"6.");
  [_calculator pressKey:EWCCalculatorEqualKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"9.");
}

-(void)testBinaryAfterEqual {
  [self applyKeys:@[
    @(EWCCalculatorThreeKey),
    @(EWCCalculatorEqualKey),
    @(EWCCalculatorAddKey),
    @(EWCCalculatorThreeKey),
    @(EWCCalculatorEqualKey),
  ]];
  XCTAssertEqualObjects(_calculator.displayContent, @"6.");
  [_calculator pressKey:EWCCalculatorEqualKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"9.");
  [_calculator pressKey:EWCCalculatorEqualKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"12.");
}

- (void)testInvalidPercentCases {
  // has no effect for unary data
  [self applyKeys:@[
    @(EWCCalculatorThreeKey),
    @(EWCCalculatorPercentKey),
  ]];
  XCTAssertEqualObjects(_calculator.displayContent, @"3.", @"3%% should have no observable effect");
  [self applyKeys:@[
    @(EWCCalculatorAddKey),
    @(EWCCalculatorPercentKey),
  ]];
  XCTAssertEqualObjects(_calculator.displayContent, @"3.", @"3+%% should also have no observable effect");
  [_calculator pressKey:EWCCalculatorPercentKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"3.", @"no matter how many times we press %%");
  [_calculator pressKey:EWCCalculatorEqualKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"3.", @"first regular = should still show 3.");
  [_calculator pressKey:EWCCalculatorEqualKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"6.", @"second = picks up with unary add");

  // even if there is a previous operation (allowed for equal)
  [self applyKeys:@[
    @(EWCCalculatorTwoKey),
    @(EWCCalculatorPercentKey),
  ]];
  XCTAssertEqualObjects(_calculator.displayContent, @"2.", @"%% after continuation has no effect");
  [_calculator pressKey:EWCCalculatorEqualKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"5.", @"but = picks up with binary add");
}

- (void)testTrailingZeros {
  [self applyKeys:@[
    @(EWCCalculatorThreeKey),
    @(EWCCalculatorDecimalKey),
  ]];
  [_calculator pressKey:EWCCalculatorZeroKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"3.0");
  [_calculator pressKey:EWCCalculatorZeroKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"3.00");
  [_calculator pressKey:EWCCalculatorZeroKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"3.000");
  [_calculator pressKey:EWCCalculatorOneKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"3.0001");
}

- (void)testPositiveWholeNumberBackspace {
  [self applyKeys:@[
    @(EWCCalculatorOneKey),
    @(EWCCalculatorZeroKey),
    @(EWCCalculatorTwoKey),
    @(EWCCalculatorThreeKey),
    @(EWCCalculatorFourKey),
    @(EWCCalculatorFiveKey),
    @(EWCCalculatorSixKey),
    @(EWCCalculatorSevenKey),
    @(EWCCalculatorEightKey),
    @(EWCCalculatorNineKey),
  ]];
  XCTAssertEqualObjects(_calculator.displayContent, @"1,023,456,789.");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"102,345,678.");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"10,234,567.");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"1,023,456.");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"102,345.");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"10,234.");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"1,023.");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"102.");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"10.");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"1.");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"0.");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"0.");
  [_calculator pressKey:EWCCalculatorOneKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"1.");
}

- (void)testNegativeWholeNumberBackspace {
  [self applyKeys:@[
    @(EWCCalculatorOneKey),
    @(EWCCalculatorZeroKey),
    @(EWCCalculatorTwoKey),
    @(EWCCalculatorThreeKey),
    @(EWCCalculatorFourKey),
    @(EWCCalculatorFiveKey),
    @(EWCCalculatorSixKey),
    @(EWCCalculatorSevenKey),
    @(EWCCalculatorEightKey),
    @(EWCCalculatorNineKey),
    @(EWCCalculatorSignKey),
  ]];
  XCTAssertEqualObjects(_calculator.displayContent, @"-1,023,456,789.");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"-102,345,678.");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"-10,234,567.");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"-1,023,456.");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"-102,345.");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"-10,234.");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"-1,023.");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"-102.");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"-10.");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"-1.");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"0.");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"0.");
  [_calculator pressKey:EWCCalculatorOneKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"1.");
}

- (void)testPositiveFractionNumberBackspace {
  [self applyKeys:@[
    @(EWCCalculatorDecimalKey),
    @(EWCCalculatorOneKey),
    @(EWCCalculatorZeroKey),
    @(EWCCalculatorTwoKey),
    @(EWCCalculatorThreeKey),
    @(EWCCalculatorFourKey),
    @(EWCCalculatorFiveKey),
    @(EWCCalculatorSixKey),
    @(EWCCalculatorSevenKey),
    @(EWCCalculatorEightKey),
    @(EWCCalculatorNineKey),
  ]];
  XCTAssertEqualObjects(_calculator.displayContent, @"0.1023456789");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"0.102345678");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"0.10234567");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"0.1023456");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"0.102345");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"0.10234");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"0.1023");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"0.102");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"0.10");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"0.1");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"0.");
  [_calculator pressKey:EWCCalculatorOneKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"1.");
}

- (void)testNegativeFractionNumberBackspace {
  [self applyKeys:@[
    @(EWCCalculatorDecimalKey),
    @(EWCCalculatorOneKey),
    @(EWCCalculatorZeroKey),
    @(EWCCalculatorTwoKey),
    @(EWCCalculatorThreeKey),
    @(EWCCalculatorFourKey),
    @(EWCCalculatorFiveKey),
    @(EWCCalculatorSixKey),
    @(EWCCalculatorSevenKey),
    @(EWCCalculatorEightKey),
    @(EWCCalculatorNineKey),
    @(EWCCalculatorSignKey),
  ]];
  XCTAssertEqualObjects(_calculator.displayContent, @"-0.1023456789");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"-0.102345678");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"-0.10234567");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"-0.1023456");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"-0.102345");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"-0.10234");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"-0.1023");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"-0.102");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"-0.10");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"-0.1");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"0.");
  [_calculator pressKey:EWCCalculatorOneKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"1.");
}

- (void)testPositiveMixedNumberBackspace {
  [self applyKeys:@[
    @(EWCCalculatorOneKey),
    @(EWCCalculatorZeroKey),
    @(EWCCalculatorTwoKey),
    @(EWCCalculatorThreeKey),
    @(EWCCalculatorFourKey),
    @(EWCCalculatorDecimalKey),
    @(EWCCalculatorFiveKey),
    @(EWCCalculatorSixKey),
    @(EWCCalculatorSevenKey),
    @(EWCCalculatorEightKey),
    @(EWCCalculatorNineKey),
  ]];
  XCTAssertEqualObjects(_calculator.displayContent, @"10,234.56789");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"10,234.5678");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"10,234.567");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"10,234.56");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"10,234.5");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"10,234.");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"1,023.");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"102.");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"10.");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"1.");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"0.");
  [_calculator pressKey:EWCCalculatorOneKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"1.");
}

- (void)testNegativeMixedNumberBackspace {
  [self applyKeys:@[
    @(EWCCalculatorOneKey),
    @(EWCCalculatorZeroKey),
    @(EWCCalculatorTwoKey),
    @(EWCCalculatorThreeKey),
    @(EWCCalculatorFourKey),
    @(EWCCalculatorDecimalKey),
    @(EWCCalculatorFiveKey),
    @(EWCCalculatorSixKey),
    @(EWCCalculatorSevenKey),
    @(EWCCalculatorEightKey),
    @(EWCCalculatorNineKey),
    @(EWCCalculatorSignKey),
  ]];
  XCTAssertEqualObjects(_calculator.displayContent, @"-10,234.56789");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"-10,234.5678");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"-10,234.567");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"-10,234.56");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"-10,234.5");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"-10,234.");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"-1,023.");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"-102.");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"-10.");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"-1.");
  [_calculator pressKey:EWCCalculatorBackspaceKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"0.");
  [_calculator pressKey:EWCCalculatorOneKey];
  XCTAssertEqualObjects(_calculator.displayContent, @"1.");
}

@end
