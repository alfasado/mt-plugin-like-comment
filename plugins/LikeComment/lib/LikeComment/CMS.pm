package LikeComment::CMS;
use strict;
use Data::Dumper;

sub _app_comments_like {
    my $app = shift;
    my $component = MT->component( 'LikeComment' );
    my $user = _get_user( $app );
    my $blog = $app->blog;
    my $json = {};
    if (! $user ) {
        $json->{ status } = 'error';
        $json->{ message } = $component->translate( 'Not logged in.' );
        return MT::Util::to_json( $json );
    }
    if (! $blog ) {
        $json->{ status } = 'error';
        $json->{ message } = $component->translate( 'No Blog.' );
        return MT::Util::to_json( $json );
    }
    my $comment;
    my $comment_id = $app->param( 'comment_id' );
    if (! $comment_id ) {
        $json->{ error } = 1;
        $json->{ message } = $component->translate( 'No Comment.' );
        return MT::Util::to_json( $json );
    } else {
        $comment = MT->model( 'comment' )->load( $comment_id );
        if ( $comment && ( $comment->blog_id != $blog->id ) ) {
            $json->{ status } = 'error';
            $json->{ message } = $component->translate( 'No Comment.' );
            return MT::Util::to_json( $json );
        }
    }
    if (! $comment ) {
        $json->{ status } = 'error';
        $json->{ message } = $component->translate( 'No Comment.' );
        return MT::Util::to_json( $json );
    }
    $json->{ comment_id } = $comment->id;
    my $_type = $app->param( '_type' );
    if (! $_type ) {
        $json->{ status } = 'error';
        $json->{ message } = $component->translate( '_type patametar is required.' );
        $json->{ likes } = _get_likes( $comment );
        return MT::Util::to_json( $json );
    }
    my $obj = MT->model( 'likecomment' )->get_by_key( { author_id => $user->id,
                                                        comment_id => $comment->id } );
    if (! $obj->id ) {
        $obj->blog_id( $comment->blog_id );
        $obj->entry_id( $comment->entry_id );
    }
    if ( $_type eq 'add_like' ) {
        if ( $obj->like == 1 ) {
            $json->{ status } = 'not changed';
            $json->{ message } = $component->translate( 'You like this comment.' );
            $json->{ likes } = _get_likes( $comment );
            return MT::Util::to_json( $json );
        }
        $obj->like( 1 );
        $obj->not_like( 0 );
        $obj->save or die $obj->errstr;
        $json->{ status } = 'success';
        $json->{ message } = $component->translate( 'You like this comment.' );
        $json->{ likes } = _get_likes( $comment );
        return MT::Util::to_json( $json );
    } elsif ( $_type eq 'add_not_like' ) {
        if ( $obj->not_like == 1 ) {
            $json->{ status } = 'not changed';
            $json->{ message } = $component->translate( 'You do not like this comment.' );
            $json->{ likes } = _get_likes( $comment );
            return MT::Util::to_json( $json );
        }
        $obj->not_like( 1 );
        $obj->like( 0 );
        $obj->save or die $obj->errstr;
        $json->{ status } = 'success';
        $json->{ message } = $component->translate( 'You do not like this comment.' );
        $json->{ likes } = _get_likes( $comment );
        return MT::Util::to_json( $json );
    } elsif ( $_type eq 'take_like' ) {
        if ( $obj->like != 1 ) {
            $json->{ status } = 'not changed';
            $json->{ message } = $component->translate( 'You do not have to evaluate this comment.' );
            $json->{ likes } = _get_likes( $comment );
            return MT::Util::to_json( $json );
        }
        $obj->like( 0 );
        $obj->save or die $obj->errstr;
        $json->{ status } = 'success';
        $json->{ message } = $component->translate( 'You do not have to evaluate this comment.' );
        $json->{ likes } = _get_likes( $comment );
        return MT::Util::to_json( $json );
    } elsif ( $_type eq 'take_not_like' ) {
        if ( $obj->not_like != 1 ) {
            $json->{ status } = 'not changed';
            $json->{ message } = $component->translate( 'You do not have to evaluate this comment.' );
            $json->{ likes } = _get_likes( $comment );
            return MT::Util::to_json( $json );
        }
        $obj->not_like( 0 );
        $obj->save or die $obj->errstr;
        $json->{ status } = 'success';
        $json->{ message } = $component->translate( 'You do not have to evaluate this comment.' );
        $json->{ likes } = _get_likes( $comment );
        return MT::Util::to_json( $json );
    } elsif ( $_type eq 'get_likes' ) {
        $json->{ status } = 'success';
        $json->{ message } = $component->translate( 'Likes of this comment.' );
        $json->{ likes } = _get_likes( $comment );
        return MT::Util::to_json( $json );
    } else {
        $json->{ status } = 'error';
        $json->{ message } = $component->translate( '_type patametar is invalid.' );
        $json->{ likes } = _get_likes( $comment );
        return MT::Util::to_json( $json );
    }
    $json->{ status } = 'error';
    $json->{ message } = $component->translate( 'Unknown Error.' );
    $json->{ likes } = _get_likes( $comment );
    return MT::Util::to_json( $json );
}

sub _get_likes {
    my $comment = shift;
    my $like_obj = MT->model( 'likecomment' )->count( { comment_id => $comment->id, like => 1 } );
    my $not_like_obj = MT->model( 'likecomment' )->count( { comment_id => $comment->id, not_like => 1 } );
    my $result = { like => $like_obj, not_like => $not_like_obj, total => $like_obj + $not_like_obj };
    return $result;
}

sub _get_user {
    my $app = MT->instance;
    my $user = $app->user;
    if (! $user ) {
        my $sess_obj;
        ( $sess_obj, $user ) = $app->get_commenter_session();
        if (! $user ) {
            my %cookies = $app->cookies();
            if ( my $cookie = $cookies{ mt_user } ) {
                my $value = $cookie->{ value };
                if ( ( ref $value ) eq 'ARRAY' ) {
                    $value = @$value[ 0 ];
                    my @v = split( /::/, $value );
                    $user = MT->model( 'author' )->load( { name => $v[ 0 ] } );
                }
            }
        }
    }
    if ( $user && $user->status != 1 ) {
        $user = undef;
    }
    $user;
}

1;