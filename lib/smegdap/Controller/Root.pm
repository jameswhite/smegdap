package smegdap::Controller::Root;

use strict;
use warnings;
use parent 'Catalyst::Controller';
use JSON;

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config->{namespace} = '';

=head1 NAME

smegdap::Controller::Root - Root Controller for smegdap

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=cut

=head2 index

=cut

sub json_wrap{
    my $self=shift;
    my $map=shift;
     if($JSON::VERSION >= 2.00){
         return JSON::to_json($map, {'pretty'=>1});
     }else{
         return JSON::objToJson($map, {'pretty'=>1});
     }
}

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    
    #$c->stash->{'template'}="static.tt";
    $c->stash->{'template'}="application.tt";
}

sub default :Path {
    my ( $self, $c ) = @_;
    print STDERR Data::Dumper->Dump([$c->request->arguments]);
    if( $c->request->arguments->[0]){
        if( $c->request->arguments->[0] eq "jstree" ){
            $c->forward('jstreemenu');
            $c->detach();
        }elsif( $c->request->arguments->[0] eq "select" ){
            $c->res->body($self->json_wrap({'status' => 1}));
        }elsif( $c->request->arguments->[0] eq "rename" ){
            $c->res->body($self->json_wrap({'status' => 1}));
        }else{
            $c->stash->{'template'}="application.tt";
        }
    }else{
        $c->stash->{'template'}="application.tt";
    }
    
}

sub jstreemenu : Local {
    my ( $self, $c ) = @_;
    my $menu_tree;
    #my $certificate_tree=$c->model('Certificates')->tree();
    #if($c->check_user_roles( "certificate_administrators" )){
    push( @{ $menu_tree }, [
                             {
                               'attr' => { 'id' => 'conn', "rel" => "drive"},
                               'data' => { 'title' => 'Connections', 'state' => 'closed'},
                               'children' => [
                                               {
                                                 'attr' => { 'id' => 'host:faraday.eftdomain.net', "rel" => "folder" },
                                                 'data' => { 'title' => 'faraday.eftdomain.net', 'state' => 'closed'},
                                                 'children' => [
                                                                 {
                                                                   'attr' => { 'id' => 'host:faraday.eftdomain.net:dc--eftdomain,dc=net', "rel" => "folder" },
                                                                   'data' => { 'title' => 'dc=eftdomain,dc=net', 'state' => 'closed'},
                                                                   'children' => [
                                                                                   {
                                                                                     'attr' => { 
                                                                                                 'id' => 'host:faraday.eftdomain.net:dc--eftdomain,dc--net:ou--Group', 
                                                                                                 'rel' => 'folder' },
                                                                                     'data' => { 'title' => 'ou=Group', 'state' => 'closed'},
                                                                                   },
                                                                                   {
                                                                                     'attr' => { 
                                                                                                 'id' => 'host:faraday.eftdomain.net:dc--eftdomain,dc--net:ou--Hosts', 
                                                                                                 'rel' => 'folder' },
                                                                                     'data' => { 'title' => 'ou=Hosts', 'state' => 'closed'},
                                                                                   },
                                                                                   {
                                                                                     'attr' => { 
                                                                                                 'id' => 'host:faraday.eftdomain.net:dc--eftdomain,dc--net:ou--People', 
                                                                                                 'rel' => 'folder' },
                                                                                     'data' => { 'title' => 'ou=People', 'state' => 'closed'},
                                                                                   },
                                                                                 ]
                                                                 },
                                                               ]
                                               },
                                               {
                                                 'attr' => { 'id' => 'host:maxwell.eftdomain.net', "rel" => "folder" },
                                                 'data' => { 'title' => 'maxwell.eftdomain.net', 'state' => 'closed'},
                                               },
                                             ]
                             },
                             {
                               'attr' => { 'id' => 'logout', "rel" => 'drive' },
                               'data' => { 'title' => 'Logout', 'state' => ''},
                             },
                           ]
        );
    $c->res->body($self->json_wrap($menu_tree, {'pretty' => 1}));
}

=head2 end

Attempt to render a view, if needed.

=cut 

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

James White

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
