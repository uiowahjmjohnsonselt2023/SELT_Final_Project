$(document).ready(function() {
  $(document).on('click', '#bookmark-button', function() {
    var $button = $(this);
    var itemId = $button.data('item-id');
    var isBookmarked = Boolean($button.data('bookmarked'));
    var method = isBookmarked ? 'DELETE' : 'POST';
    var url = '/bookmarks' + (isBookmarked ? '/' + itemId : '');

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
