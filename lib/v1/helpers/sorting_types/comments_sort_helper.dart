enum CommentSortTypes {
  Confidence,
  Top,
  New,
  Controversial,
  Old,
  Random,
  QandA,
  Live,
  Best,
}

Map<CommentSortTypes, String> changeCommentSortConvertToString = {
  CommentSortTypes.Confidence: 'confidence',
  CommentSortTypes.Top: 'top',
  CommentSortTypes.New: 'new',
  CommentSortTypes.Controversial: 'controversial',
  CommentSortTypes.Old: 'old',
  CommentSortTypes.Random: 'random',
  CommentSortTypes.QandA: 'qa',
  CommentSortTypes.Live: 'live',
  CommentSortTypes.Best: 'best',
};

Map<String, CommentSortTypes> changeCommentSortConvertToEnum = {
  'confidence': CommentSortTypes.Confidence,
  'top': CommentSortTypes.Top,
  'new': CommentSortTypes.New,
  'controversial': CommentSortTypes.Controversial,
  'old': CommentSortTypes.Old,
  'random': CommentSortTypes.Random,
  'qa': CommentSortTypes.QandA,
  'live': CommentSortTypes.Live,
  'best': CommentSortTypes.Best,
};
