test('ADT', normal, compile, ['-ddump-types'])
test('AddAndOr1', normal, compile, ['-ddump-types'])
test('AddAndOr2', normal, compile, ['-ddump-types'])
test('AddAndOr3', normal, compile, ['-ddump-types'])
test('AddAndOr4', normal, compile, ['-ddump-types'])
test('AddAndOr5', normal, compile, ['-ddump-types'])
test('AddAndOr6', normal, compile, ['-ddump-types'])
test('BoolToBool', normal, compile, ['-ddump-types'])
test('Defaulting1MROn', normal, compile, ['-ddump-types'])
test('Defaulting2MROff', normal, compile, ['-ddump-types'])
test('Defaulting2MROn', normal, compile, ['-ddump-types'])
test('Either', normal, compile, ['-ddump-types'])
test('Every', normal, compile, ['-ddump-types'])
test('EveryNamed', normal, compile, ['-ddump-types'])
# TODOT Broken
test('EqualityConstraint', skip, compile, ['-ddump-types'])
test('ExpressionSig', normal, compile, ['-ddump-types'])
test('ExpressionSigNamed', normal, compile, ['-ddump-types'])
test('ExtraConstraints1', normal, compile, ['-ddump-types'])
test('ExtraConstraints2', normal, compile, ['-ddump-types'])
test('ExtraConstraints3', normal, compile, ['-ddump-types'])
test('ExtraNumAMROn', normal, compile, ['-ddump-types'])
test('ExtraNumAMROff', normal, compile, ['-ddump-types'])
# Type equalities can't yet be inferred as extra constraints
test('ExtraTypeEquality', skip, compile, ['-ddump-types'])
test('Forall1', normal, compile, ['-ddump-types'])
test('GenNamed', normal, compile, ['-ddump-types'])
test('HigherRank1', normal, compile, ['-ddump-types'])
test('HigherRank2', normal, compile, ['-ddump-types'])
test('Meltdown', normal, compile, ['-ddump-types'])
test('NamedTyVar', normal, compile, ['-ddump-types'])
test('ParensAroundContext', normal, compile, ['-ddump-types'])
test('PatBind', normal, compile, ['-ddump-types'])
# TODOT BUG
test('PatBind2', normal, compile, ['-ddump-types'])
test('PatternSig', normal, compile, ['-ddump-types'])
test('Recursive', normal, compile, ['-ddump-types'])
test('ShowNamed', normal, compile, ['-ddump-types'])
test('SimpleGen', normal, compile, ['-ddump-types'])
test('SkipMany', normal, compile, ['-ddump-types'])
test('SomethingShowable', normal, compile, ['-ddump-types'])
test('Uncurry', normal, compile, ['-ddump-types'])
test('UncurryNamed', normal, compile, ['-ddump-types'])
test('ScopedNamedWildcards', normal, compile, ['-ddump-types'])

