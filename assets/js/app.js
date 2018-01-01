
$(document).ready(function(){

    $('.message .close')
        .on('click', function() {
            $(this)
                .closest('.message')
                .transition('fade')
            ;
        });

});

jQuery.fn.flash = function(color) {
    var element = this;
    element.toggleClass('highlighted-' + color + ' highlighted-transition', true);
    setTimeout(function() {
        element.toggleClass('highlighted-' + color, false);
        setTimeout(function() {
            element.toggleClass('highlighted-transition', false);
        }, 300);
    }, 300);
};
