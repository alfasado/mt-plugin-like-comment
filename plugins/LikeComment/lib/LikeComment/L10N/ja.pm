package LikeComment::L10N::ja;
use strict;
use base 'LikeComment::L10N';

use vars qw( %Lexicon );

our %Lexicon = (
    'BlogID' => 'ブログID',
    'like_comment' => 'コメント評価',
    'Date' => '日付',
    'EntryID' => '記事ID',
    'like_comments' => 'コメント評価',
    'AuthorID' => 'ユーザーID',
    'User likes to comment.' => 'コメントを評価します。',
    'Like' => '評価',
    'Not logged in.' => 'ログインしていません。',
    'No Blog.' => 'ブログが指定されていません。',
    'No Comment.' => 'コメントが指定されていません。',
    '_type patametar is required.' => '_typeパラメタは必須です。',
    'You like this comment.' => 'あなたは既にコメントを評価しています。',
    'You do not like this comment.' => 'あなたは既にコメントを評価していません。',
    'You do not have to evaluate this comment.' => 'あなたはまだコメントを評価していません。',
    'Likes of this comment.' => 'このコメントへの評価です。',
    '_type patametar is invalid.' => '_typeパラメタが不正です。',
    'Unknown Error.' => 'エラーが発生しました。原因は不明。',
    );

1;