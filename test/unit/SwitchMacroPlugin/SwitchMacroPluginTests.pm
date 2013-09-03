# See bottom of file for license and copyright information
use strict;
use warnings;

package SwitchMacroPluginTests;

use FoswikiFnTestCase;
our @ISA = qw( FoswikiFnTestCase );

use strict;
use warnings;
use Foswiki;
use CGI;

my $topicObject;

sub new {
    my $self = shift()->SUPER::new( 'SwitchTextPlugin', @_ );
    return $self;
}

sub set_up {
    my $this = shift;

    $this->SUPER::set_up();

    Foswiki::Func::saveTopic( $this->{test_web}, 'SwitchTestViewTemplate', undef, <<TEMPLATE );
%TMPL:INCLUDE{"view"}%
%TMPL:DEF{"SwitchTest_en"}%Page%TMPL:END%
%TMPL:DEF{"SwitchTest_de"}%Seite%TMPL:END%
%TMPL:DEF{"SwitchTest_default"}%Language not found%TMPL:END%
TEMPLATE

    Foswiki::Func::saveTopic( $this->{test_web}, 'SwitchTest', undef, <<TOPIC );
   * Set VIEW_TEMPLATE = SwitchTestView
%TMPL:P{SwitchTest_en}%
TOPIC

    ($topicObject) = Foswiki::Func::readTopic( $this->{test_web}, 'SwitchTest' );
    Foswiki::Func::loadTemplate("$this->{test_web}.SwitchTestView");
}

sub loadExtraConfig {
    my $this = shift;
    $this->SUPER::loadExtraConfig();
    $Foswiki::cfg{Plugins}{SwitchMacroPlugin}{Enabled} = 1;
}

sub tear_down {
    my $this = shift;
    $this->SUPER::tear_down();
}

sub _page {
    my $switch = shift;

    my $macro = "%SWITCHTMPL{\"$switch\" prefix=\"SwitchTest_\"}%";
    return Foswiki::Func::expandCommonVariables($macro);
}

sub _pageCL {
    my $switch = shift;

    Foswiki::Func::setPreferencesValue('CONTENT_LANGUAGE', $switch);
    my $macro = "%SWITCHTMPL{prefix=\"SwitchTest_\"}%";
    return Foswiki::Func::expandCommonVariables($macro);
}

sub _beverage {
    my $switch = shift;

    my $macro = "%SWITCHTEXT{\"$switch\" de=\"Bier\" ja=\"sake\" default=\"Beer\"}%";
    return Foswiki::Func::expandCommonVariables($macro);
    return $topicObject->expandMacros($macro); # dunno why this won't work
}

sub _beverageDT {
    my $switch = shift;

    my $macro = "%SWITCHTEXT{\"$switch\" de=\"Bier\" ja=\"sake\" default=\"Beer\" defaultTo=\"de\"}%";
    return Foswiki::Func::expandCommonVariables($macro);
}

sub _beverageCL {
    my $switch = shift;

    Foswiki::Func::setPreferencesValue('CONTENT_LANGUAGE', $switch);
    my $macro = "%SWITCHTEXT{de=\"Bier\" ja=\"sake\" default=\"Beer\"}%";
    return Foswiki::Func::expandCommonVariables($macro);
}

sub _beverageCLDT {
    my $switch = shift;

    Foswiki::Func::setPreferencesValue('CONTENT_LANGUAGE', $switch);

    my $macro = "%SWITCHTEXT{de=\"Bier\" ja=\"sake\" default=\"Beer\" defaultTo=\"de\"}%";
    return Foswiki::Func::expandCommonVariables($macro);
}


sub test_SwitchTextWithStandard {
    my $this = shift;

    $this->assert_equals("Bier", _beverage('de'));
    $this->assert_equals("sake", _beverage('ja'));
    $this->assert_equals("Bier", _beverageDT('de'));
    $this->assert_equals("sake", _beverageDT('ja'));
}

sub test_SwitchTextWithStandardDefault {
    my $this = shift;

    $this->assert_equals("Beer", _beverage('xy'));
    $this->assert_equals("Beer", _beverage(''));
}

sub test_SwitchTextWithStandardDefaultTo {
    my $this = shift;

    $this->assert_equals("Bier", _beverageDT('xy'));
    $this->assert_equals("Bier", _beverageDT(''));
}

sub test_SwitchTextContentLanguage {
    my $this = shift;

    $this->assert_equals("Bier", _beverageCL('de'));
    $this->assert_equals("sake", _beverageCL('ja'));
    $this->assert_equals("Bier", _beverageCLDT('de'));
    $this->assert_equals("sake", _beverageCLDT('ja'));
}

sub test_SwitchTextContentLanguageDefault {
    my $this = shift;

    $this->assert_equals("Beer", _beverageCL('xy'));
    $this->assert_equals("Beer", _beverageCL(''));
}

sub test_SwitchTextContentLanguageDefaultTo {
    my $this = shift;

    $this->assert_equals("Bier", _beverageDT('xy'));
    $this->assert_equals("Bier", _beverageDT(''));
}

sub test_SwitchTemplateWithStandard {
    my $this = shift;

    $this->assert_equals("Page", _page('en'));
    $this->assert_equals("Seite", _page('de'));
    $this->assert_equals("Language not found", _page('xy'));
}

sub test_SwitchTemplateContentLanguage {
    my $this = shift;

    $this->assert_equals("Page", _pageCL('en'));
    $this->assert_equals("Seite", _pageCL('de'));
    $this->assert_equals("Language not found", _pageCL('xy'));
}

1;
__END__
Foswiki - The Free and Open Source Wiki, http://foswiki.org/

Author: ModellAachen

Copyright (C) 2008-2011 Foswiki Contributors. Foswiki Contributors
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
