package smegdap::Model::LDAP;

use strict;
use warnings;
use base qw/Catalyst::Model::LDAP/;

__PACKAGE__->config(
    host              => '',
    base              => '',
    dn                => '',
    password          => '',
    start_tls         => 0,
    start_tls_options => { verify => 'require' },
    options           => {},  # Options passed to search
);

=head1 NAME

smegdap::Model::LDAP - LDAP Catalyst model component

=head1 SYNOPSIS

See L<smegdap>.

=head1 DESCRIPTION

LDAP Catalyst model component.

=head1 AUTHOR

James White

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
