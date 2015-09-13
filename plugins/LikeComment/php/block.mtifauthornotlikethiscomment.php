<?php
function smarty_block_mtifauthornotlikethiscomment ( $args, $content, &$ctx, &$repeat ) {
    $comment = $ctx->stash( 'comment' );
    if (! $comment ) {
        return $ctx->_hdlr_if( $args, $content, $ctx, $repeat, FALSE );
    }
    $comment_id = $comment->id;
    $app = $ctx->stash( 'bootstrapper' );
    $author = $app->user();
    if (! $author ) {
        return $ctx->_hdlr_if( $args, $content, $ctx, $repeat, FALSE );
    }
    $author_id = $author->id;
    $like = $ctx->stash( 'likeauthorcomment:' . $comment_id . ':' . $author_id );
    if ( $like ) {
        if ( $like->not_like ) {
            return $ctx->_hdlr_if( $args, $content, $ctx, $repeat, TRUE );
        } else {
            return $ctx->_hdlr_if( $args, $content, $ctx, $repeat, FALSE );
        }
    }
    require_once( 'class.mt_likecomment.php' );
    $_like = new LikeComment;
    $where = "likecomment_comment_id=${comment_id} AND likecomment_author_id=${author_id}";
    $like = $_like->Find( $where, FALSE, FALSE, array( 'limit' => 1 ) );
    if ( is_array( $like ) ) {
        $like = $like[ 0 ];
        $ctx->stash( 'likeauthorcomment:' . $comment_id . ':' . $author_id, $like );
    }
    if ( $like->not_like ) {
        return $ctx->_hdlr_if( $args, $content, $ctx, $repeat, TRUE );
    }
    return $ctx->_hdlr_if( $args, $content, $ctx, $repeat, FALSE );}
?>