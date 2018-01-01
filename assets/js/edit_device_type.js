

// Used in admin/device_type.haml

$(document).ready(function() {

    $('select.control-type').change(function() {
        $(this).parents('.one-control').find('.selectable-items').toggleClass('hidden', this.value !== 'select');
        $(this).parents('.one-control').find('.add-selectable-item').toggleClass('hidden', this.value !== 'select');
    });

    $('.button.add-selectable-item').click(function() {
        var lastItem = $(this).parents('.one-control').find(".selectable-items .selectable-item:last");
        var newItem = lastItem.clone(true);
        newItem.find('input').val('');
        newItem.toggleClass('fade-in', true);
        newItem.insertAfter(lastItem);
    });

    $('.button.delete-selectable-item').click(function() {
        var thisItem = $(this).parents('.selectable-item');
        var otherItems = thisItem.parent().find('.selectable-item');
        if (otherItems.length > 1) {
            thisItem.remove();
        }
    });

    $('.button.delete-control').click(function() {
        var thisItem = $(this).parents('.one-control');
        var otherItems = $('#controls').find('.one-control');
        if (otherItems.length > 1) {
            thisItem.remove();
            if (otherItems.length == 2) {
                $('.button.delete-control').toggleClass('disabled', true);
            }
        };
    });

    $('.button.add-control').click(function() {
        var newItem = $('#control-template .one-control').clone(true);
        $('#controls').append(newItem);
        $('.button.delete-control').toggleClass('disabled', false);
    });

});
