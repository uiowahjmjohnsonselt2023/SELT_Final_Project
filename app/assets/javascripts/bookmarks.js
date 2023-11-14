$(document).ready(function() {
  $(document).on('click', '#bookmark-button', function() {
    var $button = $(this);
    var itemId = $button.data('item-id');

    //var isBookmarked = $(this).data('bookmarked') === true || $(this).data('bookmarked') === 'true';
    var isBookmarked = Boolean($button.data('bookmarked'));
    var method = isBookmarked ? 'DELETE' : 'POST';
    var url = '/bookmarks' + (isBookmarked ? '/' + itemId : '');

    // debug
    console.log('itemId: ' + itemId);
    console.log('isBookmarked: ' + isBookmarked);

    $.ajax({
      method: method,
      url: url,
      data: { item_id: itemId, _method: method },
      dataType: 'json',
      success: function(response) {
        // Toggle the bookmarked state
        isBookmarked = !isBookmarked;
        $button.data('bookmarked', isBookmarked);
        $button.text(isBookmarked ? 'Unbookmark' : 'Bookmark');

        alert(response.message);
      },
      error: function(response) {
        var errorMessage = response.responseJSON && response.responseJSON.message ? response.responseJSON.message : 'An error occurred';
        alert(errorMessage);
      }
    });
  });
});
