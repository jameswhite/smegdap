package smegdap::Model::DNSResolver;

use strict;
use warnings;
use parent 'Catalyst::Model';
use Net::DNS;

sub domain {
    my $self = shift;
    $self->{'domain'} = shift if @_;
    return $self->{'domain'};
}

# my @users = $c->model('DNSResolver')->get_domain;
sub srv {
    my $self = shift;
    my $search = shift;
    return undef unless $search;
    my $res = Net::DNS::Resolver->new;
    my $servers;
    my $query = $res->query($search.".".$self->domain, "SRV");
    if ($query){
        foreach my $rr (grep { $_->type eq 'SRV' } $query->answer) {
            my $host=$rr->{'target'};
            if($rr->{'port'} == 636){ push(@{ $servers },"ldaps://$host:636"); }
            if($rr->{'port'} == 389){ push(@{ $servers },"ldap://$host:389"); }
        }
    }
    return $servers if $servers;
    return undef;
}
=head1 NAME

smegdap::Model::DNSResolver - Catalyst Model

=head1 DESCRIPTION

Catalyst Model.

=head1 AUTHOR

James White

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
