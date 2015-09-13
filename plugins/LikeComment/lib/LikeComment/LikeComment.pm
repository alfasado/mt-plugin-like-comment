package LikeComment::LikeComment;
use strict;

use base qw( MT::Object );
__PACKAGE__->install_properties( {
    column_defs => {
        'liked_on' => {
            'label' => 'Date',
            'type' => 'datetime'
        },
        'like' => {
            'label' => 'Like',
            'type' => 'boolean'
        },
        'not_like' => {
            'label' => 'Not Like',
            'type' => 'boolean'
        },
        'author_id' => {
            'label' => 'AuthorID',
            'type' => 'integer'
        },
        'blog_id' => {
            'label' => 'BlogID',
            'type' => 'integer'
        },
        'id' => 'integer not null auto_increment',
        'entry_id' => {
            'label' => 'EntryID',
            'type' => 'integer'
        },
        'comment_id' => {
            'label' => 'CommentID',
            'type' => 'integer'
        }
    },
    indexes => {
        'liked_on' => 1,
        'like' => 1,
        'author_id' => 1,
        'blog_id' => 1,
        'entry_id' => 1,
        'comment_id' => 1
    },
    datasource => 'likecomment',
    primary_key => 'id',
    child_of => [ 'MT::Blog', 'MT::Website' ],
} );

sub component_name {
    my $obj = shift;
    return 'LikeComment'; ##
}

sub class_label {
    my $obj = shift;
    MT->component( $obj->component_name )->translate( 'like_comment' );
}

sub class_label_plural {
    my $obj = shift;
    MT->component( $obj->component_name )->translate( 'like_comments' );
}

sub show_columns {
    my @show_cols = qw( blog_id author_id entry_id like liked_on );
    return @show_cols;
}

sub _nextprev {
    my ( $obj, $direction ) = @_;
    my $nextprev = MT->request( "likecomment_$direction:" . $obj->id );
    return $nextprev if defined $nextprev;
    $nextprev = $obj->nextprev(
        direction => $direction,
        terms     => { blog_id => $obj->blog_id },
        by        => 'created_on',
    );
    MT->request( "likecomment_$direction:" . $obj->id, $nextprev );
    return $nextprev;
}

sub blog {
    my $obj = shift;
    if ( $obj->has_column( 'blog_id' ) ) {
        if ( my $blog_id = $obj->blog_id ) {
            require MT::Blog;
            my $blog = MT::Blog->load( $blog_id );
            return $blog if defined $blog;
        }
    }
    return undef;
}

1;