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
        }elsif( $c->request->arguments->[0] eq "form" ){
            $c->forward('selectform');
            $c->detach();
        }elsif( $c->request->arguments->[0] eq "contextmenu" ){
            $c->forward('contextmenu');
            $c->detach();
        }elsif( $c->request->arguments->[0] eq "select" ){
            $c->response->headers->header( 'content-type' => "application/json" );
            $c->res->body($self->json_wrap({'status' => 1}));
        }elsif( $c->request->arguments->[0] eq "rename" ){
            $c->response->headers->header( 'content-type' => "application/json" );
            $c->res->body($self->json_wrap({'status' => 1}));
        }else{
            $c->response->headers->header( 'content-type' => "application/json" );
            $c->res->body($self->json_wrap({'status' => 1}));
            #$c->stash->{'template'}="application.tt";
        }
    }else{
        $c->stash->{'template'}="application.tt";
    }
}

sub jstreemenu : Local {
    my ( $self, $c ) = @_;
    my $menu_tree;
    push( @{ $menu_tree }, [
                             {
                               'attr' => { 'id' => 'connections', "rel" => "drive"},
                               'data' => { 'title' => 'Connections', 'state' => 'closed'},
                               'children' => [ {
                                                 'attr' => { 'id' => 'domain:websages.com', "rel" => "folder" },
                                                 'data' => { 'title' => 'websages.com', 'state' => 'closed'},
                                                 'children' => [ {
                                                                   'attr' => { 'id' => 'host:', "rel" => "folder" },
                                                                   'data' => { 'title' => 'websages.com', 'state' => 'closed'},
                                                                 },
                                                                 {
                                                                   'attr' => { 'id' => 'domain:websages.com', "rel" => "folder" },
                                                                   'data' => { 'title' => 'websages.com', 'state' => 'closed'},
                                                                 },
                                                               ],
                                               }
                                              ],
#                               'children' => [
#                                               {
#                                                 'attr' => { 'id' => 'host:faraday.eftdomain.net', "rel" => "folder" },
#                                                 'data' => { 'title' => 'ldaps://faraday.eftdomain.net:636', 'state' => 'closed'},
#                                                 'children' => [
#                                                                 {
#                                                                   'attr' => { 'id' => 'host:faraday.eftdomain.net:dc--eftdomain,dc=net', "rel" => "folder" },
#                                                                   'data' => { 'title' => 'dc=eftdomain,dc=net', 'state' => 'closed'},
#                                                                   'children' => [
#                                                                                   {
#                                                                                     'attr' => { 
#                                                                                                 'id' => 'host:faraday.eftdomain.net:dc--eftdomain,dc--net:ou--Group', 
#                                                                                                 'rel' => 'folder' },
#                                                                                     'data' => { 'title' => 'ou=Group', 'state' => 'closed'},
#                                                                                   },
#                                                                                   {
#                                                                                     'attr' => { 
#                                                                                                 'id' => 'host:faraday.eftdomain.net:dc--eftdomain,dc--net:ou--Hosts', 
#                                                                                                 'rel' => 'folder' },
#                                                                                     'data' => { 'title' => 'ou=Hosts', 'state' => 'closed'},
#                                                                                   },
#                                                                                   {
#                                                                                     'attr' => { 
#                                                                                                 'id' => 'host:faraday.eftdomain.net:dc--eftdomain,dc--net:ou--People', 
#                                                                                                 'rel' => 'folder' },
#                                                                                     'data' => { 'title' => 'ou=People', 'state' => 'closed'},
#                                                                                   },
#                                                                                 ]
#                                                                 },
#                                                               ]
#                                               },
#                                               {
#                                                 'attr' => { 'id' => 'host:maxwell.eftdomain.net', "rel" => "folder" },
#                                                 'data' => { 'title' => 'ldaps://maxwell.eftdomain.net:636', 'state' => 'closed'},
#                                               },
#                                             ]
                             },
                             {
                               'attr' => { 'id' => 'logout', "rel" => 'logout' },
                               'data' => { 'title' => 'Logout', 'state' => ''},
                             },
                           ]
        );
    $c->response->headers->header( 'content-type' => "application/json" );
    $c->res->body($self->json_wrap($menu_tree, {'pretty' => 1}));
}

sub selectform : Local {
    my ( $self, $c ) = @_;
    $c->res->body(join("/", @{ $c->request->arguments }));
}

sub contextmenu : Local {
    my ( $self, $c ) = @_;
    my $json='{ "create" : { 
                             "separator_before" : false,
                             "separator_after"  : true,
                             "label"            : "create",
                             "action"           : "function (obj) { this.create(obj); }"
                           },
              }';
#                "rename" : {
#                          "separator_before" : false,
#                          "separator_after"  : false,
#                          "label"            : "rename",
#                          "action"           : function (obj) { this.rename(obj); }
#                  },
#               "remove" : {
#                          "separator_before" : false,
#                          "icon"             : false,
#                          "separator_after"  : false,
#                          "label"            : "delete",
#                          "action"           : function (obj) { this.remove(obj); }
#                  },
#               "ccp" : {
#                          "separator_before" : true,
#                          "icon"             : false,
#                          "separator_after"  : false,
#                          "label"            : "edit",
#                          "action"           : false,
#                          "submenu"          : { 
#                                                 "cut"   : { 
#                                                             "separator_before" : false,
#                                                             "separator_after"  : false,
#                                                             "label"            : "cut",
#                                                             "action"           : function (obj) { this.cut(obj); }
#                                                           },
#                                                 "copy"  : { 
#                                                             "separator_before" : false,
#                                                             "icon"             : false,
#                                                             "separator_after"  : false,
#                                                             "label"            : "copy",
#       "action"           : function (obj) { this.copy(obj); }
#                                                           },
#                                                 "paste" : { 
#                                                             "separator_before" : false,
#                                                             "icon"             : false,
#                                                             "separator_after"  : false,
#                                                             "label"            : "paste",
#                                                             "action"           : function (obj) { this.paste(obj); }
#                                                           }
#                          }
#                   }
#    }';
    $c->response->headers->header( "content-type" => "application/json" );
    $c->res->body($json);

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
