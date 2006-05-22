# $Id: 10pod.t 459 2006-05-19 19:26:42Z nicolaw $

use strict;
use Test::More;
eval "use Test::Deep";
if ($@) { plan skip_all => "Test::Deep required for testing parse_lin()"; }
else { plan tests => 23; }

use lib qw(./lib ../lib);
use Parse::Colloquy::Bot qw(:all);

for my $data (_data()) {
	cmp_deeply(parse_line($data->{raw}), $data, $data->{raw},);
}

sub _data {
	my @data = (
		{         args =>
			  ['HELLO', 'colloquy', '1.41.94.arwen-1', '(09', 'May', '2006)'],
			cmdargs => undef,
			command => undef,
			list    => undef,
			msgtype => 'HELLO',
			person  => undef,
			raw     => 'HELLO colloquy 1.41.94.arwen-1 (09 May 2006)',
			respond => undef,
			text    => 'colloquy 1.41.94.arwen-1 (09 May 2006)',
			time    => ignore(),
		},

		{         args => [
				'RAW',  '+++',   'Name', 'is',     'already', 'in',
				'use.', 'Use',   '*',    'before', 'your',    'name',
				'to',   'force', 'on.'
			],
			cmdargs => undef,
			command => undef,
			list    => undef,
			msgtype => 'RAW',
			person  => undef,
			raw     =>
			  '+++ Name is already in use. Use * before your name to force on.',
			respond => undef,
			text    =>
			  '+++ Name is already in use. Use * before your name to force on.',
			time => ignore(),
		},

		{         args => [
				'MARK',
				'---------------------------------------------------------------------',
				'22:52'
			],
			cmdargs => undef,
			command => undef,
			list    => undef,
			msgtype => 'MARK',
			person  => undef,
			raw     =>
			  'MARK --------------------------------------------------------------------- 22:52',
			respond => undef,
			text    =>
			  '--------------------------------------------------------------------- 22:52',
			time => ignore(),
		},

		{         args => [
				'RAW',      '+++',  'For', 'an',
				'account,', 'talk', 'to',  'a',
				'master.',  'You',  'can', 'get',
				'a',        'list', 'of',  'available',
				'commands'
			],
			cmdargs => undef,
			command => undef,
			list    => undef,
			msgtype => 'RAW',
			person  => undef,
			raw     =>
			  'RAW +++ For an account, talk to a master. You can get a list of available commands',
			respond => undef,
			text    =>
			  '+++ For an account, talk to a master. You can get a list of available commands',
			time => ignore(),
		},

		{         args => [
				'RAW',     '+++',        'by',      'typing',
				'\'.help', 'commands\'', 'and',     'help',
				'on',      'a',          'certain', 'command',
				'by',      'typing',     '\'.help'
			],
			cmdargs => undef,
			command => undef,
			list    => undef,
			msgtype => 'RAW',
			person  => undef,
			raw     =>
			  'RAW +++ by typing \'.help commands\' and help on a certain command by typing \'.help',
			respond => undef,
			text    =>
			  '+++ by typing \'.help commands\' and help on a certain command by typing \'.help',
			time => ignore(),
		},

		{         args => [
				'RAW', '+++',       'command\'.', 'Just',
				'use', '\'.help\'', 'for',        'general',
				'help.'
			],
			cmdargs => undef,
			command => undef,
			list    => undef,
			msgtype => 'RAW',
			person  => undef,
			raw => 'RAW +++ command\'. Just use \'.help\' for general help.',
			respond => undef,
			text    => '+++ command\'. Just use \'.help\' for general help.',
			time    => ignore(),
		},

		{         args    => ['RAW', '+++'],
			cmdargs => undef,
			command => undef,
			list    => undef,
			msgtype => 'RAW',
			person  => undef,
			raw     => 'RAW +++',
			respond => undef,
			text    => '+++',
			time    => ignore(),
		},

		{         args => [
				'RAW',     '+++',  'You\'ll', 'probably',
				'want',    'to',   'type',    '".set',
				'prompts', 'on",', '".set',   'term',
				'colour"', 'and'
			],
			cmdargs => undef,
			command => undef,
			list    => undef,
			msgtype => 'RAW',
			person  => undef,
			raw     =>
			  'RAW +++ You\'ll probably want to type ".set prompts on", ".set term colour" and',
			respond => undef,
			text    =>
			  '+++ You\'ll probably want to type ".set prompts on", ".set term colour" and',
			time => ignore(),
		},

		{         args => [
				'RAW',        '+++',    '".set',   'echo',
				'off"',       'if',     'you\'re', 'using',
				'a',          'decent', 'client,', 'like',
				'TinyFugue.', 'Also',   'do'
			],
			cmdargs => undef,
			command => undef,
			list    => undef,
			msgtype => 'RAW',
			person  => undef,
			raw     =>
			  'RAW +++ ".set echo off" if you\'re using a decent client, like TinyFugue. Also do',
			respond => undef,
			text    =>
			  '+++ ".set echo off" if you\'re using a decent client, like TinyFugue. Also do',
			time => ignore(),
		},

		{         args => [
				'RAW', '+++',   '".set', 'strip', 'on"', 'if',
				'you', 'emote', 'lots',  'too.'
			],
			cmdargs => undef,
			command => undef,
			list    => undef,
			msgtype => 'RAW',
			person  => undef,
			raw     => 'RAW +++ ".set strip on" if you emote lots too.',
			respond => undef,
			text    => '+++ ".set strip on" if you emote lots too.',
			time    => ignore(),
		},

		{         args    => ['RAW', '+++'],
			cmdargs => undef,
			command => undef,
			list    => undef,
			msgtype => 'RAW',
			person  => undef,
			raw     => 'RAW +++',
			respond => undef,
			text    => '+++',
			time    => ignore(),
		},

		{         args    => ['RAW', '+++', 'End', 'of', 'MOTD'],
			cmdargs => undef,
			command => undef,
			list    => undef,
			msgtype => 'RAW',
			person  => undef,
			raw     => 'RAW +++ End of MOTD',
			respond => undef,
			text    => '+++ End of MOTD',
			time    => ignore(),
		},

		{         args => [
				'DONE',   'Options:', 'Beep',     'On,',
				'CR',     'On,',      'Echo',     'Off,',
				'Strip',  'Off,',     'Prompts',  'Off,',
				'Shouts', 'On,',      'Messages', 'On,',
				'Lists',  'On,',      'Idling',   'messages',
				'On,',    'Terminal', 'Client,',  'Width',
				'79',     'chars,',   'Language', 'en-gb.'
			],
			cmdargs => undef,
			command => undef,
			list    => undef,
			msgtype => 'DONE',
			person  => undef,
			raw     =>
			  'DONE Options: Beep On, CR On, Echo Off, Strip Off, Prompts Off, Shouts On, Messages On, Lists On, Idling messages On, Terminal Client, Width 79 chars, Language en-gb.',
			respond => undef,
			text    =>
			  'Options: Beep On, CR On, Echo Off, Strip Off, Prompts Off, Shouts On, Messages On, Lists On, Idling messages On, Terminal Client, Width 79 chars, Language en-gb.',
			time => ignore(),
		},

		{         args => ['LOOKHDR', 'Active', 'users', 'in', 'group', 'Bots-R-Us:'],
			cmdargs => undef,
			command => undef,
			list    => undef,
			msgtype => 'LOOKHDR',
			person  => undef,
			raw     => 'LOOKHDR Active users in group Bots-R-Us:',
			respond => undef,
			text    => 'Active users in group Bots-R-Us:',
			time    => ignore(),
		},

		{         args    => ['LOOK', 'botbot(P)'],
			cmdargs => undef,
			command => undef,
			list    => undef,
			msgtype => 'LOOK',
			person  => undef,
			raw     => 'LOOK   botbot(P)',
			respond => undef,
			text    => 'botbot(P)',
			time    => ignore(),
		},

		{         args    => ['COMMENT', 'No', 'comments', 'set.'],
			cmdargs => undef,
			command => undef,
			list    => undef,
			msgtype => 'COMMENT',
			person  => undef,
			raw     => 'COMMENT No comments set.',
			respond => undef,
			text    => 'No comments set.',
			time    => ignore(),
		},

		{         args => [
				'dear', 'god', 'woman', 'what',
				'do',   'you', 'think', 'you\'re',
				'doing?!'
			],
			cmdargs => undef,
			command => undef,
			list    => undef,
			msgtype => 'SHOUT',
			person  => 'neech2',
			raw     =>
			  'SHOUT neech2      !dear god woman what do you think you\'re doing?!',
			respond => undef,
			text    => 'dear god woman what do you think you\'re doing?!',
			time    => ignore(),
		},

		{         args    => ['hello', 'botbot'],
			cmdargs => ['botbot'],
			command => 'hello',
			list    => undef,
			msgtype => 'TELL',
			person  => 'neech2',
			raw     => 'TELL neech2      >hello botbot',
			respond => undef,
			text    => 'hello botbot',
			time    => ignore(),
		},

		{         args    => ['DONETELL', 'Whispered', 'to', 'neech2:', '\'hi\''],
			cmdargs => undef,
			command => undef,
			list    => undef,
			msgtype => 'DONETELL',
			person  => undef,
			raw     => 'DONETELL Whispered to neech2: \'hi\'',
			respond => undef,
			text    => 'Whispered to neech2: \'hi\'',
			time    => ignore(),
		},

		{         args => ['who', 'else', 'here', 'thinks', 'POE', 'rocks', 'ass?'],
			cmdargs => ['else', 'here', 'thinks', 'POE', 'rocks', 'ass?'],
			command => 'who',
			list    => '%perl',
			msgtype => 'LISTTALK',
			person  => 'neech2',
			raw     =>
			  'LISTTALK neech2      %who else here thinks POE rocks ass? {perl}',
			respond => undef,
			text    => 'who else here thinks POE rocks ass?',
			time    => ignore(),
		},

		{         args    => ['smiles', 'cutely'],
			cmdargs => undef,
			command => undef,
			list    => '%perl',
			msgtype => 'LISTEMOTE',
			person  => 'neech2',
			raw     => 'LISTEMOTE % neech2 smiles cutely {perl}',
			respond => undef,
			text    => 'smiles cutely',
			time    => ignore(),
		},

		{         args => [
				'neech2', 'invites', 'you',      'to',
				'%foo.',  'To',      'respond,', 'type',
				'.list',  'join',    'foo'
			],
			cmdargs => undef,
			command => undef,
			list    => '%foo.',
			msgtype => 'LISTINVITE',
			person  => 'neech2',
			raw     =>
			  'LISTINVITE neech2 invites you to %foo.  To respond, type .list join foo',
			respond => '.list join foo',
			text    =>
			  'neech2 invites you to %foo.  To respond, type .list join foo',
			time => ignore(),
		},

		{         args => [
				'WARN', 'neech2', 'warns', 'botbot', '(i\'m', 'warning', 'you!)'
			],
			cmdargs => undef,
			command => undef,
			list    => undef,
			msgtype => 'WARN',
			person  => undef,
			raw     => 'WARN neech2 warns botbot (i\'m warning you!)',
			respond => undef,
			text    => 'neech2 warns botbot (i\'m warning you!)',
			time    => ignore(),
		},
	);

	return @data;
}

1;

