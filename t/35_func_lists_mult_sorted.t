# perl
#$Id$
# 35_func_lists_mult_sorted.t
use strict;
use Test::More qw(no_plan); # tests =>  46;
use List::Compare::Functional qw(:originals :aliases);
use lib ("./t");
use Test::ListCompareSpecial qw( :seen :func_wrap :arrays :results );
use IO::CaptureOutput qw( capture );

my @pred = ();
my %seen = ();
my %pred = ();
my @unpred = ();
my (@unique, @complement, @intersection, @union, @symmetric_difference, @bag);
my ($unique_ref, $complement_ref, $intersection_ref, $union_ref,
$symmetric_difference_ref, $bag_ref);
my ($LR, $RL, $eqv, $disj, $return, $vers);
my (@nonintersection, @shared);
my ($nonintersection_ref, $shared_ref);
my ($memb_hash_ref, $memb_arr_ref, @memb_arr);
my ($unique_all_ref, $complement_all_ref);
my @args;

### new ###
#my $lcm   = List::Compare->new(\@a0, \@a1, \@a2, \@a3, \@a4);
#ok($lcm, "List::Compare constructor returned true value");

@pred = qw(abel baker camera delta edward fargo golfer hilton icon jerky);
@union = get_union( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
is_deeply( \@union, \@pred, "Got expected union");

$union_ref = get_union_ref( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
is_deeply( $union_ref, \@pred, "Got expected union");

@pred = qw(baker camera delta edward fargo golfer hilton icon);
@shared = get_shared( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
is_deeply( \@shared, \@pred, "Got expected shared");

$shared_ref = get_shared_ref( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
is_deeply( $shared_ref, \@pred, "Got expected shared");

@pred = qw(fargo golfer);
@intersection = get_intersection( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
is_deeply(\@intersection, \@pred, "Got expected intersection");

$intersection_ref = get_intersection_ref( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
is_deeply($intersection_ref, \@pred, "Got expected intersection");

@pred = qw( jerky );
@unique = get_unique( [ \@a0, \@a1, \@a2, \@a3, \@a4 ], [ 2 ] );
is_deeply(\@unique, \@pred, "Got expected unique");

$unique_ref = get_unique_ref( [ \@a0, \@a1, \@a2, \@a3, \@a4 ], [ 2 ] );
is_deeply($unique_ref, \@pred, "Got expected unique");

#eval { $unique_ref = get_unique_ref('jerky') };
#like($@,
#    qr/Argument to method List::Compare::Multiple::get_unique_ref must be the array index/,
#    "Got expected error message"
#);

@pred = qw( abel );
@unique = get_unique( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
is_deeply(\@unique, \@pred, "Got expected unique");

$unique_ref = get_unique_ref( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
is_deeply($unique_ref, \@pred, "Got expected unique");

@pred = (
    [ 'abel' ],
    [  ],
    [ 'jerky' ],
    [ ],
    [  ],
);
$unique_all_ref = get_unique_all( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
is_deeply($unique_all_ref, [ @pred ],
    "Got expected values for get_unique_all()");

@pred = qw( abel icon jerky );
@complement = get_complement([ \@a0, \@a1, \@a2, \@a3, \@a4 ], [ 1 ] );
is_deeply(\@complement, \@pred, "Got expected complement");

$complement_ref = get_complement_ref([ \@a0, \@a1, \@a2, \@a3, \@a4 ], [ 1 ] );
is_deeply($complement_ref, \@pred, "Got expected complement");

#eval { $complement_ref = get_complement_ref('jerky') };
#like($@,
#    qr/Argument to method List::Compare::Multiple::get_complement_ref must be the array index/,
#    "Got expected error message"
#);

@pred = qw ( hilton icon jerky );
@complement = get_complement( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
is_deeply(\@complement, \@pred, "Got expected complement");

$complement_ref = get_complement_ref( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
is_deeply($complement_ref, \@pred, "Got expected complement");

@pred = (
    [ qw( hilton icon jerky ) ],
    [ qw( abel icon jerky ) ],
    [ qw( abel baker camera delta edward ) ],
    [ qw( abel baker camera delta edward jerky ) ],
    [ qw( abel baker camera delta edward jerky ) ],
);
$complement_all_ref = get_complement_all( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
is_deeply($complement_all_ref, [ @pred ],
    "Got expected values for get_complement_all()");

@pred = qw( abel jerky );
@symmetric_difference =
    get_symmetric_difference( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
is_deeply(\@symmetric_difference, \@pred, "Got expected symmetric_difference");

$symmetric_difference_ref =
    get_symmetric_difference_ref( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
is_deeply($symmetric_difference_ref, \@pred, "Got expected symmetric_difference");

@symmetric_difference = get_symdiff( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
is_deeply(\@symmetric_difference, \@pred, "Got expected symmetric_difference");

$symmetric_difference_ref = get_symdiff_ref( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
is_deeply($symmetric_difference_ref, \@pred, "Got expected symmetric_difference");

@pred = qw( abel baker camera delta edward hilton icon jerky );
@nonintersection = get_nonintersection( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
is_deeply( \@nonintersection, \@pred, "Got expected nonintersection");

$nonintersection_ref = get_nonintersection_ref( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
is_deeply($nonintersection_ref, \@pred, "Got expected nonintersection");

@pred = qw( abel abel baker baker camera camera delta delta delta edward
edward fargo fargo fargo fargo fargo fargo golfer golfer golfer golfer golfer
hilton hilton hilton hilton icon icon icon icon icon jerky );
@bag = get_bag( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
is_deeply(\@bag, \@pred, "Got expected bag");

$bag_ref = get_bag_ref( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
is_deeply($bag_ref, \@pred, "Got expected bag");

$LR = is_LsubsetR( [ \@a0, \@a1, \@a2, \@a3, \@a4 ], [ 3,2 ] );
ok($LR, "Got expected subset relationship");

$LR = is_LsubsetR( [ \@a0, \@a1, \@a2, \@a3, \@a4 ], [ 2,3 ] );
ok(! $LR, "Got expected subset relationship");

$LR = is_LsubsetR( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
ok(! $LR, "Got expected subset relationship");

#eval { $LR = is_LsubsetR(2) };
#like($@,
#    qr/Method List::Compare::Multiple::is_LsubsetR requires 2 arguments/,
#    "Got expected error message"
#);
#
#eval { $LR = is_LsubsetR(8,9) };
#like($@,
#    qr/Each argument to method List::Compare::Multiple::is_LsubsetR must be a valid array index /,
#    "Got expected error message"
#);
#
$eqv = is_LequivalentR( [ \@a0, \@a1, \@a2, \@a3, \@a4 ], [ 3,4 ] );
ok($eqv, "Got expected equivalence relationship");

$eqv = is_LeqvlntR( [ \@a0, \@a1, \@a2, \@a3, \@a4 ], [ 3,4 ] );
ok($eqv, "Got expected equivalence relationship");

$eqv = is_LequivalentR( [ \@a0, \@a1, \@a2, \@a3, \@a4 ], [ 2,4 ] );
ok(! $eqv, "Got expected equivalence relationship");

#eval { $eqv = is_LequivalentR(2) };
#like($@,
#    qr/Method List::Compare::Multiple::is_LequivalentR requires 2 arguments/,
#    "Got expected error message",
#);
#
#eval { $eqv = is_LequivalentR(8,9) };
#like($@,
#    qr/Each argument to method List::Compare::Multiple::is_LequivalentR must be a valid array index/,
#    "Got expected error message",
#);

{
    my ($rv, $stdout, $stderr);
    capture(
        sub { $rv = print_subset_chart( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] ); },
        \$stdout,
    );
    ok($rv, "print_subset_chart() returned true value");
    like($stdout, qr/Subset Relationships/,
        "Got expected chart header");
}
{
    my ($rv, $stdout, $stderr);
    capture(
        sub { $rv = print_equivalence_chart( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] ); },
        \$stdout,
    );
    ok($rv, "print_equivalence_chart() returned true value");
    like($stdout, qr/Equivalence Relationships/,
        "Got expected chart header");
}

#ok(func_wrap_is_member_which(
#    [ \@a0, \@a1, \@a2, \@a3, \@a4 ],
#    $test_members_which_mult,
#), "is_member_which() returned all expected values");

@args = qw( abel baker camera delta edward fargo golfer hilton icon jerky zebra );

is_deeply(func_all_is_member_which( [ \@a0, \@a1, \@a2, \@a3, \@a4 ], \@args ),
    $test_member_which_mult,
    "is_member_which() returned all expected values");

#eval { $memb_arr_ref = is_member_which('jerky', 'zebra') };
#like($@, qr/Method call requires exactly 1 argument \(no references\)/,
#        "is_member_which() correctly generated error message");

is_deeply(func_all_is_member_which_ref( [ \@a0, \@a1, \@a2, \@a3, \@a4 ], \@args ),
    $test_member_which_mult,
    "is_member_which_ref() returned all expected values");

#eval { $memb_arr_ref = is_member_which_ref('jerky', 'zebra') };
#like($@, qr/Method call requires exactly 1 argument \(no references\)/,
#        "is_member_which_ref() correctly generated error message");

__END__

$memb_hash_ref = are_members_which( \@args );
is_deeply($memb_hash_ref, $test_members_which_mult,
   "are_members_which() returned all expected values");

eval { $memb_hash_ref = are_members_which( { key => 'value' } ) };
like($@,
    qr/Method call requires exactly 1 argument which must be an array reference/,
    "are_members_which() correctly generated error message");

is_deeply( all_is_member_any( $lcm, \@args), $test_member_any,
    "is_member_which() returned all expected values");

eval { is_member_any('jerky', 'zebra') };
like($@,
    qr/Method call requires exactly 1 argument \(no references\)/,
    "is_member_any() correctly generated error message");

$memb_hash_ref = are_members_any( \@args );
ok(wrap_are_members_any(
    $memb_hash_ref,
    $test_members_any_mult,
), "are_members_any() returned all expected values");

eval { $memb_hash_ref = are_members_any( { key => 'value' } ) };
like($@,
    qr/Method call requires exactly 1 argument which must be an array reference/,
    "are_members_any() correctly generated error message");

$vers = get_version;
ok($vers, "get_version() returned true value");

### new ###
my $lcm_dj   = List::Compare->new(\@a0, \@a1, \@a2, \@a3, \@a4, \@a8);
ok($lcm_dj, "Constructor returned true value");

$disj = $lcm_dj->is_LdisjointR;
ok(! $disj, "Got expected disjoint relationship");

$disj = $lcm_dj->is_LdisjointR(2,3);
ok(! $disj, "Got expected disjoint relationship");

$disj = $lcm_dj->is_LdisjointR(4,5);
ok($disj, "Got expected disjoint relationship");

eval { $disj = $lcm_dj->is_LdisjointR(2) };
like($@, qr/Method List::Compare::Multiple::is_LdisjointR requires 2 arguments/,
    "Got expected error message");

########## BELOW:  Testfor bad arguments to constructor ##########

my ($lcm_bad);
my %h5 = (
    golfer   => 1,
    lambda   => 0,
);

eval { $lcm_bad = List::Compare->new('-u', \@a0, \@a1, \@a2, \@a3, \%h5) };
like($@, qr/Must pass all array references or all hash references/,
    "Got expected error message from bad constructor");

eval { $lcm_bad = List::Compare->new('-u', \%h5, \@a0, \@a1, \@a2, \@a3) };
like($@, qr/Must pass all array references or all hash references/,
    "Got expected error message from bad constructor");

my $scalar = 'test';
eval { $lcm_bad = List::Compare->new(\$scalar, \@a0, \@a1) };
like($@, qr/Must pass all array references or all hash references/,
    "Got expected error message from bad constructor");
