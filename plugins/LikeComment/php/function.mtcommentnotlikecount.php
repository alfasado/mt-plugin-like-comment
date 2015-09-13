<?php
function smarty_function_mtcommentnotlikecount ( $args, &$ctx ) {
    $comment = $ctx->stash( 'comment' );
    if (! $comment ) {
        return 0; //or return $ctx->error();
    }
    $comment_id = $comment->id;
    $likes = $ctx->stash( 'likecomment:' . $comment_id );
    if ( $likes ) {
        return $likes[ 'not_like' ];
    }
    require_once( 'class.mt_likecomment.php' );
    $_like = new LikeComment;
    $where = "likecomment_comment_id=${comment_id} AND likecomment_like=1";
    $like = $_like->Find( $where, FALSE, FALSE, array() );
    $where = "likecomment_comment_id=${comment_id} AND likecomment_not_like=1";
    $not_like = $_like->Find( $where, FALSE, FALSE, array() );
    $total = count( $like ) + count( $not_like );
    $likes = array( 'like' => count( $like ),
                    'not_like' => count( $not_like ),
                    'total' => $total );
    $ctx->stash( 'likecomment:' . $comment_id, $likes );
    return $likes[ 'not_like' ];
}
?>