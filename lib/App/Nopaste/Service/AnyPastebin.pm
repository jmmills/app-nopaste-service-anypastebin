package App::Nopaste::Service::AnyPastebin;

use warnings;
use strict;
use Scalar::Util 'blessed';

use base q[App::Nopaste::Service];

our $VERSION = '0.01';

sub uri { return 'http://pastebin.com/' }

sub forbid_in_default { 0 }

sub get {
    my $self = shift;
    my $mech = shift;
    my %args = @_;
    
    $mech->{__username} = $args{username}
        if exists($args{username}) && $args{username};
    $mech->{__password} = $args{password}
        if exists($args{password}) && $args{password};
    
    return $self->SUPER::get($mech => @_);
}

sub fill_form {
    my ($self, $mech) = (shift, shift);
    my %args = @_;
    
    my $header = {
        'User-Agent' => 'Mozilla/5.0',
        'Content-Type' => 'application/x-www-form-urlencoded'
    };
    
    my $content = {
        paste => 'Send',
        code2 => $args{text},
        poster => exists($args{nick})? $args{nick} : '',
        format => exists($self->FORMATS->{$args{lang}})? $args{lang} : 'text',
        expiry => 'd'
    };
    
    $mech->agent_alias('Linux Mozilla');
    my $form = $mech->form_name('editor') || return;
    
    # do not follow redirect please
    @{$mech->requests_redirectable} = ();
    
    my $paste = HTML::Form::Input->new(
        type => 'text',
        value => 'Send',
        name => 'paste'
    )->add_to_form($form);
    
    return $mech->submit_form( form_name => 'editor', fields => $content );
}

sub return {
    my ($self, $mech) = (shift, shift);
    
    return unless blessed($mech->res) && $mech->res->can('header');
    
    my $result  = $mech->res->header('Location')? 1 : 0;
    my $link_or_err = $result? $mech->res->header('Location') : 'Error!';
    
    return (1, $link_or_err);
}

use constant FORMATS => {
    abap => 1,
    actionscript => 1,
    ada => 1,
    apache => 1,
    applescript => 1,
    asm => 1,
    asp => 1,
    autoit => 1,
    bash => 1,
    blitzbasic => 1,
    bnf => 1,
    c => 1,
    c_mac => 1,
    caddcl => 1,
    cadlisp => 1,
    cfm => 1,
    cpp => 1,
    csharp => 1,
    css => 1,
    d => 1,
    delphi => 1,
    diff => 1,
    dos => 1,
    eiffel => 1,
    erlang => 1,
    fortran => 1,
    freebasic => 1,
    genero => 1,
    gml => 1,
    groovy => 1,
    haskell => 1,
    html4strict => 1,
    idl => 1,
    ini => 1,
    inno => 1,
    java => 1,
    javascript => 1,
    latex => 1,
    lisp => 1,
    lsl2 => 1,
    lua => 1,
    m68k => 1,
    matlab => 1,
    mirc => 1,
    mpasm => 1,
    mysql => 1,
    nsis => 1,
    objc => 1,
    ocaml => 1,
    oobas => 1,
    oracle8 => 1,
    pascal => 1,
    perl => 1,
    php => 1,
    plswl => 1,
    python => 1,
    qbasic => 1,
    rails => 1,
    robots => 1,
    ruby => 1,
    scheme => 1,
    smalltalk => 1,
    smarty => 1,
    sql => 1,
    tcl => 1,
    text => 1,
    unreal => 1,
    vb => 1,
    vbnet => 1,
    visualfoxpro => 1,
    xml => 1,
    z80 => 1
};

1;

=head1 NAME

App::Nopaste::Service::AnyPastebin - nopaste to any pastebin that runs the same nopaste service as http://pastebin.com/ 

=head1 AUTHOR

Jason M Mills, C<< <jmmills at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-app-nopaste-service-pastebinproper at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=App-Nopaste-Service-AnyPastebin>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc App::Nopaste::Service::AnyPastebin


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=App-Nopaste-Service-AnyPastebin>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/App-Nopaste-Service-AnyPastebin>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/App-Nopaste-Service-AnyPastebin>

=item * Search CPAN

L<http://search.cpan.org/dist/App-Nopaste-Service-AnyPastebin/>

=back


=head1 SEE ALSO

L<App::Nopaste::Service>

=head1 LICENSE AND COPYRIGHT

Copyright 2010 Jason M Mills.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

