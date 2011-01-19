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

#sub index :Path :Args(0) {
#    my ( $self, $c ) = @_;
#    
#    #$c->stash->{'template'}="static.tt";
#    $c->forward('default');
#}

sub default :Private {
    my ( $self, $c ) = @_;
    # remove this if not running in apache (can we do this automatically?)
    $c->require_ssl;
    ############################################################################
    # Attempt to authenticate if credentials were passed
    ############################################################################
    if( (defined($c->req->param("username")))&&(defined($c->req->param("password")))){
        $c->forward('login');
    }
    ############################################################################
    # If the session user isn't defined, forward to logout.
    ############################################################################
    if(! defined( $c->session->{'user'} )){ $c->forward('logout'); }
    ############################################################################
    # Log us out if ?logout=1 was sent
    ############################################################################
    if(defined($c->req->param("logout"))){ $c->forward('logout'); }
    ############################################################################
    # If we're logged in, send us to the application, othewise the login page.
    ############################################################################
    if(!defined $c->session->{'user'}){
        $c->stash->{template}="default.tt";
        $c->detach();
    }
    $c->forward('application');
}

sub application :Private {
    my ( $self, $c ) = @_;
    if( $c->request->arguments->[0]){
        # shift @{ $c->request->arguments } if( $c->request->arguments->[0] eq "smegdap" );
        if( $c->request->arguments->[0] eq "contextmenu" ){
            $c->forward('contextmenu');
            $c->detach();
        }elsif( $c->request->arguments->[0] eq "form" ){
            $c->forward('selectform');
            $c->detach();
        }elsif( $c->request->arguments->[0] eq "jstree" ){
            $c->forward('jstreemenu');
            $c->detach();
        }elsif( $c->request->arguments->[0] eq "rename" ){
            $c->response->headers->header( 'content-type' => "application/json" );
            $c->res->body($self->json_wrap({'status' => 1}));
        }elsif( $c->request->arguments->[0] eq "select" ){
            $c->response->headers->header( 'content-type' => "application/json" );
            $c->res->body($self->json_wrap({'status' => 1}));
        }elsif( $c->request->arguments->[0] eq "create" ){
            $c->forward('createnode');
        }else{
            $c->response->headers->header( 'content-type' => "application/json" );
            $c->res->body($self->json_wrap({'status' => 1}));
        }
    }else{
        $c->stash->{'template'}="application.tt";
    }
}

sub createnode : Local {
    my ( $self, $c ) = @_;
    my @createline = @{ $c->request->arguments )if($createline[0] eq 'create');
    my $what = shift @createline;
    if(!defined($what)){ 
        $c->response->headers->header( 'content-type' => "application/json" );
        $c->res->body($self->json_wrap({'status' => 0}));
        $c->detach();
    }
    if($what eq 'domain'({
        foreach my $type ("_tcp","_tls","_ssl"){
            my $records = $c->model('DNSResolver')->srv("_ldap.".$type);
            push (@{ $connections->{$type} }, @{ $records }) if $records;
        }
        print STDERR Data::Dumper->Dump([$connections]);
    }
    #foreach my $type(keys(%{ $connections }){
    #}
    $c->response->headers->header( 'content-type' => "application/json" );
    $c->res->body($self->json_wrap({'status' => 1}));
}

sub jstreemenu : Local {
    my ( $self, $c ) = @_;
    my $menu_tree;
      
    my $connections; 
    $c->model('DNSResolver')->domain("websages.com");
    push( @{ $menu_tree }, [
                             {
                               'attr' => { 'id' => 'connections', "rel" => "drive"},
                               'data' => { 'title' => 'Connections', 'state' => 'closed'},
#                               'children' => [ {
#                                                 'attr' => { 'id' => 'domain:websages.com', "rel" => "folder" },
#                                                 'data' => { 'title' => 'websages.com', 'state' => 'closed'},
#                                                 'children' => [ {
#                                                                   'attr' => { 'id' => 'host:odin.websages.com', "rel" => "folder" },
#                                                                   'data' => { 'title' => 'ldaps://odin.websages.com:636', 'state' => 'closed'},
#                                                                 },
#                                                                 {
#                                                                   'attr' => { 'id' => 'host:freyr.websages.com', "rel" => "folder" },
#                                                                   'data' => { 'title' => 'ldaps://freyr.websages.com:636', 'state' => 'closed'},
#                                                                 },
#                                                               ],
#                                               }
#                                              ],
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
sub login : Global {
    my ( $self, $c ) = @_;
    $c->authenticate({
                       id       => $c->req->param("username"),
                       password => $c->req->param("password")
                     }, 'ldap-people');
    if(defined($c->user)){
        $c->session->{'user'}=$c->user;
        $c->stash->{'orgunit'}='People';
        $c->forward('application');
    }else{
        $c->authenticate({
                           id       => $c->req->param("username"),
                           password => $c->req->param("password")
                         },
                         'ldap-hosts');
        if(defined($c->user)){
            $c->session->{'user'}=$c->user;
            $c->stash->{'orgunit'}='Hosts';
            $c->forward('application');
        }else{
            $c->stash->{'ERROR'}="Authentication Failed.";
            $c->forward('logout');
        }
    }
}

sub logout : Global {
    my ( $self, $c ) = @_;
    # remove all user handles
    my $justloggedout=0;
    $justloggedout=1 if(defined $c->session->{'user'});
    delete $c->session->{'user'};
    delete $c->session->{'username'};
    # expire our session
    $c->delete_session("logout");
    $c->stash->{template}="default.tt";
    $c->res->redirect('/') if $justloggedout;
    $c->detach();
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
