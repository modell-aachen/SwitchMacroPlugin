# See bottom of file for default license and copyright information

=begin TML

---+ package Foswiki::Plugins::SwitchMacroPlugin

=cut


package Foswiki::Plugins::SwitchMacroPlugin;

use strict;
use warnings;

use Foswiki::Func    ();    # The plugins API
use Foswiki::Plugins ();    # For the API version

our $VERSION          = '$Rev: 7808 (2010-06-15) $';

our $RELEASE = "1.0";

# Short description of this plugin
our $SHORTDESCRIPTION = 'A macro for switch/case-like behaviour.';

our $NO_PREFS_IN_TOPIC = 1;

sub initPlugin {
    my ( $topic, $web, $user, $installWeb ) = @_;

    # check for Plugins.pm versions
    if ( $Foswiki::Plugins::VERSION < 2.0 ) {
        Foswiki::Func::writeWarning( 'Version mismatch between ',
            __PACKAGE__, ' and Plugins.pm' );
        return 0;
    }

    Foswiki::Func::registerTagHandler( 'SWITCHTEXT', \&_switchTextHandler );
    Foswiki::Func::registerTagHandler( 'SWITCHTMPL', \&_switchTemplateHandler );

    return 1;
}

sub _switchTextHandler {
    my($session, $params, $topic, $web, $topicObject) = @_;

    my $switch = $params->{_DEFAULT};
    $switch = Foswiki::Func::getPreferencesValue('CONTENT_LANGUAGE') unless defined $switch;

    # return case if it exists
    if ( defined $switch && $switch ne '' && defined $params->{$switch}) {
        return Foswiki::Func::decodeFormatTokens($params->{$switch});
    }

    # return default
    my $default = $params->{defaultTo} || 'default';
    if ( $default eq 'MAKETEXT' ) {
        return '' unless $params->{en}; # XXX some kind of warning would be nice?
        return '%MAKETEXT{"'.Foswiki::Func::decodeFormatTokens($params->{en}).'"}%';
    }
    return '' unless $params->{$default};
    return Foswiki::Func::decodeFormatTokens($params->{$default});
}

sub _switchTemplateHandler {
    my($session, $params, $topic, $web, $topicObject) = @_;

    my $switch = $params->{_DEFAULT};
    $switch = Foswiki::Func::getPreferencesValue('CONTENT_LANGUAGE') unless defined $switch;
    my $prefix = $params->{prefix} || '';

    # return case if it is not empty
    if ( defined $switch && $switch ne '' ) {
        my $tmpl = Foswiki::Func::expandTemplate( $prefix.$switch );
        return $tmpl if defined $tmpl && $tmpl ne '';
    }

    # return default
    my $default = $params->{defaultTo} || 'default';
    if ( $default eq 'MAKETEXT' ) {
        my $tmpl = Foswiki::Func::expandTemplate( $prefix.'en');
        return "%MAKETEXT{\"$tmpl\"}%" if defined $tmpl && $tmpl ne '';
    }
    my $tmpl = Foswiki::Func::expandTemplate( $prefix.$default );
    return $tmpl || '';
}

1;

__END__
Foswiki - The Free and Open Source Wiki, http://foswiki.org/

Author: ModellAachen

Copyright (C) 2008-2012 Foswiki Contributors. Foswiki Contributors
are listed in the AUTHORS file in the root of this distribution.
NOTE: Please extend that file, not this notice.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version. For
more details read LICENSE in the root of this distribution.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

As per the GPL, removal of this notice is prohibited.