package LikeComment::Tags;
use strict;
use Data::Dumper;

sub _hdlr_comment_like_count {
    my ( $ctx, $args, $cond ) = @_;
    my $component = MT->component( 'LikeComment' );
    my $tokens = $ctx->stash( 'tokens' );
    my $builder = $ctx->stash( 'builder' );
    my $comment = $ctx->stash( 'comment' );
    if (! $comment ) {
        return 0; # or $ctx->error( $component->translate( '' ) );
    }
    require LikeComment::CMS;
    my $likes = MT->request( 'LikeComment:' . $comment->id )
        || LikeComment::CMS::_get_likes( $comment );
    MT->request( 'LikeComment:' . $comment->id, $likes );
    return $likes->{ like };
}

sub _hdlr_comment_not_like_count {
    my ( $ctx, $args, $cond ) = @_;
    my $component = MT->component( 'LikeComment' );
    my $tokens = $ctx->stash( 'tokens' );
    my $builder = $ctx->stash( 'builder' );
    my $comment = $ctx->stash( 'comment' );
    if (! $comment ) {
        return 0; # or $ctx->error( $component->translate( '' ) );
    }
    require LikeComment::CMS;
    my $likes = MT->request( 'LikeComment:' . $comment->id )
        || LikeComment::CMS::_get_likes( $comment );
    MT->request( 'LikeComment:' . $comment->id, $likes );
    return $likes->{ not_like };
}

sub _hdlr_comment_total_count {
    my ( $ctx, $args, $cond ) = @_;
    my $component = MT->component( 'LikeComment' );
    my $tokens = $ctx->stash( 'tokens' );
    my $builder = $ctx->stash( 'builder' );
    my $comment = $ctx->stash( 'comment' );
    if (! $comment ) {
        return 0; # or $ctx->error( $component->translate( '' ) );
    }
    require LikeComment::CMS;
    my $likes = MT->request( 'LikeComment:' . $comment->id )
        || LikeComment::CMS::_get_likes( $comment );
    MT->request( 'LikeComment:' . $comment->id, $likes );
    return $likes->{ total };
}

sub _hdlr_if_author_like {
    my ( $ctx, $args, $cond ) = @_;
    my $component = MT->component( 'LikeComment' );
    my $app = MT->instance;
    return 0 if ( ref( $app ) !~ m!^MT::App::! );
    my $author = $app->user || return 0;
    my $comment = $ctx->stash( 'comment' ) || return 0;
    my $likecomment = MT->request( 'LikeAuthorComment:' . $comment->id . ':' .$author->id );
    if (! $likecomment ) {
        $likecomment = MT->model( 'likecomment' )->load( { comment_id => $comment->id, author_id => $author->id } );
    }
    if ( $likecomment ) {
        MT->request( 'LikeAuthorComment:' . $comment->id . ':' .$author->id, $likecomment );
        if ( $likecomment->like ) {
            return 1;
        }
    }
    return 0;
}

sub _hdlr_if_author_not_like {
    my ( $ctx, $args, $cond ) = @_;
    my $component = MT->component( 'LikeComment' );
    my $app = MT->instance;
    return 0 if ( ref( $app ) !~ m!^MT::App::! );
    my $author = $app->user || return 0;
    my $comment = $ctx->stash( 'comment' ) || return 0;
    my $likecomment = MT->request( 'LikeAuthorComment:' . $comment->id . ':' .$author->id );
    if (! $likecomment ) {
        $likecomment = MT->model( 'likecomment' )->load( { comment_id => $comment->id, author_id => $author->id } );
    }
    if ( $likecomment ) {
        MT->request( 'LikeAuthorComment:' . $comment->id . ':' .$author->id, $likecomment );
        if ( $likecomment->not_like ) {
            return 1;
        }
    }
    return 0;
}

1;