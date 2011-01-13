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
    push( @{ $menu_tree },
          {
            'attributes' => { 'id' =>  unpack("H*","new_cert") },
            'data' => { 'title' => 'My Certificate', 'icon' => 'file'},
          }
        );
    push( @{ $menu_tree },
          {
            'attributes' => { 'id' =>  unpack("H*","logout") },
            'data' => { 'title' => 'Logout', 'icon' => 'forbidden'},
          }
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
