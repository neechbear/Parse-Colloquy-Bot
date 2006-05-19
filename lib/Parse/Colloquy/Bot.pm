############################################################
#
#   $Id$
#   Parse::Colloquy::Bot - Parse Colloquy Bot/Client Terminal Output
#
#   Copyright 2006 Nicola Worthington
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
############################################################

package Parse::Colloquy::Bot;
# vim:ts=4:sw=4:tw=78

use strict;
use Exporter;
use RRDs;
use Carp qw(croak cluck confess carp);

use vars qw($VERSION $DEBUG @EXPORT @EXPORT_OK %EXPORT_TAGS @ISA);

$VERSION = '0.01' || sprintf('%d.%02d', q$Revision: 457 $ =~ /(\d+)/g);

@ISA = qw(Exporter);
@EXPORT = qw();
@EXPORT_OK = qw(parse_line);
%EXPORT_TAGS = (all => \@EXPORT_OK);

$DEBUG = $ENV{DEBUG} ? 1 : 0;

sub parse_input {
	local $_ = $_[0];
	s/[\n\r]//g;
	s/^\s+|\s+$//g;

	$_ = "RAW $_" if m/^\+\+\+/;
	return unless m/^([A-Z]+\S*)(?:\s+(.+))?$/;
	my %args = (
			raw     => $_,
			msgtype => $1 || '',
			text    => $2 || '',
			args    => [ split(/\s+/,$_||'') ],
			command => undef,
			cmdargs => undef,
			#command => (split(/\s+/,$2||''))[0],
			#cmdargs => [ (split(/\s+/,$2||''))[1,] ],
			list    => undef,
			person  => undef,
			respond => undef,
		);
	local $_ = $args{text};

	if ($args{msgtype} =~ /^TALK|TELL$/ && /^(\S+)\s+[:>](.*)\s*$/) {
		$args{person}  = $1;
		$args{text}    = $2;
		$args{cmdargs} = $args{args} = [ split(/\s+/,$args{text}) ];
		$args{command} = shift @{$args{cmdargs}};

	} elsif ($args{msgtype} eq 'LISTINVITE' && /((\S+)\s+invites\s+you\s+to\s+(\S+)\s+To\s+respond,\s+type\s+(.+))\s*$/) {
		$args{text}    = $1;
		$args{person}  = $2;
		$args{list}    = $3;
		$args{respond} = $4;
		$args{args}    = [ split(/\s+/,$args{text}) ];

	} elsif ($args{msgtype} eq 'LISTTALK' && /^(\S+)\s*%(.*)\s+{(.+?)}\s*$/) {
		$args{person}  = $1;
		$args{text}    = $2;
		$args{cmdargs} = $args{args} = [ split(/\s+/,$args{text}) ];
		$args{command} = shift @{$args{cmdargs}};
		$args{list}    = '%'.$3;

	} elsif ($args{msgtype} eq 'LISTEMOTE' && /^%\s*(\S+)\s+(.*)\s+{(.+?)}\s*$/) {
		$args{person}  = $1;
		$args{text}    = $2;
		$args{args}    = [ split(/\s+/,$args{text}) ];
		$args{list}    = '%'.$3;

	} elsif ($args{msgtype} eq 'OBSERVED' && /^(\S+)\s+(\S+)\s+(\S+)\s+\@(.+)\s+{(\@.+?)}\s*$/) {
		$args{group}   = $args{list} = '@'.$1;
		$args{msgtype} = "OBSERVED $2";
		$args{person}  = $3;
		$args{text}    = $4;
		$args{cmdargs} = $args{args} = [ split(/\s+/,$args{text}) ];
		$args{command} = shift @{$args{cmdargs}};

	} elsif ($args{msgtype} eq 'OBSERVED' && /^(\S+)\s+(\S+)\s+(?:\@\s+)(\S+)\s+(.+)\s+{(\@.+?)}\s*$/) {
		$args{group}   = $args{list} = '@'.$1;
		$args{msgtype} = "OBSERVED $2";
		$args{person}  = $3;
		$args{text}    = $4;
		$args{args}    = [ split(/\s+/,$args{text}) ];

	} elsif ($args{msgtype} eq 'OBSERVED' && /^(\S+)\s+GROUPCHANGE\s+(\S+)\s+(.*)\s*$/) {
		$args{group}   = $args{list} = '@'.$1;
		$args{msgtype} = 'OBSERVED GROUPCHANGE';
		$args{person}  = $2;
		$args{text}    = $3;
		$args{args}    = [ split(/\s+/,$args{text}) ];

	} elsif ($args{msgtype} eq 'SHOUT' && /^(\S+)\s+\!(.*)\s*$/) {
		$args{person}  = $1;
		$args{text}    = $2;
		$args{args}    = [ split(/\s+/,$args{text}) ];

	} elsif ($args{msgtype} eq 'CONNECT' && /^((\S+).+\s+(\S+)\.)\s*$/) {
		$args{text}    = $1;
		$args{person}  = $2;
		$args{group}   = $args{list} = '@'.$3;
		$args{args}    = [ split(/\s+/,$args{text}) ];

	} elsif ($args{msgtype} eq 'IDLE' && /^((\S+)(.*))\s*$/) {
		$args{text}    = $1;
		$args{person}  = $2;
		$args{args}    = [ split(/\s+/,$args{text}) ];
	}

	return \%args;
}

sub TRACE {
	return unless $DEBUG;
	warn(shift());
}

sub DUMP {
	return unless $DEBUG;
	eval {
		require Data::Dumper;
		warn(shift().': '.Data::Dumper::Dumper(shift()));
	}
}

1;

=pod

=head1 NAME

Parse::Colloquy::Bot - Parse Colloquy Bot/Client Terminal Output

=head1 SYNOPSIS

 use strict;
 use Parse::Colloquy::Bot qw(:all);
 use Data::Dumper;
 
 # ... connect to Colloquy and read from the server ...
 my $parsed = parse_input($raw_input);
 print Dumper($parsed);  
 
=head1 DESCRIPTION

blah blah blah

=head1 FUNCTIONS

=head2 parse_input

blah blah blah

=head1 SEE ALSO

L<Colloquy::Data>, L<Colloquy::Bot::Simple>, L<Chatbot::TalkerBot>

=head1 VERSION

$Id$

=head1 AUTHOR

Nicola Worthington <nicolaw@cpan.org>

L<http://perlgirl.org.uk>

=head1 COPYRIGHT

Copyright 2005,2006 Nicola Worthington.

This software is licensed under The Apache Software License, Version 2.0.

L<http://www.apache.org/licenses/LICENSE-2.0>

=cut


__END__

