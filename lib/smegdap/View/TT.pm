package smegdap::View::TT;

use strict;
use base 'Catalyst::View::TT';

__PACKAGE__->config(
                     TEMPLATE_EXTENSION => '.tt',
                     INCLUDE_PATH => [ 
                                       smegdap->path_to( 'root', 'src' ),
                                     ],

                   );

=head1 NAME

smegdap::View::TT - TT View for smegdap

=head1 DESCRIPTION

TT View for smegdap. 

=head1 AUTHOR

=head1 SEE ALSO

L<smegdap>

James White

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
