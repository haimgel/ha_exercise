

// Used in admin/device_type.haml

$(document).ready(function() {

    $('select.control-type').change(function() {
        $(this).parents('tr').find('.selectable-items').toggleClass('hidden', this.value !== 'select');
    });

    $('.button.add-selectable-item').click(function() {
        var lastItem = $(this).parents('tr').find(".selectable-items div.ui.input:last");
        var newItem = lastItem.clone(true);
        newItem.find('input').val('');
        newItem.toggleClass('fade-in', true);
        newItem.insertAfter(lastItem);
    });

    $('.button.delete-selectable-item').click(function() {
        var thisItem = $(this).parents('div.ui.input');
        var otherItems = thisItem.parent().find('div.ui.input');
        if (otherItems.length > 1) {
            thisItem.remove();
        }
    });

    $('.button.delete-control').click(function() {
        var thisItem = $(this).parents('tr');
        var otherItems = thisItem.parent('tbody').find('tr');
        if (otherItems.length > 1) {
            thisItem.remove();
        }
    });

    $('.button.add-control').click(function() {
        var parent = $(this).parents('table').find('tbody');
        var newItem = $('#control-new').clone(true).attr('id', null);
        parent.append(newItem);
    });

});
